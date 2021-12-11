const
  Size = 10
  OctopusCount = Size * Size

type
  Level = uint8
  Grid = array[Size, array[Size, Level]]
  Position = (int, int)

var grid: Grid

var i = 0
for line in lines("p11.data"):
  for j, c in line: grid[i][j] = uint8(ord(c) - ord('0'))
  inc i

iterator neighbors(grid: Grid; i, j: int): Position =
  ## Yield the levels of the neighbors of an octopus.
  for (drow, dcol) in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]:
    let r = i + drow
    let c = j + dcol
    if r in 0..<Size and c in 0..<Size:
      yield (r, c)

proc doStep(grid: var Grid): int =
  ## Do a step. Return the number of flash lights encountered during this step.

  # Increment all levels.
  for row in grid.mitems:
    for level in row.mitems:
      inc level

  # Flash lights until there is no more change.
  var flashList: seq[Position]
  while true:
    result = flashList.len
    for i in 0..<Size:
      for j in 0..<Size:
        if grid[i][j] > 9:
          flashList.add (i, j)
          grid[i][j] = 0
          # Increment levels of neighbors if they have not flashed.
          for pos in grid.neighbors(i, j):
            if pos notin flashList:
              inc grid[pos[0]][pos[1]]
    if result == flashList.len:
      break   # No change.

# Part 1.
let save = grid   # Save the grid for part 2.
var flashCount: int
for _ in 1..100:
  inc flashCount, grid.doStep()
echo "Part 1 answer: ", flashCount

grid = save
var step = 0
# Do a step until all octopuses have flashed in a step.
while true:
  inc step
  if grid.doStep() == OctopusCount:
    break
echo "Part 2 answer: ", step
