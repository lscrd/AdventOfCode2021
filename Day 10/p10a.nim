# Standard solution using two passes on lines as required.

import std/[algorithm, sequtils, tables]

const MatchingChars = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable


# Part 1.

const IncorrectScores = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable

proc corruptedScore(line: string): int =
  ## Check if a line is corrupted and return its score.
  ## If the line is not corrupted, return 0.
  var stack: seq[char]
  for c in line:
    if c in ['(', '[', '{', '<']:
      stack.add MatchingChars[c]
    else:
      let expected = stack.pop()
      if c != expected: return IncorrectScores[c]

var scoreSum = 0
var nss: seq[string]
for line in lines("p10.data"):
  let score = line.corruptedScore()
  scoreSum.inc score
  if score == 0: nss.add line    # Keep the line for later processing.
echo "Part 1 answer: ", scoreSum


# Part 2.

const MissingScores = {')': 1, ']': 2, '}': 3, '>': 4}.toTable

proc incompleteScore(line: string): int =
  ## Check if a line is incomplete and return its score.
  ## If the line is complete, return 0 (doesn’t occur).
  var stack: seq[char]
  for c in line:
    if c in ['(', '[', '{', '<']:
      stack.add MatchingChars[c]
    else:
      discard stack.pop()
  for i in countdown(stack.high, 0):
    result = 5 * result + MissingScores[stack[i]]

let scores = sorted(map(nss, incompleteScore))
echo "Part 2 answer: ", scores[scores.len div 2]
