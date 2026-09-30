import Aoc.Core
import Std.Internal.Parsec

open Std.Internal.Parsec String

namespace Aoc.Y2025.Day01

inductive Direction where
  | Left
  | Right
  deriving Repr

structure Rotation where
  direction : Direction
  distance : Nat
  deriving Repr

def rotation : Parser Rotation := do
  let direction <- match <- asciiLetter with
  | 'L' => pure Direction.Left
  | 'R' => pure Direction.Right
  | _ => fail "parse error"

  let distance <- digits
  skipChar '\n'

  return { direction, distance }

def rotations : Parser (Array Rotation) := do
  return <- many rotation

abbrev Lock := Fin 100

def Lock.ofNat := Fin.ofNat 100

def Lock.right (l : Lock) (n : Nat) : Lock :=
  l + Lock.ofNat n

def Lock.left (l : Lock) (n : Nat) : Lock :=
  l - Lock.ofNat n

def Lock.rotate (l : Lock) (r : Rotation) : Lock :=
  match r.direction with
    | .Left => l.left r.distance
    | .Right => l.right r.distance

def Lock.zero? (l : Lock) : Bool := l.val == 0

def part1 (input : String) : Except String String := do
  let rotations <- rotations.run input
  let mut lock := (50 : Lock)
  let mut zeroCount := 0
  for r in rotations do
    lock := lock.rotate r
    if lock.zero? then zeroCount := zeroCount + 1

  pure s!"{zeroCount}"

def part2 (input : String) : Except String String := do
  let rotations <- rotations.run input
  let mut lock := (50 : Lock)
  let mut zeroCount := 0
  for r in rotations do
    for _ in [0:r.distance] do
      lock := lock.rotate { direction := r.direction, distance := 1 }
      if lock.zero? then zeroCount := zeroCount + 1

  pure s!"{zeroCount}"

def example1 : String := "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n"

#guard part1 example1 matches .ok "3"
#guard part2 example1 matches .ok "6"

end Aoc.Y2025.Day01
