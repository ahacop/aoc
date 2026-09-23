import Aoc.Core

namespace Aoc.Y2023.Day01

def toDigit? (c : Char) : Option Nat :=
  if c.isDigit then some (c.toNat - '0'.toNat) else none

def digit? (cs : List Char) : Option Nat :=
  cs.head?.bind toDigit?

def digitWords := ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"].map String.toList |>.zipIdx 1

def digitWord? (cs : List Char) : Option Nat :=
  digitWords.find? (·.1.isPrefixOf cs) |>.map (·.2)

def digitOrWord? (cs : List Char) : Option Nat :=
  digit? cs <|> digitWord? cs

def digits (readDigit : List Char -> Option Nat) (cs : List Char) : List Nat :=
  match cs, readDigit cs with
    | [], _ => []
    | _ :: rest, some n => n :: digits readDigit rest
    | _ :: rest, none => digits readDigit rest

#guard digits digitOrWord? "eightwothree".toList == [8, 2, 3]
#guard digits digitOrWord? "one24".toList == [1, 2, 4]

def calibrationValue (readDigit : List Char -> Option Nat) (str : String) : Option Nat := do
  let xs := digits readDigit str.toList
  let n1 <- xs.head?
  let n2 <- xs.getLast?
  pure (n1 * 10 + n2)

def solve (readDigit : List Char -> Option Nat) (input : String) : Except String String := do
  let some total := (<- lines input)
    |>.mapM (calibrationValue readDigit) | throw "e"

  pure s!"{total.sum}"

def part1 := solve digit?
def part2 := solve digitOrWord?

def example1 := "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"
def example2 := "two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen"

#guard part1 example1 matches .ok "142"
#guard part2 example2 matches .ok "281"

end Aoc.Y2023.Day01
