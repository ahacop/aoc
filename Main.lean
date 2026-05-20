import Aoc

open Aoc

/-- Read the puzzle input on stdin, print the answer on stdout.

One executable holds every solution. The year, day and part arrive as
arguments and pick an entry out of `Aoc.solutions`. Exit code 1 means no
solution is registered for those numbers, and 2 means the arguments are
not three numbers. -/
def main (args : List String) : IO UInt32 := do
  match args.mapM String.toNat? with
  | some [year, day, part] =>
    match solutions.find? fun e => e.year == year && e.day == day && e.part == part with
    | some entry =>
      let input ← (← IO.getStdin).readToEnd
      IO.println (entry.solve input)
      return 0
    | none =>
      IO.eprintln s!"solve: nothing registered for {year} day {day} part {part}"
      return 1
  | _ =>
    IO.eprintln "usage: solve YEAR DAY PART   (the puzzle input is read from stdin)"
    return 2
