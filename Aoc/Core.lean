namespace Aoc

/-- A solution reads the whole puzzle input and returns the answer to print. -/
abbrev Solver := String → String

/-- One part of one puzzle, together with the year and day it belongs to.
`Aoc.solutions` holds one of these per part, and `solve` looks up the answer
by matching all three numbers against its command line arguments. -/
structure Entry where
  year : Nat
  day : Nat
  part : Nat
  solve : Solver

/-- The input split into lines. Advent of Code ends every input with a
newline, which would otherwise give an empty final line. Only that one
newline is removed, so a line that really does end in spaces keeps them. -/
def lines (input : String) : List String :=
  let body := if input.endsWith "\n" then (input.dropEnd 1).toString else input
  body.splitOn "\n"

end Aoc
