timecop
========

```
nimble install timecop
```

> timecop requires [subhook](https://github.com/ba0f3/subhook.nim) module and not production ready

timecop provides two helpers `freezeAt` and `travelTo` template, that will helps you do unittest on specified time

### Usage
```nim
import times, timecop

freezeAt now():
  # time never changes inside this code block
  echo now()
  sleep(10_000)
  echo now()  

travelTo now() - 1.days:
  # time will starts on yesterday, and continue running
  echo now()
  sleep(10_000)
  echo now()

```
