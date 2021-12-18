import std/sugar

type

  Kind {.pure.} = enum OpenPair, ClosePair, Value
  Position {.pure.} = enum None, Left, Right  # None used for first OpenPair.

  Element = object
    kind: Kind
    position: Position    # Significant if kind is OpenPair or Value.
    value: int            # Significant if kind is Value.

  # Representation of a Snailfish number.
  SnailFishNumber = seq[Element]


func parse(s: string): SnailFishNumber =
  ## Parse a string and return a SnailFishNumber.
  var pos = @[None]   # Stack of positions.
  var val: int        # Current value (-1 if none).
  for c in s:
    case c
    of '[':
      result.add Element(position: pos[^1], kind: OpenPair)
      pos.add Left
      val = -1
    of ']':
      if val >= 0:
        # Create a Value element for the pending value.
        result.add Element(position: Right, kind: Value, value: val)
        val = -1
      result.add Element(kind: ClosePair)
      discard pos.pop()
    of ',':
      if val >= 0:
        # Create a Value element for the pending value.
        result.add Element(position: Left, kind: Value, value: val)
        val = -1
      pos[^1] = Right
    of '0'..'9':
      # Update the current value.
      let d = ord(c) - ord('0')
      val = if val < 0: d else: 10 * val + d
    else:
      discard


func explodeAt(n: var SnailFishNumber; start: int) =
  ## Explode the pair starting at position "start".
  assert n[start + 1].kind == Value and n[start + 2].kind == Value
  let leftVal = n[start + 1].value
  let rightVal = n[start + 2].value
  # Update the first regular value on the left, if any.
  var idx = start - 1
  while idx >= 0 and n[idx].kind != Value:
    dec idx
  if idx >= 0: inc n[idx].value, leftVal
  # Update the first regular value on the right, if any.
  idx = start + 4
  while idx < n.len and n[idx].kind != Value:
    inc idx
  if idx < n.len: inc n[idx].value, rightVal
  # Replace the pair by a null regular value.
  n[start..(start + 3)] = [Element(position: n[start].position, kind: Value, value: 0)]


func exploded(n: var SnailFishNumber): bool =
  ## Check, from the left, for a pair to explode and explode it.
  ## Return true as soon as a pair has been exploded.
  var level = 0
  for i, elem in n:
    case elem.kind
    of OpenPair:
      inc level
      if level == 5:
        n.explodeAt(i)
        return true
    of ClosePair:
      dec level
    of Value:
      discard


func splitted(n: var SnailFishNumber): bool =
  ## Check, from the left, for a regular value to be splitted and split it.
  ## Return true as soon as a regular number has been splitted.
  for i in 0..n.high:
    let elem = n[i]
    if elem.kind == Value and elem.value >= 10:
      let lowVal = elem.value div 2
      let highVal = elem.value - lowVal
      n[i..i] = [Element(position: elem.position, kind: OpenPair),
                 Element(position: Left, kind: Value, value: lowVal),
                 Element(position: Right, kind: Value, value: highVal),
                 Element(kind: ClosePair)]
      return true


func reduce(n: var SnailFishNumber) =
  ## Reduce a Snailfish number.
  while true:
    if not n.exploded() and not n.splitted():
      break


func `$`(n: SnailFishNumber): string =
  ## Return the string representation of a SnailFishNumber.
  ## Used for debugging purpose.
  var pos: seq[Position]
  for elem in n:
    case elem.kind
      of OpenPair:
        result.add '['
        pos.add elem.position
      of ClosePair:
        result.add ']'
        if pos.pop() == Left: result.add ','
      of Value:
        result.add $elem.value
        if elem.position == Left: result.add ','


func `+`(a, b: SnailFishNumber): SnailFishNumber =
  ## Compute the addition of two Snailfish numbers.
  var first = a
  var last = b
  first[0].position = Left
  last[0].position = Right
  result = Element(kind: OpenPair) & first & last & Element(kind: ClosePair)
  result.reduce()


func magnitude(n: SnailFishNumber): int =
  ## Compute the magnitude of a Snailfish number.
  var values: seq[int]  # Stack of values.
  for elem in n:
    case elem.kind
    of OpenPair: discard
    of Value: values.add elem.value
    of ClosePair: values.add 2 * values.pop() + 3 * values.pop()
  result = values[0]


# Read data.
let numbers = collect(for line in lines("p18.data"): line.parse())

# Part 1.
var res = numbers[0]
for i in 1..numbers.high:
  res = res + numbers[i]
echo "Part 1 answer: ", magnitude(res)

# Part 2.
var largest = 0
for i in 0..numbers.high:
  for j in 0..numbers.high:
    if j != i:
      let m = magnitude(numbers[i] + numbers[j])
      if m > largest: largest = m
echo "Part 2 answer: ", largest
