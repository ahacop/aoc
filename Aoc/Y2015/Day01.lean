import Aoc.Core

namespace Aoc.Y2015.Day01

def parseStep (x : Char) : Except String Int :=
  match x with
  | '(' => pure 1
  | ')' => pure (-1)
  | _ => throw s!"expected ( or ), found {x.quote}"

def parse (input : String) : Except String (Array Int) :=
  input.trimAsciiEnd.toString.toList.toArray.mapM parseStep

def part1 (input : String) : Except String String := do
  let steps <- parse input
  pure s!"{steps.foldl (· + ·) 0}"

def findBasement (steps : Array Int) : Except String Nat := do
  let mut currentFloor := 0
  for h : i in [0:steps.size] do
    currentFloor := currentFloor + steps[i]
    if currentFloor = -1 then return i + 1
  throw "Santa never enters the basement"

def part2 (input : String) : Except String String := do
  let steps <- parse input
  pure s!"{<- findBasement steps}"

#guard part1 "(())" matches .ok "0"
#guard part1 ")())())" matches .ok "-3"
#guard part2 "()())" matches .ok "5"
#guard part1 "(x)" matches .error _
#guard part2 "((" matches .error _

end Aoc.Y2015.Day01
