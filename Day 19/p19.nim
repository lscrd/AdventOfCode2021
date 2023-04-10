import std/[sequtils, sets, strscans, strutils]

type

  # Coordinates and shifts.
  Vector = array[3, int]

  # List and set of beacons.
  Beacons = seq[Vector]
  BeaconSet = HashSet[Vector]

  # Scanner data.
  ScannerData = seq[Beacons]

const

  # Rotations description.
  # A rotation is described by a permutation of coordinates and their multiplication by 1 or -1.
  Mults1 = [[1, 1, 1], [1, -1, -1], [-1, 1, -1], [-1, -1, 1]]
  Mults2 = [[-1, -1, -1], [-1, 1, 1], [1, 1, -1], [1, -1, 1]]
  Rotations = {[0, 1, 2]: Mults1, [1, 2, 0]: Mults1, [2, 0, 1]: Mults1,
               [0, 2, 1]: Mults2, [1, 0, 2]: Mults2, [2, 1, 0]: Mults2}

# Read the scanners data.
var num: int
var coords: Vector
var data: ScannerData
for line in lines("p19.data"):
  if line.startsWith("---"):
    discard line.scanf("--- scanner $i ---", num)
    assert data.len == num
    data.add @[]
  elif line.len != 0:
    discard line.scanf("$i,$i,$i", coords[0], coords[1], coords[2])
    data[^1].add coords


# Subtraction of vectors.
func `-`(a, b: Vector): Vector = [a[0] - b[0], a[1] - b[1], a[2] - b[2]]

func rotated(v, perm, mult: Vector): Vector =
  ## Return the coordinates of a vector rotated using a permutation and a multiplication vectors.
  [v[perm[0]] * mult[0], v[perm[1]] * mult[1], v[perm[2]] * mult[2]]

iterator rotations(): tuple[perm, mult: Vector] =
  ## Yield the successive rotations.
  for (perm, mults) in Rotations:
    for mult in mults:
      yield (perm, mult)

proc find(b1: BeaconSet; b2: Beacons): tuple[match: bool; shift, perm, mult: Vector] =
  ## Compare a list of beacons with a beacon set and return a tuple indicating if a match has
  ## been found and, if this is the case, the shift and the rotation to use for the list of beacons.
  var shift: Vector
  var b1 = b1
  for i0 in 0..(b2.len - 12):
    for (perm, mult) in rotations():
      let v2 = b2[i0].rotated(perm, mult)
      for v1 in b1:
        shift = v2 - v1
        var count = 1
        for i in (i0 + 1)..b2.high:
          if (b2[i].rotated(perm, mult) - shift) in b1:
            # The rotated and shifted position belongs to the known set of beacon positions.
            inc count
            if count == 12:
              return (true, shift, perm, mult)


### Parts 1 and 2 ###

proc process(data: ScannerData) =
  ## Process data and print results for parts 1 and 2.

  # Build the set of beacons.
  var perms, mults, shifts = newSeq[Vector](data.len)   # Description of scanner positions.
  perms[0] = [0, 1, 2]
  mults[0] = [1, 1, 1]
  shifts[0] = [0, 0, 0]
  var beacons = data[0].toHashSet()                     # Start with data from scanner 0.
  var scannersToProcess = toSeq(1..data.high)
  # - find a scanner with at least 12 common beacons.
  while scannersToProcess.len > 0:
    var match = false
    var shift, perm, mult: Vector
    var scanner: int
    var idx = -1
    while not match:
      inc idx
      scanner = scannersToProcess[idx]
      (match, shift, perm, mult) = beacons.find(data[scanner])
    # - update position data for this scanner.
    perms[scanner] = perm
    mults[scanner] = mult
    shifts[scanner] = shift
    scannersToProcess.del idx
    # Add beacons from this scanner.
    for beacon in data[scanner]:
      beacons.incl beacon.rotated(perm, mult) - shift

  echo "Part 1: ", beacons.len

  # Find the largest Manhattan distance between scanners.
  var largest = 0
  for i in 0..shifts.high - 1:
    let v1 = shifts[i]
    for j in (i + 1)..shifts.high:
      let v2 = shifts[j]
      let d = abs(v2[0] - v1[0]) + abs(v2[1] - v1[1]) + abs(v2[2] - v1[2])
      if d > largest: largest = d

  echo "Part 2: ", largest

data.process()
