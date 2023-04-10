proc monad*(input: seq[int]): int =
  ## Nim translation of NOMAD program.
  var w, x, y, z: int
  var idx = 0
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 1
  x += 14
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 1
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 1
  x += 15
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 7
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 1
  x += 15
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 13
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 26
  x += -6
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 10
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 1
  x += 14
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 0
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 26
  x += -4
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 13
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 1
  x += 15
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 11
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 1
  x += 15
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 6
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 1
  x += 11
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 1
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 26
  x += 0
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 7
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 26
  x += 0
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 11
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 26
  x += -3
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 14
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 26
  x += -9
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 4
  y *= x
  z += y
  w = input[idx]
  inc idx
  x = 0
  x += z
  x = x mod 26
  z = z div 26
  x += -9
  x = ord(x == w)
  x = ord(x == 0)
  y = 0
  y += 25
  y *= x
  y += 1
  z *= y
  y = 0
  y += w
  y += 10
  y *= x
  z += y
  result = z
