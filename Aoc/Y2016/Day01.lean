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

def parseInstruction (s : String) : Except String Instruction := do
  let rotation <- match s.front with
    | 'R' => pure Rotation.Right
    | 'L' => pure Rotation.Left
    | _ => throw s!"instruction {s.quote} does not start with R or L"
  let some numberOfBlocks := (s.drop 1).toNat?
    | throw s!"instruction {s.quote} does not end with a number of blocks"
  pure { rotation, numberOfBlocks }

def parse (input : String) : Except String (List Instruction) :=
  input.trimAscii.toString.splitOn ", " |>.mapM parseInstruction

def calcDistance (p : Point) (q : Point) : Nat :=
  (p.x - q.x).natAbs + (p.y - q.y).natAbs

def startingLocation : Location :=
  { direction := .North, coordinates := origin }

def part1 (input : String) : Except String String := do
  let finalLocation := (<- parse input).foldl execute startingLocation
  pure s!"{calcDistance finalLocation.coordinates origin}"

/-- The first location that the walk visits twice. -/
def findFirst (xs : List Instruction) : Except String Location := do
  let mut currentLocation := startingLocation
  let mut visited := HashSet.ofList [startingLocation.coordinates]

  for i in xs do
    currentLocation := turn currentLocation i.rotation
    for _ in 0...i.numberOfBlocks do
      currentLocation := walk currentLocation 1
      if visited.contains currentLocation.coordinates then return currentLocation
      visited := visited.insert currentLocation.coordinates
  throw "the walk never visits a location twice"

def part2 (input : String) : Except String String := do
  let firstRepeat <- findFirst (<- parse input)
  pure s!"{calcDistance firstRepeat.coordinates origin}"

#guard part1 "R2, L3" matches .ok "5"
#guard part1 "R2, R2, R2" matches .ok "2"
#guard part1 "R5, L5, R5, R3" matches .ok "12"
#guard part2 "R8, R4, R4, R8" matches .ok "4"
#guard part1 "X2, L3" matches .error _
#guard part1 "R2, L" matches .error _
#guard part2 "R2, L3" matches .error _

end Aoc.Y2016.Day01
