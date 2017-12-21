import dom
from math import sin, degToRad
from strutils import intToStr


proc run() =
  let
    bars: seq[Element] = document.getElementsByClassName("bar")
    firstWidth: cstring = bars[low(bars)].style.width
  for i in low(bars)..high(bars) - 1:
    bars[i].style.width = bars[i + 1].style.width
  bars[high(bars)].style.width = firstWidth


proc init(n: int) =
  const
    id: cstring = "sin-curve"
    height: int = 1
    amplitude: float = 100.0
    color: cstring = "#302833"
  for i in 0..n-1:
    let
      width: int = (amplitude * sin(degToRad(i.toFloat)) + amplitude).toInt
      bar: Element = document.createElement("div")
    bar.classList.add("bar")
    bar.style.height = height.intToStr & "px"
    bar.style.width = width.intToStr & "px"
    bar.style.backgroundColor = color
    document.getElementById(id).appendChild(bar)


proc stopTimer(timer: ref TInterval) =
  if timer != nil:
    clearInterval(window, timer)


proc toggleKey(keyCode: int, timer: ref TInterval) =
  const sKey = 83
  case keyCode
  of sKey: stopTimer(timer)
  else: discard


proc main() =
  const MS: int = 16
  const N: int = 360
  init(N)
  var timer: ref TInterval = setInterval(window,
                                         proc() = run(),
                                         MS)
  window.addEventListener("keydown",
                          proc(e: Event) = toggleKey(e.keyCode, timer),
                          false)


when isMainModule:
  main()
