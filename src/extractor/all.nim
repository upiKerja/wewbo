from strutils import `%`
import
  base,
  extractors/[
    animepahe,
    kuramanime,
    otakudesu,
    hianime
  ]

proc getExtractor(name: string) : BaseExtractor =
  let sources: array[4, BaseExtractor] = [
    AnimepaheEX(name: "pahe"),
    OtakudesuEX(name: "taku"),
    KuramanimeEX(name: "kura"),
    HianimeEX(name: "hian")
  ]

  for source in sources :
    if source.name == name :
      return source.init()

  raise newException(ValueError, "No source found: " & "'$#'" % [name])        

proc get_extractor_from_source(name: string = "pahe") : BaseExtractor =
  name.getExtractor() 

export
  BaseExtractor,
  AnimeData,
  EpisodeData,
  ExFormatData,
  get_extractor_from_source,
  getExtractor,
  init,
  animes,
  episodes,
  formats,
  get
