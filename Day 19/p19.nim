import std/[sequtils, sets, strscans, strutils]

type

  # Coordinates and shifts.
  Vector = array[3, int]

  # List of beacons.
  Beacons = seq[Vector]

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

# Addition and subtraction of vectors.
func `+`(a, b: Vector): Vector = [a[0] + b[0], a[1] + b[1], a[2] + b[2]]
func `-`(a, b: Vector): Vector = [a[0] - b[0], a[1] - b[1], a[2] - b[2]]

func rotated(v, perm, mult: Vector): Vector =
  ## Return the coordinates of a vector rotated using a permutation and a multiplication vectors.
  [v[perm[0]] * mult[0], v[perm[1]] * mult[1], v[perm[2]] * mult[2]]

iterator rotations(beacons: Beacons): tuple[beacons: Beacons; perm, mult: array[3, int]] =
  ## Yield the coordinates of a list of beacons after applying the successive rotations.
  for (perm, mults) in Rotations:
    for mult in mults:
      var rotated: Beacons
      for beacon in beacons:
        rotated.add beacon.rotated(perm, mult)
      yield (rotated, perm, mult)

proc compare(b1, b2: Beacons): tuple[match: bool; shift, perm, mult: Vector] =
  ## Compare two list of beacons and return a tuple indicating if a match has been found
  ## and, if this is the case, the shift and the rotation to use for the second list of beacons.
  var shift: Vector
  for i0 in 0..(b1.len - 12):
    let v1 = b1[i0]
    for (r2, perm, mult) in b2.rotations():
      let s2 = r2.toHashSet()   # To speed up the tests.
      for v2 in r2:
        shift = v2 - v1
        var count = 1
        for i in (i0 + 1)..b1.high:
          if b1[i] + shift in s2: inc count
        if count >= 12:
          return (true, shift, perm, mult)


proc process(data: ScannerData) =
  ## Process data and print results for parts 1 and 2.

  # Build the list of beacons.
  var perms, mults, shifts = newSeq[Vector](data.len)   # Description of scanner positions.
  perms[0] = [0, 1, 2]
  mults[0] = [1, 1, 1]
  shifts[0] = [0, 0, 0]
  var beacons = data[0]                         # Start with data from scanner 0.
  var scannersToProcess = toSeq(1..data.high)
  # - find a scanner with at least 12 shared beacons.
  while scannersToProcess.len > 0:
    var match = false
    var shift, perm, mult: Vector
    var scanner: int
    var idx = -1
    while not match:
      inc idx
      scanner = scannersToProcess[idx]
      (match, shift, perm, mult) = compare(beacons, data[scanner])
    # - update position data for this scanner.
    perms[scanner] = perm
    mults[scanner] = mult
    shifts[scanner] = shift
    scannersToProcess.del idx
    # Add beacons. We use an intermediate set to speed up detection of duplicates.
    var beaconSet = beacons.toHashSet()
    for beacon in data[scanner]:
      beaconSet.incl beacon.rotated(perm, mult) - shift
    beacons = toSeq(beaconSet.items)

  echo "Part 1 answer: ", beacons.len

  # Find the largest Manhattan distance between scanners.
  var largest = 0
  for i in 0..shifts.high - 1:
    let v1 = shifts[i]
    for j in (i + 1)..shifts.high:
      let v2 = shifts[j]
      let d = abs(v2[0] - v1[0]) + abs(v2[1] - v1[1]) + abs(v2[2] - v1[2])
      if d > largest: largest = d

  echo "Part 2 answer: ", largest

data.process()
