import std/[math, strutils, sugar, tables]

const Binary = {'0': "0000", '1': "0001", '2': "0010", '3': "0011",
                '4': "0100", '5': "0101", '6': "0110", '7': "0111",
                '8': "1000", '9': "1001", 'A': "1010", 'B': "1011",
                'C': "1100", 'D': "1101", 'E': "1110", 'F': "1111"}.toTable

type

  # Packet type IDs.
  TypeId = enum idSum, idProd, idMin, idMax, idLit, idGt, idLt, idEq

  # Packet representation.
  Packet = ref object
    version: byte
    case typeId: TypeId
    of idLit:
      litValue: int
    else:
      subpackets: seq[Packet]

  # Lexer representation.
  Lexer = object
    binary: string  # Binary string.
    idx: int        # Current index in bianry string.

proc initLexer(s: string): Lexer =
  ## Initialize a lexer for a given binary string.
  result = Lexer(binary: s, idx: 0)

proc getBit(lexer: var Lexer): char =
  ## Get a bit ('0' or '1').
  result = lexer.binary[lexer.idx]
  inc lexer.idx

proc getBits(lexer: var Lexer; length: Natural): string =
  ## Get a sequence of bits with given length.
  let next = lexer.idx + length
  result = lexer.binary[lexer.idx..<next]
  lexer.idx = next

proc getInt(lexer: var Lexer; length: int): int =
  ## Get an integer from "length" bits.
  lexer.getBits(length).parseBinInt()

proc getTypeId(lexer: var Lexer): TypeId =
  ## Get a type ID.
  result = TypeId(lexer.getInt(3))

proc getLiteral(lexer: var Lexer): int =
  ## Get a literal.
  var res = ""
  while true:
    let last = lexer.getBit() == '0'  # '0' if last part of literal.
    res.add lexer.getBits(4)
    if last: break
  result = res.parseBinInt()


proc parse(lexer: var Lexer; max = int.high): seq[Packet] =
  ## Parse a binary string with the provided lexer and return a list of packets.
  ## Return as soon as the maximum number of packets has been built.
  var count = 0
  while count < max:
    try:
      let version = lexer.getInt(3).byte
      let typeId = lexer.getTypeId()
      let packet = Packet(version: version, typeId: typeId)
      if typeId == idLit:
        packet.litValue = lexer.getLiteral()
      else:
        let lengthTypeId = lexer.getBit()
        if lengthTypeId == '0':
          let length = lexer.getInt(15)
          # Create a sublexer with a slice of given length.
          var subLexer = initLexer(lexer.binary.substr(lexer.idx, lexer.idx + length - 1))
          packet.subpackets = subLexer.parse()
          inc lexer.idx, length
        else:
          let num = lexer.getInt(11)
          ## Create a sublexer with the remaining slice and a maximum count of packets.
          var subLexer = initlexer(lexer.binary.substr(lexer.idx, lexer.binary.high))
          packet.subpackets = subLexer.parse(num)
          inc lexer.idx, subLexer.idx
      inc count
      result.add packet
    except IndexDefect:
      break

proc display(packets: seq[Packet]; shift = 0) =
  ## Utility function to display a packet.
  let shiftStr = spaces(shift)
  for packet in packets:
    stdout.write shiftStr, "version = ".align(shift), packet.version
    stdout.write ", typeId = ", packet.typeId
    if packet.typeId == idLit:
      stdout.writeLine ", literal = ", packet.litValue
    else:
      stdout.writeLine ""
      packet.subpackets.display(shift + 4)

proc versionSum(packets: seq[Packet]): int =
  ## Compute the sum of version of a list of packets.
  for packet in packets:
    result += packet.version.int
    if packet.typeId != idLit:
      result += packet.subpackets.versionSum()

proc value(packet: Packet): int =
  # Compute the value of a packet.
  var values: seq[int]  # Values of subpackets.
  if packet.typeId != idLit:
    values = collect(for sp in packet.subpackets: value(sp))
  result = case packet.typeId
           of idSum: sum(values)
           of idProd: prod(values)
           of idMin: min(values)
           of idMax: max(values)
           of idLit: packet.litValue
           of idGt: ord(values[0] > values[1])
           of idLt: ord(values[0] < values[1])
           of idEq: ord(values[0] == values[1])

# Read data and build packets representation.
let input = readFile("p16.data").strip()
let binary = collect(for d in input: Binary[d]).join()
var lexer = initLexer(binary)
let packets = lexer.parse()

### Part 1 ###

echo "Part 1: ", packets.versionSum()


### Part 2 ###

echo "Part 2: ", packets[0].value()
