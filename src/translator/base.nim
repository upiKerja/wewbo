import
  options, json, strutils

import
  ../http/[client, response],
  ../tui/logger,
  ../languages

import
  ./types  

const promptTemplateRaw = """
SEP: " ||| "
SYSTEM: Translate this TEXT from $# to $# non-formal and dont answer anything else. And dont replace the {{SEP}} symbol if any.
TEXT: $#

"""

type
  Translator* = ref object of RootObj
    # Requireq
    name*: string
    host*: string
    outputLang*: Languages

    # AI (gemini, openai)
    aiOption*: Option[AITranslatorOption] = none(AITranslatorOption)
    promptTemplate*: string = promptTemplateRaw
    metadata*: JsonNode = newJObject()

    # Internal
    headers: Option[JsonNode]
    con*: HttpConnection
    log*: WewboLogger

method translate*(tl: Translator; content: string; inputLang: Languages = laEn) : string {.gcsafe,base.} = discard
method translate*(tl: Translator; content: Content; inputLang: Languages = laEn) : Content{.gcsafe,base.}  = discard

method processApiKey(tl: Translator) : Option[JsonNode] {.gcsafe,base.} =
  let
    headerJson = newJObject()

  if tl.aiOption.isSome:
    headerJson["Authorization"] = %("Bearer " & tl.aiOption.get.apiKey)
    return some headerJson

  none JsonNode

proc processHeader(tl: Translator) =
  let
    headerApiKey = tl.processApiKey()

  if headerApiKey.isSome and tl.headers.isSome:
    # Merge prev headers
    for key, val in tl.headers.get:
      headerApiKey.get[key] = val

  elif headerApiKey.isSome and tl.headers.isNone:
    tl.headers = headerApiKey

proc init*[T: Translator](translator: T; outputLang: Languages; mode: WewboLogMode = mSilent) = 
  translator.processHeader()
  translator.outputLang = outputLang
  translator.log = useWewboLogger(translator.name, mode=mode)
  translator.con = newHttpConnection(
    translator.host,
    "Mozilla",
    translator.headers,
    mode
  )

proc close*[T: Translator](translator: T) =
  translator.con.close()
  translator.log.stop()
  translator.con = nil
  translator.log = nil

export
  languages,
  options,
  client,
  response,
  json,
  strutils,
  types,
  logger
