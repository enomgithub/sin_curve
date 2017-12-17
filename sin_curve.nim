import dom
from math import sin, floor, degToRad
from strutils import intToStr
from random import random, randomize


const nMin: int = 0
const nMax: int = 359
const ms: int = 16


proc run(bars: array[nMin..nMax, Element]) =
  let firstWidth: cstring = bars[low(bars)].style.width
  for i in low(bars)..high(bars) - 1:
    bars[i].style.width = bars[i + 1].style.width
  bars[high(bars)].style.width = firstWidth


proc init(): array[nMin..nMax, Element] =
  const
    id: cstring = "sin-curve"
    height: int = 1
    amplitude: float = 100.0
    color: cstring = "#302833"
  var bars: array[nMin..nMax, Element]
  for i in low(bars)..high(bars):
    let width: int = (amplitude * sin(degToRad(i.toFloat)) + amplitude).toInt
    bars[i] = document.createElement("div")
    bars[i].style.height = intToStr(height) & "px"
    bars[i].style.width = intToStr(width) & "px"
    bars[i].style.backgroundColor = color
    document.getElementById(id).appendChild(bars[i])
  return bars


proc stopTimer(timer: ref TInterval) =
  if timer != nil:
    clearInterval(window, timer)


proc toggleKey(keyCode: int, timer: ref TInterval) =
  const sKey = 83
  case keyCode
  of sKey: stopTimer(timer)
  else: discard


proc main() =
  randomize()
  var bars: array[nMin..nMax, Element] = init()
  var timer: ref TInterval = setInterval(window,
                                         proc() = run(bars),
                                         ms)
  window.addEventListener("keydown",
                          proc(e: Event) = toggleKey(e.keyCode, timer),
                          false)


when isMainModule:
  main()
