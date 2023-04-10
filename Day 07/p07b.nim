# This is an improved solution which limits the possible target positions.
# Unfortunately, we have not been able to prove that looking around the median in
# the first part and around the mean in the second part always gives the right result.

import std/[algorithm, stats, sequtils, strutils]

# Read and sort crab positions.
let positions = readLines("p07.data", 1)[0].split(',').map(parseInt).sorted()

proc fuel1(positions: seq[int]; target: int): int =
  ## First formula to compute the fuel quantity needed to move to "target".
  for pos in positions:
    result += abs(pos - target)

proc fuel2(positions: seq[int]; target: int): int =
  ## Second formula to compute the fuel quantity needed to move to "target".
  for pos in positions:
    let d = abs(pos - target)
    result += d * (d + 1) div 2


### Part 1 ###

# To limit the number of computations, we look around the median value.
let mIndex = positions.len shr 1
let limits = if (positions.len and 1) == 0: (positions[mIndex - 2], positions[mIndex + 1])
             else: (positions[mIndex - 1], positions[mIndex + 1])
var res = int.high
for pos in limits[0]..limits[1]:
  res = min(res, positions.fuel1(pos))
echo "Part 1: ", res


### Part 2 ###

# To limit the number of computations, we look around the mean value.
let m = mean(positions).toInt
res = int.high
for pos in (m - 2)..(m + 2):
  res = min(res, positions.fuel2(pos))
echo "Part 2: ", res
