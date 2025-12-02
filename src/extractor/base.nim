import
  xmltree,
  q

import  
  ./types,
  ../http/[
    client,
    response
  ]  

import ../media/[types]

type
  BaseExtractor {.inheritable.} = ref object of RootObj
    name*: string
    info*: InfoExtractor
    connection*: HttpConnection
    initialized: bool = false

method sInit*(extractor: BaseExtractor) : InfoExtractor {.base.} = discard

method animes*(ex: BaseExtractor, title: string) : seq[AnimeData] {.base.} = discard
method get*(ex: BaseExtractor, data: AnimeData) : string {.base.} = data.url

method episodes*(ex: BaseExtractor, url: string) : seq[EpisodeData] {.base.} = discard
method get*(ex: BaseExtractor, data: EpisodeData) : string {.base.} = data.url

method formats*(ex: BaseExtractor, url: string) : seq[ExFormatData] {.base.} = discard
method get*(ex: BaseExtractor, data: ExFormatData) : MediaFormatData {.base.} = discard

proc init*[T: BaseExtractor](
  extractor: T,
  proxy: string = "",
  userAgent: string = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:146.0) Gecko/20100101 Firefox/146.0",
  resolution: FormatResolution = best
) : T =
  extractor.info = extractor.sInit()
  extractor.connection = newHttpConnection(
    extractor.info.host,
    userAgent,
    extractor.info.http_headers
  )

  extractor.initialized = true
  result = extractor

proc main_el*(extractor: BaseExtractor, url: string, query: string) : XmlNode =
  extractor.connection
    .req(url)
    .to_selector()
    .select(query)[0]

proc main_els*(extractor: BaseExtractor, url: string, query: string) : seq[XmlNode] =
  extractor.connection
    .req(url)
    .to_selector()
    .select(query)

export
  BaseExtractor,
  InfoExtractor

export  
  AnimeData,
  EpisodeData,
  ExFormatData

export  
  MediaFormatData,
  MediaSubtitle,
  MediaExt,
  MediaHttpHeader
