import
  paramarg

import
  tables,
  os

type
  SubCommandProc = proc(narg: seq[string], args: FullArgument) {.nimcall.}

  SubCommand = ref object of RootObj
    name*: string
    entry*: SubCommandProc
    args: FullArgument

proc exec(command: SubCommand) =
  command.args.parse()
  command.entry(command.args.nargs, command.args)

proc start(subCommands: openArray[SubCommand]) =
  try:
    let nuhun = commandLineParams()[0]
    for subCmd in subCommands :
      if nuhun == subCmd.name :
        subCmd.exec()
        quit(0)
    assert false

  except AssertionDefect:
    subCommands[0].exec()

proc newSubCommand(name: string, entry: SubCommandProc) : SubCommand =
  SubCommand(
    name: name,
    entry: entry,
    args: loadArguments()
  )

proc addArg(command: SubCommand, flag: string, name: string, val: AllowedValType, default: auto = "") =
  command.args.add(flag, name, val, default)

when isMainModule :
  proc rijal(n: seq[string]; e: FullArgument) =
    echo e.get("name").getStr()

  var d = newSubCommand("download", rijal)

  d.addArg(
    flag= "-n",
    name= "name",
    val= tString,
    default= "rijal"
  )

  d.exec()
