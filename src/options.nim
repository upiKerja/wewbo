import ./terminal/paramarg

var optionsParser = loadArguments()

optionsParser.add(
  flagT = "-n",
  nameT = "name",
  valT = tString,
  defaultT = "kura"
)

optionsParser.add(
  flagT = "-p",
  nameT = "player",
  valT = tString,
)

optionsParser.parse()

export
  optionsParser,
  paramarg
