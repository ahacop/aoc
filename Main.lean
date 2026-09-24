import Aoc

open Aoc

/-- Read the puzzle input on stdin, print the answer on stdout.

One executable holds every solution. The year, day and part arrive as
arguments and pick an entry out of `Aoc.solutions`. Advent of Code ends
every input with a newline. That one newline is removed before the solution
sees the input. Other whitespace stays, because some puzzles start a line
with spaces that matter. Exit code 1 means no
solution is registered for those numbers, 2 means the arguments are not
three numbers, and 3 means the solution rejected the input. -/
def main (args : List String) : IO UInt32 := do
  match args.mapM String.toNat? with
  | some [year, day, part] =>
    match solutions.find? fun e => e.year == year && e.day == day && e.part == part with
    | some entry =>
      let input ← (← IO.getStdin).readToEnd
      match entry.solve input with
      | .ok answer =>
        IO.println answer
        return 0
      | .error message =>
        IO.eprintln s!"solve: bad input for {year} day {day} part {part}: {message}"
        return 3
    | none =>
      IO.eprintln s!"solve: nothing registered for {year} day {day} part {part}"
      return 1
  | _ =>
    IO.eprintln "usage: solve YEAR DAY PART   (the puzzle input is read from stdin)"
    return 2
