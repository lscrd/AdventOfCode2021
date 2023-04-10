import std/[strutils, tables]

type

  CaveKind {.pure.} = enum Start, End, Big, Small

  Cave = ref object
    name: string
    kind: CaveKind
    neighbors: seq[Cave]
    visited: bool

  Path = seq[string]

var caves: Table[string, Cave]


# Build the cave objects.
for line in lines("p12.data"):
  let names = line.split('-')
  for name in names:
    if name notin caves:
      let cave = Cave(name: name)
      caves[name] = cave
      cave.kind = if name[0].isUpperAscii(): Big
                  elif name == "start": Start
                  elif name == "end": End
                  else: Small
  caves[names[0]].neighbors.add caves[names[1]]
  caves[names[1]].neighbors.add caves[names[0]]


proc paths(cave: Cave; allowTwice: bool): seq[Path] =
  ## Return the list of paths.
  ## Procedure useful only for debugging purpose.
  var allowTwice = allowTwice
  if cave.kind == End: return @[@[cave.name]]
  for neighbor in cave.neighbors:
    if neighbor.kind != Start and (not neighbor.visited or allowTwice):
      var nextAllowTwice = allowTwice
      var visited = neighbor.visited
      if neighbor.kind == Small:
        if neighbor.visited:
          nextAllowTwice = false
        else:
          neighbor.visited = true
      for path in paths(neighbor, nextAllowTwice):
        result.add cave.name & path
      neighbor.visited = visited


proc pathCount(cave: Cave; allowTwice: bool): int =
  ## Return the number of paths.
  var allowTwice = allowTwice
  if cave.kind == End: return 1
  for neighbor in cave.neighbors:
    if neighbor.kind != Start and (not neighbor.visited or allowTwice):
      var nextAllowTwice = allowTwice
      var visited = neighbor.visited
      if neighbor.kind == Small:
        if neighbor.visited:
          nextAllowTwice = false
        else:
          neighbor.visited = true
      result += pathCount(neighbor, nextAllowTwice)
      neighbor.visited = visited


### Part 1 ###

echo "Part 1: ", pathCount(caves["start"], false)


### Part 2 ###
echo "Part 2: ", pathCount(caves["start"], true)
