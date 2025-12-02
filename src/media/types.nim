import std/[
  options,
]

type  
  MediaHttpHeader* = object of RootObj
    userAgent*: string
    referer*: string
    cookie*: string

  MediaSubtitle* = object of RootObj
    url*: string
    lang*: string = ""
    target*: string = ""

  MediaExt* = enum
    extNone, extMp4, extM3u8

  MediaResolution* = enum
    rBest, rWorst

  MediaFormatData* = object of RootObj
    video*: string
    typeExt*: MediaExt
    subtitle*: Option[MediaSubtitle] = none(MediaSubtitle)
    headers*: Option[MediaHttpHeader] = none(MediaHttpHeader)  
