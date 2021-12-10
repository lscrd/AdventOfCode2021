# Improved solution using a single pass on lines.

import std/[algorithm, tables]

const
  MatchingChars = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable
  IncorrectScores = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
  MissingScores = {')': 1, ']': 2, '}': 3, '>': 4}.toTable

type Scores = tuple[corrupted, incomplete: int]


proc scores(line: string): Scores =
  ## Return the scores for corruption and incompleteness
  ## (0 if the line is not corrupted and 0 if the line is complete).
  var stack: seq[char]

  # Check if line is corrupted.
  for c in line:
    if c in ['(', '[', '{', '<']:
      stack.add MatchingChars[c]
    else:
      let expected = stack.pop()
      if c != expected: return (IncorrectScores[c], 0)

  # Line is not corrupted. Compute "incomplete" score.
  for i in countdown(stack.high, 0):
    result.incomplete = 5 * result.incomplete + MissingScores[stack[i]]


var
  score1Sum = 0
  scores2: seq[int]

for line in lines("p10.data"):
  let scores = line.scores()
  score1Sum += scores.corrupted
  if scores.corrupted == 0: scores2.add scores.incomplete


# Part 1.
echo "Part 1 answer: ", score1Sum

# Part 2.
scores2.sort()
echo "Part 2 answer: ", scores2[scores2.len div 2]
