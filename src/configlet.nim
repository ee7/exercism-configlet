import std/[posix]
import "."/[cli, info/info, lint/lint, logger, sync/check, sync/sync, uuid/uuid]

proc main =
  onSignal(SIGTERM):
    quit(0)

  let conf = processCmdLine()

  setupLogging(conf)

  case conf.action.kind
  of actNil:
    discard
  of actInfo:
    info(conf)
  of actLint:
    lint(conf)
  of actSync:
    if conf.action.check:
      check(conf)
    else:
      sync(conf)
  of actUuid:
    uuid(conf.action.num)

main()
