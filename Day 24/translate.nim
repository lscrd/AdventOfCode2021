import std/[strformat, strutils]

proc translate(code: openArray[string]): seq[string] =
  ## Translate the MONAD program into a Nim version.
  result = @["proc monad*(input: seq[int]): int =",
             "  ## Nim translation of NOMAD program.",
             "  var w, x, y, z: int",
             "  var idx = 0"]
  for line in code:
    let fields = line.splitWhitespace()
    case fields[0]
    of "inp":
      result.add &"  {fields[1]} = input[idx]"
      result.add "  inc idx"
    of "add":
      result.add &"  {fields[1]} += {fields[2]}"
    of "mul":
      let op2 = fields[2]
      result.add if op2 == "0": &"  {fields[1]} = 0"
                 else: &"  {fields[1]} *= {fields[2]}"
    of "div":
      let op2 = fields[2]
      if op2 != "1":
        result.add &"  {fields[1]} = {fields[1]} div {fields[2]}"
    of "mod":
      result.add &"  {fields[1]} = {fields[1]} mod {fields[2]}"
    of "eql":
      result.add &"  {fields[1]} = ord({fields[1]} == {fields[2]})"
  result.add "  result = z"

let input = readFile("p24.data").strip().splitLines()
let monad = input.translate().join("\n")
writeFile("monad.nim", monad)
