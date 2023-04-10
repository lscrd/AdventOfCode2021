import std/[strutils, tables]

type

  Amphipod {.pure} = enum None, Amber = "A", Bronze = "B", Copper = "C", Desert = "D"
  Kind {.pure.} = enum Hallway, Room

  Target = object
    cell: Cell            # Cell to move an amphipod to.
    path: seq[Cell]       # Path to follow.

  Cell = ref object
    targets: seq[Target]  # List of targets reachable from the cell.
    pos: (int, int)       # Position in string representation.
    occupier: Amphipod    # Current occupier (may be None).
    case kind: Kind
    of Hallway: nil
    of Room:
      owner: Amphipod     # The kind of amphibod the room is assigned to.
      accessible: bool    # True if an amphipod may be moved to this room.
      done: bool          # True if the right amphipod is present in this room
      prev, next: Cell    # Next and previous rooms (in same column).

  # List of cells.
  Cells = tuple[roomLines: int; hallway, rooms: seq[Cell]]

# Costs of amphipod moves.
const Costs = [None: 0, Amber: 1, Bronze: 10, Copper: 100, Desert: 1000]

# Cache to avoid multiple computations of the same configuration.
var cache: Table[string, int]


func initCells(roomLines: int): Cells =
  ## Initialize the cells for "roomLines" lines of rooms.

  # Create cells.
  var hallway, rooms: seq[Cell]
  for xpos in [1, 2, 4, 6, 8, 10, 11]:
    hallway.add Cell(pos: (1, xpos), kind: Hallway)
  for ypos in 2..(roomLines + 1):
    var owner = None
    for xpos in [3, 5, 7, 9]:
      owner = succ(owner)
      rooms.add Cell(pos: (ypos, xpos), kind: Room, accessible: false, done: false, owner: owner)

  # Set next and previous room links.
  for i, room in rooms:
    if i < rooms.len - 4: room.next = rooms[i + 4]
    if i >= 4: room.prev = rooms[i - 4]

  # Build target objects.
  for ih, h in hallway:
    for r in rooms:
      var path: seq[Cell]
      if h.pos[1] - r.pos[1] > 1:
        var i = ih - 1
        while hallway[i].pos[1] - r.pos[1] >= 1:
          path.add hallway[i]
          dec i
      elif h.pos[1] - r.pos[1] < -1:
        var i = ih + 1
        while hallway[i].pos[1] - r.pos[1] <= -1:
          path.add hallway[i]
          inc i
      var p = r.prev
      while not p.isNil:
        path.add p
        p = p.prev
      h.targets.add Target(cell: r, path: path)
      r.targets.add Target(cell: h, path: path)

  result = (roomLines, hallway, rooms)


func processData(input: seq[string]): Cells =
  ## Process a sequence of input lines and return the cells.

  # Create the cells.
  let roomLines = input.len - 3
  result = initCells(roomLines)

  # Set occupiers in rooms.
  var roomIndex = 0
  for i in 2..(roomLines + 1):  # Process only the lines related to rooms.
    let line = input[i].strip()
    for val in line.split('#'):
      if val.len != 0:
        result.rooms[roomIndex].occupier = parseEnum[Amphipod](val)
        inc roomIndex

  # Set the "done" status for rooms which do not need any change.
  let last = result.rooms.high
  for i in (last - 3)..last:
    var room = result.rooms[i]
    let owner = room.owner
    while not room.isNil and room.occupier == owner:
      room.done = true
      room = room.prev


func `$`(cells: Cells): string =
  ## Return the string representation of a list of cells.

  # Build pattern.
  var s = @["#############", "#...........#", "###.#.#.#.###"]
  for _ in 2..cells.roomLines: s.add "  #.#.#.#.#  "
  s.add "  #########  "

  # Set amphipod symbols.
  for cell in cells.hallway & cells.rooms:
    if cell.occupier != None:
      s[cell.pos[0]][cell.pos[1]] = ($cell.occupier)[0]
  result = s.join("\n")


func isFree(path: seq[Cell]): bool =
  ## Return true if a path is free.
  for cell in path:
    if cell.occupier != None:
      return false
  result = true


iterator possibleRooms(cell: Cell): Cell =
  ## Yield the rooms accessible from the given hallway cell.
  for target in cell.targets:
    if target.cell.accessible and target.cell.owner == cell.occupier:
      if target.path.isFree():
        yield target.cell


iterator possibleCells(cell: Cell): Cell =
  ## Yield the cells accessible from the given room.
  for target in cell.targets:
    if target.cell.occupier == None:
      if target.path.isFree():
        yield target.cell


func allSet(cells: Cells): bool =
  ## Return true if all rooms are occupied by the right amphipod.
  for cell in cells.rooms:
    if cell.occupier != cell.owner:
      return false
  result = true


func dist(cell1, cell2: Cell): int =
  ## Return the distance between two cells.
  abs(cell1.pos[0] - cell2.pos[0]) + abs(cell1.pos[1] - cell2.pos[1])


proc minimalCost(cells: Cells): int =
  ## Return the minimal cost for the given cell configuration.

  let str = $cells  # Use the string representation as key in the cache table.
  if str in cache: return cache[str]

  result = 1_000_000

  for cell in cells.hallway:
    let occupier = cell.occupier
    if occupier != None:
      for room in cell.possibleRooms():
        cell.occupier = None
        room.occupier = occupier
        room.done = true
        room.accessible = false
        if not room.prev.isNil:
          # As previous room (if any) is not occupied, it is now accessible.
          room.prev.accessible = true
        var cost = dist(cell, room) * Costs[occupier]
        if not cells.allSet(): cost += cells.minimalCost()
        if cost < result: result = cost
        # Restore previous values of attributes.
        room.occupier = None
        cell.occupier = occupier
        room.done = false
        room.accessible = true
        if not room.prev.isNil: room.prev.accessible = false

  for room in cells.rooms:
    let occupier = room.occupier
    if occupier != None and not room.done:
      for cell in room.possibleCells():
        room.occupier = None
        cell.occupier = occupier
        if room.next.isNil or room.next.done:
          # If room is the last one or next room is done, it is now accessible.
          room.accessible = true
        let cost = dist(room, cell) * Costs[occupier] + cells.minimalCost()
        if cost < result: result = cost
        # Restore previous values of attributes.
        room.occupier = occupier
        cell.occupier = None
        room.accessible = false

  cache[str] = result


### Part 1 ###

var input = readLines("p23.data", 1)[0].splitLines()
var cells = input.processData()
echo "Part 1: ", cells.minimalCost()


### Part 2 ###

input.insert("  #D#C#B#A#", 3)
input.insert("  #D#B#A#C#", 4)
cells = input.processData()
echo "Part 2: ", cells.minimalCost()
