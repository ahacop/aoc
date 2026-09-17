import Aoc.Core

namespace Aoc.Y2020.Day01

def parse (input : String) : Except String (List Nat) :=
  lines input |>.mapM fun l =>
    match l.toNat? with
      | some n => pure n
      | none => throw s!"parse error at {l}"

def part1 (input : String) : Except String String := do
  let expenses <- parse input
  for x in expenses do
    for y in expenses do
      if 2020 == x + y then return s!"{x * y}"
  throw s!"could not find pair"

def part2 (input : String) : Except String String := do
  let expenses <- parse input
  for x in expenses do
    for y in expenses do
      for z in expenses do
        if 2020 == x + y + z then return s!"{x * y * z}"
  throw s!"could not find pair"

#guard part1 "1721\n979\n366\n299\n675\n1456"
  matches .ok "514579"

#guard part2 "1721\n979\n366\n299\n675\n1456"
  matches .ok "241861950"

end Aoc.Y2020.Day01
