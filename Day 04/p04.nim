import std/[sequtils, strutils]

const
  BoardSize = 5
  Marked = -1

type Board = array[BoardSize, array[BoardSize, int]]

# Read numbers.
let input = open("p04.data")
let numbers = input.readLine().split(',').map(parseInt)

# Read boards.
var boards: seq[Board]
var iRow: int
while not input.endOfFile:
  let line = input.readLine().splitWhitespace()
  if line.len == 0:
    # Empty line: next lines, if any, are board data.
    iRow = -1
    continue
  if iRow == -1:
    # Make room for a new board.
    boards.setLen(boards.len + 1)
  inc iRow
  for iCol, value in line:
    boards[^1][iRow][iCol] = parseInt(value)
input.close()

proc rowMarked(board: Board; iRow: int): bool =
  ## Check if all numbers in a board row are marked.
  for iCol in 0..board.high:
    if board[iRow][iCol] != Marked: return false
  result = true

proc colMarked(board: Board; iCol: int): bool =
  ## Check if all numbers in a board column are marked.
  for iRow in 0..board.high:
    if board[iRow][iCol] != Marked: return false
  result = true

proc sum(board: Board): int =
  ## Compute the sum of unmarked numbers in a board.
  for row in board:
    for value in row:
      if value != Marked: inc result, value

proc value(board: var Board; num: int): int =
  ## Return -1 is the board doesn't win else return
  ## the sum of unmarked numbers.
  for iRow in 0..board.high:
    let iCol = board[iRow].find(num)
    if iCol >= 0:
      # Mark number.
      board[iRow][iCol] = Marked
      if board.rowMarked(iRow) or board.colMarked(iCol):
        return sum(board)
  result = -1

# Part 1.
var save = boards    # Make a copy of boards.
for num in numbers:
  var boardValue = -1
  for board in boards.mitems:
    boardValue = board.value(num)
    if boardValue >= 0: break
  if boardValue >= 0:
    echo "Part 1 answer: ", num * boardValue
    break

# Part 2.
boards = save
for num in numbers:
  var boardValue = -1
  var winList: seq[int]   # Indexes of winning boards.
  for i in countdown(boards.high, 0):
    boardValue = boards[i].value(num)
    if boardValue >= 0: winList.add i
  # Remove winning boards.
  for i in winList: boards.delete(i)
  if boards.len == 0:
    echo "Part 2 answer: ", num * boardValue
    break
