import Aoc.Core

namespace Aoc.Y2019.Day01

def parseNat (s : String) : Option Nat :=
  s.toNat?

def calculate (n : Nat) : Nat := (n / 3) - 2

def part1 (input : String) : Except String String := do
  let some xs := lines input |>.mapM parseNat
    |>.map (·.map calculate) | throw "e"

  pure s!"{xs.sum}"

def calc2 (x : Nat) (xs : List Nat) : List Nat :=
  let val : Nat := (x / 3) - 2
  if val = 0 then xs else calc2 val (xs.concat val)

def part2 (input : String) : Except String String := do
  let some xs := lines input |>.mapM parseNat
    |>.map (fun x => x.map (fun y => calc2 y [])) | throw "e"

  let result : Nat := xs.foldl (· + ·.sum) 0
  pure s!"{result}"

#guard part1 "12" matches .ok "2"
#guard part1 "14" matches .ok "2"
#guard part1 "1969" matches .ok "654"
#guard part1 "100756" matches .ok "33583"

#guard part2 "14" matches .ok "2"
#guard part2 "1969" matches .ok "966"
#guard part2 "100756" matches .ok "50346"

end Aoc.Y2019.Day01
