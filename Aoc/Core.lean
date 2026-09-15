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
input, so the last line is not empty. -/
def lines (input : String) : List String :=
  input.splitOn "\n"

end Aoc
