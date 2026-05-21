require "bundler/setup"
require "debug"

def read_aoc_input
  input = $stdin.read
  $stdin.reopen("/dev/tty") if File.exist?("/dev/tty")
  input
end
