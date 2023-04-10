import std/strscans

type
  Vector = tuple[x, y: int]
  Target = tuple[xMin, xMax, yMin, yMax: int]

# Read target.
var target: Target
let input = readLines("p17.data", 1)[0]
discard input.scanf("target area: x=$i..$i, y=$i..$i",
                    target.xMin, target.xMax, target.yMin, target.yMax)

iterator positions(velocity0: Vector): Vector =
  ## Yield the successive positions for given velocity.
  var pos = (x: 0, y: 0)
  var velocity = velocity0
  while true:
    inc pos.x, velocity.x
    inc pos.y, velocity.y
    dec velocity.x, cmp(velocity.x, 0)
    dec velocity.y
    yield pos

proc height(velocity: Vector; target: Target) : int =
  ## Return the greatest height reached or -1 if the probe doesn't reach the target.
  for pos in positions(velocity):
    if pos.y > result: result = pos.y
    if pos.x in target.xMin..target.xMax and pos.y in target.yMin..target.yMax:
      return
    if pos.x > target.xMax or pos.y < target.yMin:
      return -1


### Part 1 ###

proc findVelocity(target: Target): tuple[velocity: Vector, height: int] =
  ## Find the velocity which gives the greatest height.
  let vxMax = target.xMax   # Logical limit.
  let vyMax = -target.yMin  # Somewhat arbitrary limit.
  for vx in 1..vxMax:
    for vy in 1..vyMax:
      let v = (vx, vy)
      let h = height(v, target)
      if h > result.height:
        result = (v, h)

echo "Part 1: ", target.findVelocity()


### Part 2 ##

proc velocityCount(target: Target): int =
  ## Return the number of velocities allowing to reach the target.
  let vxMax = target.xMax
  let vyMin = target.yMin
  let vyMax = -target.yMin
  for vx in 1..vxMax:
    for vy in vyMin..vyMax:
      let v = (vx, vy)
      let h = height(v, target)
      if h >= 0: inc result

echo "Part 2: ", target.velocityCount()
