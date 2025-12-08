
discard """
  Pernah kah kau merasa? Jrek Jrek.
  Saat. AAA. Bayangmupun tak mampu ku lihat lagiiiii
"""

discard """
  ffmpeg -headers \"Referer: https://megacloud.blog/\" -i URL -vcodec libx264 -crf 28 -preset veryfast -r 25 output.mp4
"""

import
  options,
  strutils,
  tables,
  ../process,
  ../media/types

type
  FfmpegDownloader = ref object of CliApplication
    input: MediaFormatData
    crf: int = 28
    fps: int = 25

proc newFfmpegDownloader() : FfmpegDownloader =
  result.name = "ffmpeg"
  result.setUp()

proc setHeader(ffmpeg: FfmpegDownloader, ty, val: string) =
  let ngantukCok = {
    "userAgent" : "User-Agent",
    "referer" : "Referer",
    "cookie" : "Cookie"
  }.toTable

  ffmpeg.addArg "-headers"
  ffmpeg.addArg "$#: $#" % [ngantukCok[ty], val]

proc setUpHeader(ffmpeg: FfmpegDownloader) =
  let kepala = ffmpeg.input.headers
  if kepala.isSome :
    for chi, no in kepala.get.fieldPairs() :
      if no != "" :
        ffmpeg.setHeader(chi, no)

proc setGatauIniApa(ffmpeg: FfmpegDownloader) =
  # Vcodec
  ffmpeg.addArg "-vcodec"
  ffmpeg.addArg "libx264"

  # Crf
  ffmpeg.addArg "-crf"
  ffmpeg.addArg $ffmpeg.crf

  # Fps
  ffmpeg.addArg "-r"
  ffmpeg.addArg $ffmpeg.fps

proc setInput(ffmpeg: FfmpegDownloader, media: MediaFormatData) =
  ffmpeg.addArg "-i"
  ffmpeg.addArg media.video

proc setOutput(ffmpeg: FfmpegDownloader) =
  ffmpeg.addArg "LinuxRijal.mp4"

proc download*(ffmpeg: FfmpegDownloader, input: MediaFormatData) : bool =
  ffmpeg.setUpHeader()
  ffmpeg.setInput(input)
  ffmpeg.setGatauIniApa()
  ffmpeg.setOutput()

proc downloadAll*(ffmpeg: FfmpegDownloader, inputs: openArray[MediaFormatData]) : seq[bool] =
  for input in inputs :
    result.add(ffmpeg.download(input))

when isMainModule  :
  var
    palla = MediaHttpHeader(
      userAgent: "Mozilla",
      referer: "https://animepahe.si/"
    )
    media = MediaFormatData(
      video: "https://vault-09.uwucdn.top/stream/09/13/24c3b66ebb38310566676549c7df78b458633edd4b63a4f9bb26f704e4f319ca/uwu.m3u8",
      typeExt: extM3u8,
      headers: palla.some
    )
    rijal = newFfmpegDownloader()

  discard rijal.setUp()
  discard rijal.download(media)
  echo rijal.execute()

  # discard curl.download()
  # discard curl.execute()
