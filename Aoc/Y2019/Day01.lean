import Aoc.Core

namespace Aoc.Y2019.Day01

def calculate (n : Nat) : Nat := (n / 3) - 2

def part1 (input : String) : Except String String := do
  let xs ← parseNats input
  pure s!"{(xs.map calculate).sum}"

def calc2 (x : Nat) (xs : List Nat) : List Nat :=
  let val : Nat := (x / 3) - 2
  if val = 0 then xs else calc2 val (val :: xs)

def part2 (input : String) : Except String String := do
  let xs ← parseNats input
  pure s!"{(xs.flatMap (calc2 · [])).sum}"

#guard part1 "12" matches .ok "2"
#guard part1 "14" matches .ok "2"
#guard part1 "1969" matches .ok "654"
#guard part1 "100756" matches .ok "33583"
#guard part1 "12\n14\n1969\n100756" matches .ok "34241"
#guard part1 "x" matches .error _

#guard part2 "14" matches .ok "2"
#guard part2 "1969" matches .ok "966"
#guard part2 "100756" matches .ok "50346"
#guard part2 "14\n1969\n100756" matches .ok "51314"

end Aoc.Y2019.Day01
