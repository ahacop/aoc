import Aoc.Core
import Std.Data.HashMap

open Std
open Std.Internal.Parsec String

namespace Aoc.Y2024.Day01

def locationIdPair : Parser (Nat × Nat) := do
  let n1 <- digits
  ws
  let n2 <- digits
  return ⟨n1, n2⟩

def locationIds : Parser (Array (Nat × Nat)) := do
  let ids <- many (locationIdPair <* skipChar '\n')
  eof
  return ids

def parse (input : String) : Except String ((Array Nat) × (Array Nat)) := do
  let ids <- locationIds.run input
  pure ids.unzip

def dist (a : Nat) (b : Nat) : Nat := max a b - min a b

def part1 (input : String) : Except String String := do
  let (lefts, rights) <- parse input
  let sum := lefts.mergeSort.zipWith dist rights.mergeSort
    |>.sum

  pure s!"{sum}"

def incOrOne (n : Option Nat) := n.map .succ |>.or (some 1)

def part2 (input : String) : Except String String := do
  let (lefts, rights) <- parse input
  let counts : HashMap Nat Nat :=
    rights.foldl (fun acc n => acc.alter n incOrOne) {}
  let sum := lefts.map (fun n => n * counts.getD n 0) |>.sum
  pure s!"{sum}"

def example1 := "3   4\n4   3\n2   5\n1   3\n3   9\n3   3\n"

#guard part1 example1 matches .ok "11"
#guard part2 example1 matches .ok "31"

end Aoc.Y2024.Day01
