# Advent of Code

Lean 4 solutions to Advent of Code, driven by [`just`](https://github.com/casey/just) recipes
that compose with the [`aoc`](https://github.com/ahacop/aoc-cli) CLI via stdin/stdout pipes.

## Layout

```
Aoc/Core.lean          shared types and input helpers
Aoc/YYYY/DayDD.lean    one file per day, defining part1 and part2
Aoc.lean               generated: the list of every part solve can run
Main.lean              the solve executable
```

A part has the type `String → String`. It takes the whole puzzle input and
returns the answer to print.

Every solution lives in one executable, `solve`. It takes the year, day and
part as arguments, reads the input on stdin, and prints the answer on stdout.

## Setup

The flake provides everything. With direnv:

```bash
direnv allow
```

Without direnv:

```bash
nix develop
```

The shell provides Lean, `just`, and the `aoc` CLI. Nothing else has to be
on your system. `aoc` builds from source on first entry, which pulls a Rust
toolchain, so budget a few minutes and about 120 MB of downloads once.

Then store your Advent of Code session cookie, which `aoc` needs to fetch
your inputs and submit answers:

```bash
aoc login
```

## Workflow

List the available recipes:

```bash
just
```

Scaffold a new day (creates `Aoc/Y2015/Day01.lean` with both parts stubbed):

```bash
just new 2015 1
```

Run against the real puzzle input (fetched and cached by `aoc input`):

```bash
just run 2015 1          # part 1 (default)
just run 2015 1 2        # part 2
```

Run the newest solution in the repo, without naming the year and day.
The newest is the highest year, then the highest day, of the files under `Aoc/`:

```bash
just latest              # part 1 (default)
just latest 2            # part 2
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

## The generated Aoc.lean

Lean only compiles a module that something imports, so a new file under `Aoc/`
does nothing until `Aoc.lean` imports it and lists its two parts. `bin/aoc-sync`
writes that file from the day files on disk, and `just new` runs it for you.

Run it yourself after you delete a day:

```bash
rm Aoc/Y2015/Day01.lean
just sync
```

## Lean version

The flake pins Lean, and there is no `lean-toolchain` file, so the shell's Lean
is the one Lake uses. Run `lean --version` to see it.
