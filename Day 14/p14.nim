import std/[strutils, tables]

# Load polymer template and rules.
let input = open("p14.data")
let start = input.readLine()
var rules: Table[string, char]
while not input.endOfFile:
  let line = input.readLine()
  if line.len > 0:
    let rule = line.split(" -> ")
    rules[rule[0]] = rule[1][0]
input.close()

type
  Pair = string
  PairCounts = CountTable[Pair]

var pairCounts: PairCounts  # Count the number of pairs in a polymer.

for i in 1..start.high:
  pairCounts.inc(start[(i-1)..i])


proc doStep(pairCounts: PairCounts): PairCounts =
  ## Execute a step, updating the count of pairs.
  for pair, count in pairCounts:
    let newElem = rules[pair]
    result.inc(pair[0] & newElem, count)
    result.inc(newElem & pair[1], count)


proc elemCounts(pairCounts: PairCounts): CountTable[char] =
  ## Compute the number of elements from the number of pairs.
  for pair, count in pairCounts:
    result.inc(pair[0], count)
    result.inc(pair[1], count)
  # Adjust the count of starting and ending elements.
  result.inc(start[0])
  result.inc(start[^1])
  # Each element has been counted twice, so divide the count by two.
  for pair, count in result:
    result[pair] = count div 2


### Part 1 ###

for _ in 1..10:
  pairCounts = pairCounts.doStep()
var counts = pairCounts.elemCounts()
echo "Part 1: ", counts.largest.val - counts.smallest.val


### Part 2 ###

for _ in 11..40:
  pairCounts = pairCounts.doStep()
counts = pairCounts.elemCounts()
echo "Part 2: ", counts.largest.val - counts.smallest.val
