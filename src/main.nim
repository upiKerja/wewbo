import std/[
  terminal,
  os,
  strutils,
  json
]
import ui/[
  ask,
  controller,
]
import ./options
import ./extractor/all
import ./player/all

proc main*() =
  var
    anime: AnimeData
    anime_url: string
    episodes: seq[EpisodeData]
    episode: EpisodeData
    start_idx: int
    playerName: string

  let
    players = getAvailabePlayer()
    title = optionsParser.nargs[0]
    extractorName = optionsParser.get("name").getStr()
    extractor = get_extractor_from_source(extractorName)
    animes = extractor.animes(title)

  if players.len < 1 :
    raise newException(ValueError, "There are no Players available on your device")

  if animes.len < 1 :
    raise newException(ValueError, "No anime found")

  anime = animes.ask(title="Searching for '$#'" % [title])
  anime_url = extractor.get anime
  episodes = extractor.episodes anime_url

  if episodes.len < 1 :
    raise newException(ValueError, "No episode found")

  episode = episodes.ask(title = anime.title)
  start_idx = episodes.find episode
  playerName = optionsParser.get("player").getStr()

  if playerName == "" and players.contains("mpv") :
    playerName = "mpv"

  else :
    playerName = "ffplay"

  main_controller_loop(
    extractor,
    getPlayer(playerName),
    episodes,
    start_idx
  )  

when isMainModule :
  main()