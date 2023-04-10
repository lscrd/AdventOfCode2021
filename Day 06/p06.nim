import std/[algorithm, math, strutils]

# Number of lanternfishes for each remaining days.
type Count = array[0..8, int]

let input = open("p06.data")
var lanternFishCount: Count
for value in input.readLine().split(','):
  lanternFishCount[value.parseInt].inc
input.close()

proc doStep(lanternFishCount: var Count) =
  ## Update the counts after one day.
  lanternFishCount.rotateLeft(1)
  lanternFishCount[6].inc lanternFishCount[8]


### Part 1 ###

for _ in 1..80:
  lanternFishCount.doStep()
echo "Part 1: ", sum(lanternFishCount)


### Part 2 ###

for _ in 81..256:
  lanternFishCount.doStep()
echo "Part 2: ", sum(lanternFishCount)
