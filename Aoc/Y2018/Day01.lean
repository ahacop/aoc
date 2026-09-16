import Aoc.Core
import Std.Data.HashSet
open Std

namespace Aoc.Y2018.Day01

def parseInt (x : String) : Option Int :=
  x.dropPrefix "+" |>.toInt?

#guard parseInt "+1" matches .some 1
#guard parseInt "-1" matches .some (-1)
#guard parseInt "x" matches .none

def part1 (input : String) : Except String String := do
  let some xs := lines input |>.mapM parseInt | throw "e"
  pure s!"{xs.sum}"

def part2 (input : String) : Except String String := do
  let some xs := lines input |>.mapM parseInt | throw "e"
  let mut freq := 0
  let mut visited : HashSet Int := {0}

  repeat
    for x in xs do
      freq := freq + x
      if visited.contains freq then return s!"{freq}"
      visited := visited.insert freq

  unreachable!

#guard part1 "+1\n-2\n+3\n+1" matches .ok "3"
#guard part1 "+1\n+1\n+1" matches .ok "3"
#guard part1 "+1\n+1\n-2" matches .ok "0"
#guard part1 "-1\n-2\n-3" matches .ok "-6"

#guard part2 "+1\n-2\n+3\n+1" matches .ok "2"
#guard part2 "+1\n-1" matches .ok "0"
#guard part2 "+3\n+3\n+4\n-2\n-4" matches .ok "10"
#guard part2 "-6\n+3\n+8\n+5\n-6" matches .ok "5"
#guard part2 "+7\n+7\n-2\n-7\n-4" matches .ok "14"

end Aoc.Y2018.Day01
