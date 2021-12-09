import std/[algorithm, sugar]

type
  Digit = 0..9
  Grid = seq[seq[Digit]]

var grid: Grid

# Load grid.
for line in lines("p09.data"):
  grid.add collect(for c in line: Digit ord(c) - ord('0'))

iterator neighbors(grid: Grid; i, j: int): (int, int) =
  ## Yield the coordinates of neighbor locations.
  if i > 0: yield (i - 1, j)
  if i < grid.high: yield (i + 1, j)
  if j > 0: yield (i, j - 1)
  if j < grid[0].high: yield (i, j + 1)

proc neighborValues(grid: Grid; i, j: int): seq[Digit] =
  ## Return the list of depths of neighbor locations.
  for (a, b) in grid.neighbors(i, j):
    result.add grid[a][b]

# Part 1.

var lowPoints: seq[(int, int)]
for i in 0..grid.high:
  for j in 0..grid[0].high:
    if grid[i][j] < min(grid.neighborValues(i, j)):
      lowPoints.add (i, j)

var riskLevel = 0
for (i, j) in lowPoints:
  riskLevel.inc grid[i][j] + 1

echo "Part 1 answer: ", riskLevel


# Part 2.

proc basinSize(grid: var Grid; i, j: int): int =
  ## Compute recursively the basin size starting from point at (i, j).
  result = 1
  let m = grid[i][j] + 1
  for (a, b) in grid.neighbors(i, j):
    let val = grid[a][b]
    if val in m..8:
      result.inc grid.basinSize(a, b)
  grid[i][j] = 9  # Mark this location as "done".

var basinSizes: seq[int]
for (i, j) in lowPoints:
  basinSizes.add grid.basinSize(i, j)
basinSizes.sort(Descending)

echo "Part 2 answer: ", basinSizes[0] * basinSizes[1] * basinSizes[2]
