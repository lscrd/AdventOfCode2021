import std/[strscans, tables]

type
  Point = (int, int)
  Line = (Point, Point)

var lines: seq[Line]

# Read lines.
for linestr in lines("p05.data"):
  var x0, y0, x1, y1: int
  if not scanf(linestr, "$i,$i$s->$s$i,$i", x0, y0, x1, y1):
    quit "Error reading data", QuitFailure
  lines.add ((x0, y0), (x1, y1))


iterator expansion(line: Line; withDiagonals: bool): Point =
  ## Yield the point of a line. If "withDiagonals" is false,
  ## diagonal lines are ignored.
  var (x0, y0) = line[0]
  var (x1, y1) = line[1]
  let xInc = cmp(x1, x0)
  let yInc = cmp(y1, y0)
  if withDiagonals or xInc == 0 or yInc == 0:
    var x = x0
    var y = y0
    yield (x0, y0)
    while x != x1 or y != y1:
      inc x, xInc
      inc y, yInc
      yield (x, y)
  else:
    discard   # Diagonal line excluded.


var points: CountTable[Point]   # Count the number of occurrences of points.

proc overlapCount(points: CountTable[Point]): int =
  ## Return the number of overlap points.
  for count in points.values:
    if count >= 2: inc result


### Part 1 ###

for line in lines:
  for point in expansion(line, false):
    points.inc(point)
echo "Part 1: ", points.overlapCount()


### Part 2 ###

points.reset()
for line in lines:
  for point in expansion(line, true):
    points.inc(point)
echo "Part 2: ", points.overlapCount()
