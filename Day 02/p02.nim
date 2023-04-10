import std/strutils

type Command {.pure.} = enum Forward = "forward", Up = "up", Down = "down"

# Read commands.
var commands: seq[tuple[command: Command, value: int]]
for line in lines("p02.data"):
  let fields = line.split()
  commands.add (parseEnum[Command](fields[0]), parseInt(fields[1]))

### Part 1 ###

var pos, depth = 0
for (command, value) in commands:
  case command
  of Forward: inc pos, value
  of Up: dec depth, value
  of Down: inc depth, value

echo "Part 1: ", pos * depth

### Part 2 ###

pos = 0
depth = 0
var aim = 0
for (command, value) in commands:
  case command
  of Forward:
    inc pos, value
    inc depth, aim * value
  of Up:
    dec aim, value
  of Down:
    inc aim, value

echo "Part 2: ", pos * depth
