import extractor/all
import times
import os
import strutils

var extractors: array[4, BaseExtractor] = [
  getExtractor("taku"),
  getExtractor("kura"),
  getExtractor("pahe"),
  getExtractor("hian")
]  

proc doTest[T: BaseExtractor](ex: T) =
  var
    t = cpuTime()
    anime = ex.animes("slow loop")[0]
    episode = ex.episodes(anime.url)[0]
    format = ex.formats(episode.url)[0]
  
  discard ex.get(format).video
  echo "$# - $#" % [ex.name, $(cpuTime() - t)]

for exa in extractors :
  exa.doTest()