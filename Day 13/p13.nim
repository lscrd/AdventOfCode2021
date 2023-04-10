import std/[sequtils, sets, strscans, strutils]

type

  Position = tuple[x, y: int]
  Sheet = object
    positions: HashSet[Position]
    xMax, yMax: int

  Axis = enum xAxis = "x", yAxis = "y"
  Folding = tuple[axis: Axis, pos: int]

var
  sheet: Sheet
  foldings: seq[Folding]

# Build the set of positions and the list of foldings.
for line in lines("p13.data"):
  if line.startsWith("fold"):
    var axis: char
    var pos: int
    discard line.scanf("fold along $c=$i", axis, pos)
    foldings.add (parseEnum[Axis]($axis), pos)
  elif line.len != 0:
    var x, y: int
    discard line.scanf("$i,$i", x, y)
    sheet.positions.incl (x, y)
    if x > sheet.xMax: sheet.xMax = x
    if y > sheet.yMax: sheet.yMax = y


proc fold(sheet: Sheet; folding: Folding): Sheet =
  ## Return the sheet folded accorded to "folding".
  case folding.axis
  of xAxis:
    result.xMax = folding.pos - 1
    result.yMax = sheet.yMax
    for pos in sheet.positions:
      let x = if pos.x > folding.pos: sheet.xMax - pos.x else: pos.x
      result.positions.incl (x, pos.y)
  of yAxis:
    result.xMax = sheet.xMax
    result.yMax = folding.pos - 1
    for pos in sheet.positions:
      let y = if pos.y > folding.pos: sheet.yMax - pos.y else: pos.y
      result.positions.incl (pos.x, y)


proc display(sheet: Sheet) =
  ## Display a sheet.
  var grid = newSeqWith(sheet.yMax + 1, repeat(' ', sheet.xMax + 1))
  for pos in sheet.positions:
    grid[pos.y][pos.x] = '#'
  for row in grid:
    echo row


### Part 1 ###
echo "Part 1: ", sheet.fold(foldings[0]).positions.len


### Part 2 ###
for folding in foldings:
  sheet = sheet.fold(folding)
echo "Part 2:"
sheet.display()
