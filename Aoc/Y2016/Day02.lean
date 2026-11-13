import Aoc.Core
import Std.Internal.Parsec

open Std.Internal.Parsec String

namespace Aoc.Y2016.Day02

inductive Direction where
  | left | right | up | down
  deriving Repr

def direction : Parser Direction :=
  pchar 'L' *> pure .left
  <|> pchar 'R' *> pure .right
  <|> pchar 'U' *> pure .up
  <|> pchar 'D' *> pure .down

#guard direction.run "L" matches .ok .left
#guard direction.run "R" matches .ok .right
#guard direction.run "U" matches .ok .up
#guard direction.run "D" matches .ok .down
#guard direction.run "A" matches .error _

def directions : Parser (Array Direction) :=
  many direction <* skipChar '\n'

#guard directions.run "LRUD\n" matches .ok #[.left, .right, .up, .down]
#guard directions.run "LAUD\n" matches .error _

def instructions : Parser (Array (Array Direction)) :=
  many directions <* eof

#guard instructions.run "U\nL\n" matches .ok #[#[.up], #[.left]]
#guard instructions.run "U\nA\n" matches .error _

abbrev Keypad := Array (Array (Option Char))

def key? (k : Keypad) (r c : Nat) : Option Char := do
  let row <- k[r]?
  let value <- row[c]?
  (<- value)

structure Position (k : Keypad) where
  row : Nat
  col : Nat
  valid : (key? k row col).isSome

def keypad : Keypad := #[
  #['1', '2', '3'],
  #['4', '5', '6'],
  #['7', '8', '9']
]

def middleOfKeypad : Position keypad := ⟨1, 1, by decide⟩

def keypad2 : Keypad := #[
  #[none, none, '1', none, none],
  #[none, '2', '3', '4', none],
  #['5', '6', '7', '8', '9'],
  #[none, 'A', 'B', 'C', none],
  #[none, none, 'D', none, none],
]

def Position.moveTo (cur : Position k) (row col : Int) : Position k :=
  match row.toNat?, col.toNat? with
    | some r, some c =>
    if h : (key? k r c).isSome then ⟨r, c, h⟩
  else cur
    | _, _ => cur

def directionToDelta (d : Direction) : (Int × Int) :=
  match d with
  | .up => (-1, 0)
  | .down => (1, 0)
  | .left => (0, -1)
  | .right => (0, 1)

def Position.moveBy (cur : Position k) (d : Direction) : Position k :=
  let (dr, dc) := directionToDelta d
  let (tr, tc) := (cur.row + dr, cur.col + dc)
  cur.moveTo tr tc

def Position.key (p : Position k) : Char :=
  (key? k p.row p.col).get p.valid

#guard (middleOfKeypad.moveBy .up).key == '2'
#guard ((middleOfKeypad.moveBy .up).moveBy .up).key == '2'

def walkKeypad (p : Position k) (ds : Array Direction) :=
  ds.foldl (·.moveBy ·) p

def step (ds : Array Direction) : StateM (Position k) Char := do
  let next := walkKeypad (<- get) ds
  set next
  pure next.key

def solve (p : Position k) (input : String) : Except String String := do
  let xs <- instructions.run input
  let keys := (xs.mapM step).run' p
  pure (String.ofList keys.toList)

def part1 (input : String) : Except String String := do
  solve middleOfKeypad input

def middleOfKeypad2 : Position keypad2 := ⟨2, 0, by decide⟩

def part2 (input : String) : Except String String := do
  solve middleOfKeypad2 input

def example1 : String := "ULL\nRRDDD\nLURDL\nUUUUD\n"

#guard part1 example1 matches .ok "1985"
#guard part2 example1 matches .ok "5DB3"

end Aoc.Y2016.Day02
