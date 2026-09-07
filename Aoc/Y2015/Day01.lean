import Aoc.Core

namespace Aoc.Y2015.Day01

def f (x : Char) : Int :=
  if x == '(' then 1 else -1

def part1 (input : String) : String :=
  s!"{((input.toList.map f).sum)}"

def part2 (input : String) : String :=
  s!"unsolved: {(lines input).length} lines of input"

end Aoc.Y2015.Day01
