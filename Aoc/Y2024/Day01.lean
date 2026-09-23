import Aoc.Core

open Std.Internal.Parsec String

namespace Aoc.Y2024.Day01

def example1 := "3   4\n4   3\n2   5\n1   3\n3   9\n3   3"

def parse : Parser (Nat × Nat) := do
  let n1 <- digits
  ws
  let n2 <- digits
  return ⟨n1, n2⟩

#eval parse.run "3   4"
#eval parse.run "3x"

def part1 (input : String) : Except String String := do
  let (lefts, rights) <- (<- lines input)
    |>.mapM (parse.run ·)
    |>.map List.unzip
  let sum := (lefts.mergeSort.zip rights.mergeSort).foldl
    (fun acc (a, b) => acc + ((a : Int) - b).natAbs) 0

  pure s!"{sum}"

def count (nats : List Nat) (n : Nat) : Nat :=
  nats.countP (· == n)

def tally (nats : List Nat) (acc : Nat) (n : Nat) : Nat :=
  acc + n * (count nats n)

def part2 (input : String) : Except String String := do
  let (lefts, rights) <- (<- lines input)
    |>.mapM (parse.run ·)
    |>.map List.unzip

  let sum := lefts.mergeSort.foldl (tally rights.mergeSort) 0
  pure s!"{sum}"

#eval part2 example1

#guard part1 example1 matches .ok "11"
#guard part2 example1 matches .ok "31"

end Aoc.Y2024.Day01
