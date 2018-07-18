import times, subhook

proc timecop_getTime(): Time =
  echo "hello from Timecop.getTime()"

proc timecop_epochTime(): float =
  echo "hello from Timecop.epochTime()"


var
  hook_epochTime = initHook(epochTime, timecop_epochTime)
  hook_getTime = initHook(getTime, timecop_getTime)



proc initTimecop() =
  hook_epochTime.install()
  hook_getTime.install()

proc removeTimecop() =
  hook_epochTime.remove()
  hook_getTime.remove()

when isMainModule:
  initTimecop()
  let time = cpuTime()

  #discard sleep(100)   # replace this with something to be timed
  echo "Time taken: ",cpuTime() - time

  echo "My formatted time: ", format(now(), "d MMMM yyyy HH:mm")
  echo "Using predefined formats: ", getClockStr(), " ", getDateStr()

  echo "epochTime() float value: ", epochTime()
  echo "cpuTime()   float value: ", cpuTime()
  echo "An hour from now      : ", now() + 1.hours
  echo "An hour from (UTC) now: ", getTime().utc + initInterval(0,0,0,1)
