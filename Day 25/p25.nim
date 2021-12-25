import std/[strutils, sugar]

type Area = seq[string]

var area: Area = collect(for line in lines("p25.data"): line)

proc `$`(area: Area): string =
  ## Return the string representation of the area.
  ## Used for debugging purpose.
  area.join("\n")

proc moveEast(area: var Area): bool =
  ## Move the sea cucumbers to the east.
  ## Return true is some sea cucumber has moved.
  let imax = area.high
  let jmax = area[0].high
  for i in 0..imax:
    var row = area[i]   # Copy the row before moving.
    for j in 0..jmax:
      if row[j] == '>':
        let nextj = if j == jmax: 0 else: j + 1
        if row[nextj] == '.':
          area[i][nextj] = '>'
          area[i][j] = '.'
          result = true

proc moveSouth(area: var Area): bool =
  ## Move the sea cucumbers to the south.
  ## Return true is some sea cucumber has moved.
  let imax = area.high
  let jmax = area[0].high
  for j in 0..jmax:
    var col = collect(for i in 0..imax: area[i][j])   # Copy the column before moving.
    for i in 0..imax:
      if col[i] == 'v':
        let nexti = if i == imax: 0 else: i + 1
        if col[nexti] == '.':
          area[nexti][j] = 'v'
          area[i][j] = '.'
          result = true

var count = 0
var changed = true
while changed:
  inc count
  changed = area.moveEast() or area.moveSouth()

echo "Part 1 answer: ", count
