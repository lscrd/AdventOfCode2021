#[ For easier analyzis, the MONAD program may be converted using the "translate" program.
   Except optimization for multiplication by 0, this is a raw translation.
   We provide here an optimized translation, much easier to understand.

   Naming d1, d2, ..., d13, d14 the input digits, the analyzis of our MONAD program shows
   that the following constraints must be satisfied:
       d14 = d1 - 8
       d13 = d2 - 2 => w1 in 3..9 and w12 in 1..7
       d12 = d7 + 8 => w6 == 1 and w11 == 9
       d11 = d8 + 6 => w7 in 1..3 and w10 in 7..9
       d10 = d9 + 1 => w8 in 1..8 and w9 in 2..9
       d6  = d5 - 4 => w4 in 5..9 and w5 in 1..5
       d4  = d3 + 7 => w2 in 1..2 and w3 in 8..9
   This implies that:
       d1 = 9, d7 = 1, d12 = 9, d14 = 1
       d2 is in 3..9, d3 in 1..2, d5 in 5..9, d8 in 1..3 and d9 in 1..8

   Note that, given these constraints, the problem may be solved without need of a program.
   For the first part, we choose the greatest possible value for each digit, starting from
   the left, and for second part, we choose the smallest possible value starting from the left.
   Using a program allows to find all the valid 14 digits values, not only the smallest and the
   greatest.

   Unfortunately, we have not found a way to, given any NOMAD program, find programmatically
   the constraints and then the largest and smallest valid values.
]#

import std/algorithm


proc monad(input: seq[int]): int =
  ## Nim optimized version of the MONAD program.
  const
    A = [14, 15, 15, -6, 14, -4, 15, 15, 11,  0,  0, -3, -9, -9]
    B = [ 1,  1,  1, 26,  1, 26,  1,  1,  1, 26, 26, 26, 26, 26]
    C = [ 1,  7, 13, 10,  0, 13, 11,  6,  1,  7, 11, 14,  4, 10]

  for idx, val in input:
    let x = result mod 26 + A[idx]
    result = result div B[idx]
    if x != val:
      result = 26 * result + val + C[idx]


proc digits(n: int64): seq[int] =
  ## Convert an integer to a sequence of digits.
  var n = n
  while n != 0:
    result.add int(n mod 10)
    n = n div 10
  result.reverse()


proc value(n: varargs[int]): int =
  ## Convert a sequence of digits to an integer value.
  for d in n:
    result = 10 * result + d


# Build the list of all valid 14 digits values.
var validValues: seq[int]

let d1 = 9
let d7 = 1
let d12 = 9
let d14 = 1
for d2 in 3..9:
  let d13 = d2 - 2
  for d3 in 1..2:
    let d4 = d3 + 7
    for d5 in 5..9:
      let d6 = d5 - 4
      for d8 in 1..3:
        let d11 = d8 + 6
        for d9 in 1..8:
          let d10 = d9 + 1
          validValues.add value(d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14)


### Part 1 ###

let maxval = max(validValues)
assert monad(maxval.digits()) == 0
echo "Part 1: ", maxval


### Part 2 ###

let minval = min(validValues)
assert monad(minval.digits()) == 0
echo "Part 2: ", minval
