import std/[sequtils, setutils, strutils, tables]

type

  # Representation of a digit as a set of segment names.
  SegSet = set[char]

  # Representation of an entry
  Entry = tuple
    patterns: seq[SegSet]   # Patterns describing the ten digits.
    output: seq[SegSet]     # Patterns describing the four output digits.

const

  # Mapping of unique pattern lengths to digit values.
  UniqueSegDigits = {2: 1, 4: 4, 3: 7, 7: 8}.toTable

  # Mapping of segment sets to digit value.
  Digits = {"abcefg".toSet: 0, "cf".toSet: 1, "acdeg".toSet: 2, "acdfg".toSet: 3,
            "bcdf".toSet: 4, "abdfg".toSet: 5, "abdefg".toSet: 6, "acf".toSet: 7,
            "abcdefg".toSet: 8, "abcdfg".toSet: 9}.toTable


# Parse the list of entries.
var entries: seq[Entry]
for line in lines("p08.data"):
  let fields = line.split(" | ")
  entries.add (fields[0].split().mapIt(it.toSet), fields[1].split().mapIt(it.toSet))


# Part 1.
var count = 0
for entry in entries:
  for digit in entry.output:
    if digit.len in UniqueSegDigits:
      inc count
echo "Part 1 answer: ", count


# Part 2.

proc value(entry: Entry): int =
  ## Return the value displayed by an entry.

  var mapping: Table[char, char]  # Mapping for wrong segment value to right one.

  # First step.
  # Count the occurrences of each segment in the ten patterns.
  var counts: array['a'..'g', int]
  for pattern in entry.patterns:
    for c in pattern:
      inc counts[c]

  # Map segments corresponding to 'b', 'e' and 'f'.
  var list7, list8: seq[char]   # List of segments which occur 7 and 8 times.
  for c, count in counts:
    case count
    of 4: mapping[c] = 'e'
    of 6: mapping[c] = 'b'
    of 7: list7.add c       # Will map to 'd' and 'g'.
    of 8: list8.add c       # Will map to 'a' and 'c'.
    of 9: mapping[c] = 'f'
    else: discard

  # Find patterns which represent 1, 4 and 7.
  var pattern1, pattern4, pattern7: SegSet
  for pattern in entry.patterns:
    case pattern.len
    of 2: pattern1 = pattern
    of 3: pattern7 = pattern
    of 4: pattern4 = pattern
    else: discard

  # Pattern for 7 has one more segment than pattern for 1 and this segment maps to 'a'.
  for c in pattern7 - pattern1:
    mapping[c] = 'a'

  # Pattern for 4 has two more segments than pattern for 1 and these segments maps to 'b' and 'd'.
  # As 'b' is already mapped to, the segment with no mapping maps to 'd'.
  for c in pattern4 - pattern1:
    if c notin mapping: mapping[c] = 'd'

  # Segments which occur 7 times map to 'd' and 'g'.
  # As 'd' is already mapped to, the segment with no mapping maps to 'g'.
  for c in list7:
    if c notin mapping: mapping[c] = 'g'

  # Segments which occur 8 times map to 'a' and 'c'.
  # As 'a' is already mapped to, the segment with no mapping maps to 'c'.
  for c in list8:
    if c notin mapping: mapping[c] = 'c'

  # Now, using the mapping, build the four digits output.
  for pattern in entry.output:
    var truePattern: SegSet
    for c in pattern: truePattern.incl mapping[c]
    result = 10 * result + Digits[truePattern]


var res = 0
for entry in entries:
  res += entry.value()
echo "Part 2 answwer ", res
