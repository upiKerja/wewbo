import
  tables, sequtils, strutils

import translators/[
  google,
  gemini
]

import
  ../tui/logger,
  base

type
  LoaderTranslatorProc = proc(tl: var Translator; option: Option[AITranslatorOption]) {.gcsafe.}
  LoaderTranslatorProcs = Table[string, LoaderTranslatorProc]

proc loaderTranslaterProcs: LoaderTranslatorProcs =
  result["google"] = newGoogleTranslator
  result["gemini"] = newGeminiTranslator

const
  tlLoader = loaderTranslaterProcs()
  tlList = tlLoader.keys.toSeq()

proc getTranslator*(name: string; outputLang: Languages; opt: Option[AITranslatorOption] = none(AITranslatorOption); mode: WewboLogMode = mTui) : Translator =
  if not tlList.contains(name):
    raise newException(ValueError, "Invalid translator: '$#'" % name)

  tlLoader[name](result, opt)
  result.init(outputLang, mode=mode)

when isMainModule:
  let
    opt: AITranslatorOption = (apikey: "AITertipuKamuBangsat", model: "gemini-flash-lite-latest")
    tlg = getTranslator("google", opt = some opt, outputLang = laMs, mode=mSilent)

  echo tlg.translate("Aku mau minum air", inputLang=laId)

export
  options, logger, base, languages
