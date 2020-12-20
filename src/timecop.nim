import times, subhook


type
  Timecop = object
    secs: float
    offset: float
    locked: bool
    travelling: bool

proc timecop_getTime(): Time
proc timecop_epochTime(): float

var
  timecop = Timecop(secs: 0)
  epochTimeHook = initHook(epochTime, timecop_epochTime)
  getTimeHook = initHook(getTime, timecop_getTime)


proc timecop_getTime(): Time =
  if timecop.travelling:
    getTimeHook.remove()
    result = getTime() + initTimeInterval(seconds=timecop.offset.int)
    getTimeHook.install()
  else:
    result = timecop.secs.fromUnixFloat

proc timecop_epochTime(): float =
  if timecop.travelling:
    epochTimeHook.remove()
    result = epochTime() + timecop.offset
    epochTimeHook.install()
  else:
    result = timecop.secs

proc initTimecop() =
  timecop.locked = true
  epochTimeHook.install()
  getTimeHook.install()

proc removeTimecop() =
  epochTimeHook.remove()
  getTimeHook.remove()
  timecop.locked = false

template freeze*(time: typed) =
  if timecop.locked:
    raise newException(IOError, "Timecop is busy")

  timecop.secs =
    when time is int: time.float
    elif time is float: time
    elif time is Time: time.toSeconds
    elif time is DateTime: time.toTime.toUnixFloat
  initTimecop()

template unfreeze*() =
  if timecop.locked:
     removeTimecop()

template freezeAt*(time: typed, body: untyped) =
  freeze(time)
  body
  unfreeze()

template travelTo*(time: typed, body: untyped) =
  timecop.travelling = true
  let secs = getTime().toUnixFloat
  freeze(time)
  timecop.offset = timecop.secs - secs
  body
  unfreeze()
  timecop.travelling = false
