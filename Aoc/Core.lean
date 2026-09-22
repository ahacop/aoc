namespace Aoc

/-- A solution reads the puzzle input and returns the answer to print.
Input that the solution cannot use gives `.error` with an error message. -/
abbrev Solver := String -> Except String String

/-- One part of one puzzle, together with the year and day it belongs to.
`Aoc.solutions` holds one of these per part, and `solve` looks up the answer
by matching all three numbers against its command line arguments. -/
structure Entry where
  year : Nat
  day : Nat
  part : Nat
  solve : Solver

/-- The input split into lines. `main` removes the final newline of the
input, so the last line is not empty. Empty input gives `.error`, because
`"".splitOn "\n"` returns `[""]`. -/
def lines (input : String) : Except String (List String) :=
  match input.splitOn "\n" with
  | [""] => throw "empty input"
  | ls => pure ls

#guard lines "" matches .error _
#guard lines "a" matches .ok ["a"]
#guard lines "a\n\nb" matches .ok ["a", "", "b"]

/-- The input split into lines, with `f` applied to each line. A line that `f`
cannot parse gives `.error` with that line in the message. -/
def parseLines (f : String -> Option α) (input : String) : Except String (List α) := do
  (← lines input).mapM fun l =>
    (f l).getDM (throw s!"cannot parse line {l.quote}")

#guard parseLines String.toNat? "1\n2" matches .ok [1, 2]
#guard parseLines String.toNat? "1\nx" matches .error _
#guard parseLines String.toNat? "" matches .error _

end Aoc
