import times, timecop, os

let t1 = getTime()
travelTo t1:
  sleep(1000)
  assert t1 != getTime()
  let diff = getTime().toUnix - t1.toUnix
  assert diff >= 1

let
  t2 = now()
  travel = t2 + initInterval(minutes=15)

travelTo travel:
    echo now() - travel

