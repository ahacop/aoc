import Aoc.Core

namespace Aoc.Y2022.Day01

def caloriesByElf (input : String) : Except String (List Nat) :=
  input.splitOn "\n\n"
    |>.mapM (List.sum <$> parseNats ·)

def part1 (input : String) : Except String String := do
  let some most := (<- caloriesByElf input)
    |>.max? | throw "no elves"

  pure s!"{most}"

def part2 (input : String) : Except String String := do
  let topThree := (<- caloriesByElf input)
    |>.mergeSort (· >= ·)
    |>.take 3
    |>.sum

  pure s!"{topThree}"

def exampleInput := "1000\n2000\n3000\n\n4000\n\n5000\n6000\n\n7000\n8000\n9000\n\n10000"

#guard part1 exampleInput matches .ok "24000"
#guard part2 exampleInput matches .ok "45000"
#guard part1 (exampleInput ++ "\n") matches .ok "24000"

end Aoc.Y2022.Day01
