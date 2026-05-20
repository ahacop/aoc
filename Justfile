[private]
default:
    @just --list

# Scaffold solution files for a new day.
new YEAR DAY:
    bin/aoc-new {{YEAR}} {{DAY}}

# Run a solution against the real puzzle input.
run YEAR DAY PART="1":
    aoc input {{YEAR}} {{DAY}} | ruby solutions/{{YEAR}}/day$(printf '%02d' {{DAY}})_part{{PART}}.rb

# Run a solution against example input from stdin (e.g. `just example 2015 1 <<< "(())"`).
example YEAR DAY PART="1":
    ruby solutions/{{YEAR}}/day$(printf '%02d' {{DAY}})_part{{PART}}.rb

# Run a solution against the real input and submit the answer.
[no-exit-message]
submit YEAR DAY PART="1":
    aoc input {{YEAR}} {{DAY}} | ruby solutions/{{YEAR}}/day$(printf '%02d' {{DAY}})_part{{PART}}.rb | aoc submit {{YEAR}} {{DAY}} {{PART}}
