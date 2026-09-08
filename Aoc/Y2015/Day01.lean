import Aoc.Core

namespace Aoc.Y2015.Day01

def f (x : Char) : Int :=
  if x == '(' then 1 else -1

def part1 (input : String) : String :=
  s!"{((input.toList.map f).sum)}"

def findBasement
  (xs : Array Char) : Int := Id.run do
  let mut currentFloor := 0
  for h : i in [0:xs.size] do
    currentFloor := currentFloor + f xs[i]
    if currentFloor = -1 then return i + 1
  return 0

def part2 (input : String) : String :=
  s!"{(findBasement input.toList.toArray)}"

end Aoc.Y2015.Day01
