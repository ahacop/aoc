import Aoc.Core
import Std.Data.HashSet
open Std

namespace Aoc.Y2016.Day01

inductive Direction where
  | North
  | South
  | East
  | West

structure Point where
  x : Int
  y : Int
  deriving BEq, Hashable

def Direction.delta : Direction -> Point
  | .North => { x := 0, y := 1 }
  | .South => { x := 0, y := -1 }
  | .East => { x := 1, y := 0 }
  | .West => { x := -1, y := 0 }

inductive Rotation where
  | Right
  | Left
  deriving Inhabited

structure Location where
  coordinates : Point
  direction : Direction

structure Instruction where
  rotation : Rotation
  numberOfBlocks : Nat

def rotate (d : Direction) (r : Rotation) : Direction :=
  match d, r with
  | .North, .Right => .East
  | .South, .Right => .West
  | .East, .Right => .South
  | .West, .Right => .North
  | .North, .Left => .West
  | .South, .Left => .East
  | .East, .Left => .North
  | .West, .Left => .South

instance : Add Point where
  add p q := { x := p.x + q.x, y := p.y + q.y }

instance : HMul Nat Point Point where
  hMul n p := { x := n * p.x, y := n * p.y }

def walk (l : Location) (n : Nat) : Location :=
  { l with coordinates := l.coordinates + n * l.direction.delta }

def turn (l : Location) (r : Rotation) : Location :=
  { l with direction := rotate l.direction r }

def execute (l : Location) (i : Instruction) : Location :=
  l |> (turn . i.rotation) |> (walk . i.numberOfBlocks)

def origin : Point := { x := 0, y := 0 }

def toInstruction (s : String) : Instruction :=
  let rotation := match s.front with
  | 'R' => Rotation.Right
  | 'L' => Rotation.Left
  | _ => panic! s!"Bad input"
  { rotation, numberOfBlocks := (s.drop 1).toNat! }

def calcDistance (p : Point) (q : Point) : Nat :=
  (p.x - q.x).natAbs + (p.y - q.y).natAbs

def startingLocation : Location :=
  { direction := .North, coordinates := origin }

def part1 (input : String) : String :=
  let finalLocation := input.trimAscii.toString.splitOn ", "
    |>.map toInstruction
    |>.foldl execute startingLocation
  s!"{calcDistance finalLocation.coordinates origin}"

def findFirst (xs : List Instruction) : Location := Id.run do
  let mut currentLocation := startingLocation
  let mut visited := HashSet.ofList [startingLocation.coordinates]

  for i in xs do
    currentLocation := turn currentLocation i.rotation
    for _ in 0...i.numberOfBlocks do
      currentLocation := walk currentLocation 1
      if visited.contains currentLocation.coordinates then return currentLocation
      visited := visited.insert currentLocation.coordinates
  currentLocation

def part2 (input : String) : String :=
  let finalLocation := input.trimAscii.toString.splitOn ", "
    |>.map toInstruction
    |> findFirst
  s!"{calcDistance finalLocation.coordinates origin}"

#guard part1 "R2, L3" == "5"
#guard part1 "R2, R2, R2" == "2"
#guard part1 "R5, L5, R5, R3" == "12"
#guard part2 "R8, R4, R4, R8" == "4"

end Aoc.Y2016.Day01
