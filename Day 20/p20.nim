import std/[strutils, sugar]

type Image = object
  background: char    # Background (starts with '.').
  data: seq[string]   # Actual image data.


# Load image enhancement algorithm string and image string.
let input = open("p20.data")
var ieaString = input.readLine()
discard input.readLine()  # empty line.
var image = Image(background: '.', data: collect(for line in input.lines(): line))
input.close()

proc `$`(img: Image): string {.used.} =
  ## Return the image string representation.
  ## Used for debugging purpose.
  img.data.join("\n")

proc pixelValue(image: Image; x, y: int): int =
  ## Return the integer value of a pixel.
  let m = image.data.high
  for dy in -1..1:
    let ny = y + dy
    for dx in -1..1:
      let nx = x + dx
      result = result shl 1
      if ny in 0..m and nx in 0..m:
        # Add the actual value.
        result += ord(image.data[ny][nx] == '#')
      else:
        # Add the background value.
        result += ord(image.background == '#')

proc enhanced(img: Image; ieaString: string): Image =
  ## Return the enhanced version of an image using the IEA string provided.
  let lg = img.data.len
  for y in -1..lg:
    var row: string
    for x in -1..lg:
      let pix = image.pixelValue(x, y)
      row.add ieaString[pix]
    result.data.add move(row)
  # Set the background value for the result.
  result.background = '.'
  if ieaString[0] == '#' and image.background == '.':
    # The IEA string reverses the background value.
    result.background = '#'

proc litCount(image: Image): int =
  ## Return the number of lit elements in image.
  for row in image.data:
    inc result, row.count('#')


### Part 1 ###

for _ in 1..2:
  image = enhanced(image, ieaString)
echo "Part 1: ", image.litCount()


### Part 2 ###

for _ in 3..50:
  image = enhanced(image, ieaString)
echo "Part 2: ", image.litCount()
