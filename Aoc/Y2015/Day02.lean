import Aoc.Core
import Std.Internal.Parsec

open Std.Internal.Parsec String

namespace Aoc.Y2015.Day02

abbrev Dimensions := (Nat × Nat × Nat)

def dimensions : Parser Dimensions := do
  let l <- digits
  skipChar 'x'
  let w <- digits
  skipChar 'x'
  let h <- digits
  return (l, w, h)

def boxes : Parser (Array Dimensions) := do
  let boxes <- many (dimensions <* skipChar '\n')
  eof
  return boxes

def surfaceArea : Dimensions → Nat
  | (l, w, h) => 2 * (l * w + w * h + h * l)

def extraSlack : Dimensions → Nat
  | (l, w, h) => min l w * min (max l w) h

def requiredWrappingPaper : Dimensions → Nat
  | (l, w, h) => surfaceArea (l, w, h) + extraSlack (l, w, h)

def smallestPerimeter : Dimensions → Nat
  | (l, w, h) => 2 * (min l w + min (max l w) h)

def cubicVolume : Dimensions → Nat
  | (l, w, h) => l * w * h

def requiredRibbon : Dimensions → Nat
  | (l, w, h) => smallestPerimeter (l, w, h) + cubicVolume (l, w, h)

def solve (fn : Dimensions → Nat) (input : String) : Except String String := do
  let boxes <- boxes.run input
  let total := boxes.foldl (· + fn ·) 0
  pure s!"{total}"

def part1 := solve requiredWrappingPaper
def part2 := solve requiredRibbon

def example1 : String := "2x3x4\n1x1x10\n"

#eval boxes.run "2x3x4\n1x1x10\n"

#guard dimensions.run "2x3x4\n" matches .ok (2, 3, 4)
#guard dimensions.run "2b\n" matches .error _
#guard surfaceArea (2, 3, 4) matches 52
#guard extraSlack (2, 3, 4) matches 6
#guard extraSlack (1, 1, 10) matches 1
#guard requiredWrappingPaper (2, 3, 4) matches 58
#guard smallestPerimeter (2, 3, 4) matches 10
#guard cubicVolume (2, 3, 4) matches 24
#guard part1 example1 matches .ok "101"
#guard part2 example1 matches .ok "48"

end Aoc.Y2015.Day02
