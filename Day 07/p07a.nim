# This is the standard solution which tries all possible target positions.

import std/[algorithm, sequtils, strutils]

# Read and sort crab positions.
let positions = readFile("p07.data").strip().split(',').map(parseInt).sorted()

proc fuel1(positions: seq[int]; target: int): int =
  ## First formula to compute the fuel quantity needed to move to "target".
  for pos in positions:
    result += abs(pos - target)

proc fuel2(positions: seq[int]; target: int): int =
  ## Second formula to compute the fuel quantity needed to move to "target".
  for pos in positions:
    let d = abs(pos - target)
    result += d * (d + 1) div 2

# Part 1.
var res = int.high
for pos in positions[0]..positions[^1]:
  res = min(res, positions.fuel1(pos))
echo "Part 1 answer: ", res

# Part 2.
res = int.high
for pos in positions[0]..positions[^1]:
  res = min(res, positions.fuel2(pos))
echo "Part 2 answer: ", res
