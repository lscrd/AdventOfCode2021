import std/[sequtils, sugar, tables]

type
  Digit = 0..9
  Grid = seq[seq[Digit]]
  Position = tuple[x, y: int]

var grid: Grid


proc `[]`(grid: Grid; pos: Position): Digit =
  grid[pos.y][pos.x]

proc `[]=`(grid: var Grid; pos: Position; val: Digit) =
  grid[pos.y][pos.x] = val


iterator neighbors(grid: Grid; pos: Position): Position =
  if pos.x > 0: yield (pos.x - 1, pos.y)
  if pos.x < grid.high: yield (pos.x + 1, pos.y)
  if pos.y > 0: yield (pos.x, pos.y - 1)
  if pos.y < grid.high: yield (pos.x, pos.y + 1)


proc minRisk(grid: Grid): int =
  ## Compute the minimal risk for the grid.
  var minRisks: Table[Position, int]
  minRisks[(0, 0)] = 0  # Ignore risk value of entry.
  while true:
    var changed = false
    var risks = minRisks    # Make a copy of risk table.
    for pos, risk in risks:
      for next in grid.neighbors(pos):
        let nextRisk = risk + grid[next]
        if next notin minRisks or nextRisk < minRisks[next]:
          # Add or update cumulated risk value for the position.
          minRisks[next] = nextRisk
          changed = true
    if not changed: break
  result = minRisks[(grid.high, grid.high)]


# Load grid.
for line in lines("p15.data"):
  grid.add collect(for c in line: Digit(ord(c) - ord('0')))


# Part 1.
echo "Part 1 answer: ", grid.minRisk()


# Part 2.

# Build full grid.
let size = grid.len
var fullGrid = newSeqWith(5 * size, newSeq[Digit](5 * size))
# - build first row of grids.
for x in 0..<size:
  for y in 0..<size:
    var val = grid[(x, y)]
    for i in 0..4:
      fullGrid[(x + i * size, y)] = val
      val = if val == 9: 1 else: val + 1
# - build next rows of grids.
for x in 0..fullGrid.high:
  for y in 0..<size:
    var val = fullGrid[(x, y)]
    for i in 1..4:
      val = if val == 9: 1 else: val + 1
      fullGrid[(x, y + i * size)] = val

echo "Part 2 answer: ", fullGrid.minRisk()
