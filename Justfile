[private]
default:
    @just --list

# Scaffold the solution file for a new day.
new YEAR DAY:
    bin/aoc-new {{YEAR}} {{DAY}}

# Rebuild Aoc.lean from the day files under Aoc/.
sync:
    bin/aoc-sync

# Compile the solve executable.
build:
    lake build

# Run a solution against the real puzzle input.
run YEAR DAY PART="1": build
    aoc input {{YEAR}} {{DAY}} | .lake/build/bin/solve {{YEAR}} {{DAY}} {{PART}}

# Run the newest solution in the repo against its real puzzle input.
[no-exit-message]
latest PART="1":
    @set -e; day=$(bin/aoc-latest); just run $day {{PART}}

# Run a solution against example input from stdin (e.g. `just example 2015 1 <<< "(())"`).
example YEAR DAY PART="1": build
    .lake/build/bin/solve {{YEAR}} {{DAY}} {{PART}}

# Run a solution against the real input and submit the answer.
[no-exit-message]
submit YEAR DAY PART="1": build
    aoc input {{YEAR}} {{DAY}} | .lake/build/bin/solve {{YEAR}} {{DAY}} {{PART}} | aoc submit {{YEAR}} {{DAY}} {{PART}}
