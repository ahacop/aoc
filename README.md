# Advent of Code

Ruby solutions to Advent of Code, driven by [`just`](https://github.com/casey/just) recipes that compose with the [`aoc`](https://github.com/ahacop/aoc-cli) CLI via stdin/stdout pipes.

## Layout

```
solutions/YYYY/dayDD_partN.rb
```

Each file is a script that reads input on stdin and prints the answer on stdout.

## Workflow

List the available recipes:

```bash
just
```

Scaffold a new day (creates `day01_part1.rb` and `day01_part2.rb`):

```bash
just new 2015 1
```

Run against the real puzzle input (fetched and cached by `aoc input`):

```bash
just run 2015 1          # part 1 (default)
just run 2015 1 2        # part 2
```

Try an example from the puzzle description:

```bash
just example 2015 1 <<< "(())"
echo "(())" | just example 2015 1
```

Submit the answer:

```bash
just submit 2015 1       # part 1
just submit 2015 1 2     # part 2
```
