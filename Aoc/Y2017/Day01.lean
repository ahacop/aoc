import Aoc.Core

namespace Aoc.Y2017.Day01

def parseStep (x : Char) : Except String Nat :=
  match x.toString.toNat? with
    | some n => pure n
    | none => throw s!"{x.quote} is not a Nat"

def parse (input : String) : Except String (List Nat) :=
  input.trimAsciiEnd.toString.toList.mapM parseStep

def sumMatches (xs : List Nat) (offset : Nat) : Nat :=
  xs.zip (xs.rotateLeft offset)
    |>.filter (fun (x, y) => x = y)
    |>.map (·.1)
    |>.sum

def part1 (input : String) : Except String String := do
  let xs <- parse input
  pure s!"{sumMatches xs 1}"

def part2 (input : String) : Except String String := do
  let xs <- parse input
  pure s!"{sumMatches xs (xs.length / 2)}"

#guard part1 "1122" matches .ok "3"
#guard part1 "1111" matches .ok "4"
#guard part1 "1234" matches .ok "0"
#guard part1 "91212129" matches .ok "9"

#guard part2 "1212" matches .ok "6"
#guard part2 "1221" matches .ok "0"
#guard part2 "123425" matches .ok "4"
#guard part2 "123123" matches .ok "12"
#guard part2 "12131415" matches .ok "4"

end Aoc.Y2017.Day01
