import std/[strutils, sugar]

# Read values.
let values = collect:
               for line in lines("p01.data"):
                 line.parseInt()

### Part 1 ###

var prevVal = values[0]
var count = 0
for i in 1..values.high:
  if values[i] > prevVal: inc count
  prevVal = values[i]

echo "Part 1: ", count

### Part 2 ###

prevVal = values[0] + values[1] + values[2]
count = 0
for i in 3..values.high:
  let val = values[i-2] + values[i-1] + values[i]
  if val > prevVal: inc count
  prevVal = val

echo "Part 2: ", count
