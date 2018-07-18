import times, timecop, os

let t = now()

freezeAt t:
  let t1 = now()
  echo "t1: ", t1
  echo "sleeping for 10s"
  sleep(10000)
  echo "t2: ", now()
  assert t1 == now()

