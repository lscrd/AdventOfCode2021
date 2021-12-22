import std/[sets, strscans]

type

  Range = Slice[int]        # Axis range represented as a slice.
  Cuboid = array[3, Range]
  Action = tuple[on: bool; cuboid: Cuboid]

# Build list of actions.
var actions: seq[Action]
for line in lines("p22.data"):
  var xrange, yrange, zrange: Range
  var onOff: string
  discard line.scanf("$w x=$i..$i,y=$i..$i,z=$i..$i", onOff,
                     xrange.a, xrange.b, yrange.a, yrange.b, zrange.a, zrange.b)
  actions.add (onOff == "on", [xrange, yrange, zrange])



# Part1.

# Build a grid containing the status of each cube.
type Subrange = -50..50
var limGrid: array[Subrange, array[Subrange, array[Subrange, bool]]]
for (on, cuboid) in actions:
  block applyAction:
    for r in cuboid:
      if r.a notin Subrange.low..Subrange.high or r.b notin Subrange.low..Subrange.high:
        break applyAction   # Outside limits. Ignore.
    for x in cuboid[0]:
      for y in cuboid[1]:
        for z in cuboid[2]:
          limGrid[x][y][z] = on

# Count the number of cube set to "on" in the limited grid.
var limCount = 0
for x in Subrange.low..Subrange.high:
  for y in Subrange.low..Subrange.high:
    for z in Subrange.low..Subrange.high:
      limCount += ord(limGrid[x][y][z])
echo "Part 1 answer: ", limCount



# Part 2.

# Representation of the grid as a set of cuboids.
type Grid = HashSet[Cuboid]


proc intersect(c1, c2: Cuboid): bool =
  ## Return true if cuboids "c1" and "c2" intersect.
  for i in 0..2:
    if c1[i].b < c2[i].a or c1[i].a > c2[i].b:
      return false
  result = true


proc intersection(c1, c2: Cuboid): Cuboid =
  ## Return the intersection of cuboids "c1" and "c2.
  var mins, maxs: array[3, int]
  for i in 0..2:
    mins[i] = max(c1[i].a, c2[i].a)
    maxs[i] = min(c1[i].b, c2[i].b)
  result = [mins[0]..maxs[0], mins[1]..maxs[1], mins[2]..maxs[2]]


proc delete(grid: var Grid; c1, c2: Cuboid) =
  ## Delete cuboid "c2" from cuboid "c1", creating new cuboids. "c1" must contain "c2".
  ## The result is not optimal as we don't try to limit the number of newly created cuboids.

  # First, remove "c1" from grid as we will add new cuboids.
  grid.excl(c1)

  # Split "c1" in several cuboids and add them to the grid if they are not empty.
  for rx in [c1[0].a..(c2[0].a - 1), c2[0], (c2[0].b + 1)..c1[0].b]:
    for ry in [c1[1].a..(c2[1].a - 1), c2[1], (c2[1].b + 1)..c1[1].b]:
      for rz in [c1[2].a..(c2[2].a - 1), c2[2], (c2[2].b + 1)..c1[2].b]:
        if rx.a <= rx.b and ry.a <= ry.b and rz.a <= rz.b:
          grid.incl [rx, ry, rz]

  # Last, remove "c2" from grid as is has been added as a new cuboid.
  grid.excl c2


proc count(grid: Grid): int =
  ## Return the number of cubes in state "on".
  for c in grid:
    result += (c[0].b - c[0].a + 1) * (c[1].b - c[1].a + 1) * (c[2].b - c[2].a + 1)


var grid: Grid
for (on, cuboid) in actions:
  let cuboids = grid  # Build a copy of the grid as we will modify it.
  for c in cuboids:
    if intersect(c, cuboid):
      let inter = intersection(c, cuboid)
      grid.delete(c, inter)
  if on:
    grid.incl cuboid

echo "Part 2 answer: ", grid.count
