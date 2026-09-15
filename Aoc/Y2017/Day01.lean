import Aoc.Core

namespace Aoc.Y2017.Day01

def parseStep (x : Char) : Except String Nat := do
  let some n := x.toString.toNat?
    | throw s!"bad {x.quote}"
  pure n

def parse (input : String) : Except String (List Nat) :=
  input.trimAscii.toString.toList.mapM parseStep

def part1 (input : String) : Except String String := do
  let xs <- parse input
  let ys := xs.zip (xs.rotateLeft 1)
    |>.filterMap fun x => if x.fst = x.snd then some (x.fst) else none
  pure s!"{ys.sum}"

def part2 (input : String) : Except String String := do
  let xs <- parse input
  let skip := xs.toArray.size / 2
  let ys := xs.zip (xs.rotateLeft skip)
    |>.filterMap fun x => if x.fst = x.snd then some (x.fst) else none
  pure s!"{ys.sum}"

#guard (part1 "1122") matches (.ok "3")
#guard (part1 "1111") matches (.ok "4")
#guard (part1 "1234") matches (.ok "0")
#guard (part1 "91212129") matches (.ok "9")

#guard (part2 "1212") matches (.ok "6")
#guard (part2 "1221") matches (.ok "0")
#guard (part2 "123425") matches (.ok "4")
#guard (part2 "123123") matches (.ok "12")
#guard (part2 "12131415") matches (.ok "4")

end Aoc.Y2017.Day01
