import ../base

type
  GeminiTranslator* = ref object of Translator
    defaultModel = "gemini-flash-lite-latest"

proc newGeminiTranslator*(tl: var Translator; option: Option[AITranslatorOption] = none(AITranslatorOption)) =
  tl = GeminiTranslator()
  tl.host = "generativelanguage.googleapis.com"
  tl.name = "gemini"
  tl.aiOption = option

method processApiKey(tl: GeminiTranslator): Option[JsonNode] {.gcsafe.} =
  let
    headerJson = newJObject()

  if tl.aiOption.isSome:
    headerJson["x-goog-api-key"] = %tl.aiOption.get.apiKey
    return some headerJson

  none JsonNode

method translate*(tl: GeminiTranslator; content: string; inputLang: Languages): string =
  var
    modelName = tl.aiOption.get.model

  if modelName == "":
    tl.log.info("Using default model.")
    modelName = tl.defaultModel

  let
    prompt = tl.promptTemplate % [inputLang.getCountryName(), tl.outputLang.getCountryName(), content]
    url = "/v1beta/models/$#:generateContent" % [modelName]
    payload = %*{
      "contents": [{
        "parts": [{
          "text": prompt
      }]
    }]
    }

  let
    response = tl.con.req(url, HttpPost, payload = payload)
    jsonNode = response.to_json()

  try:
    if jsonNode.hasKey("candidates") and jsonNode["candidates"].len > 0:
      let candidate = jsonNode["candidates"][0]
      if candidate.hasKey("content") and candidate["content"].hasKey("parts"):
        return candidate["content"]["parts"][0]["text"].getStr()

    if jsonNode.hasKey("error"):
      return "Error: " & $jsonNode["error"]

    return ""
  except:
    return "Exception parsing response"
