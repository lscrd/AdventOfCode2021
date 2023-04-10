import std/[sequtils, strutils]

let numbers = lines("p03.data").toSeq
let length = numbers[0].len


### Part 1 ###

var gammaRate, epsilonRate = 0
for pos in 0..<length:
  var zeroes, ones = 0
  for num in numbers:
    if num[pos] == '0': inc zeroes else: inc ones
  let mostCommon = int(ones > zeroes)
  let leastCommon = 1 - mostCommon
  gammaRate = gammaRate shl 1 + mostCommon
  epsilonRate = epsilonRate shl 1 + leastCommon

echo "Part 1: ", gammaRate * epsilonRate


### Part 2 ###

proc filter(numbers: seq[string]; keepMostCommon: bool): int =
  var candidates = numbers
  var pos = 0
  while candidates.len > 1:
    var list0, list1: seq[string]
    for num in candidates:
      if num[pos] == '0': list0.add num else: list1.add num
    candidates = if list0.len > list1.len == keepMostCommon: move(list0) else: move(list1)
    inc pos
  result = parseBinInt(candidates[0])

let oxygenGeneratorRating = numbers.filter(true)
let co2ScrubberRating = numbers.filter(false)

echo "Part 2: ", oxygenGeneratorRating * co2ScrubberRating
