import std/[strscans, tables]

type
  Player = 1..2
  PlayerData = tuple[position, score: int]
  Game = array[Player, PlayerData]

# Read positions and create game data
var game: Game
for line in lines("p21.data"):
  var num, pos: int
  discard line.scanf("Player $i starting position: $i", num, pos)
  game[num] = (pos, 0)


proc move(pos: var int; val: int) =
  ## Move a player position.
  pos = (pos + val - 1) mod 10 + 1


# Part 1.

proc rollDeterministic(): int =
  ## Return te result of a roll of the deterministic die.
  var n {.global.} = 0
  inc n
  result = n

proc rollThreeDeterministic(): int =
  ## Return the result of three sucessive rolls of the deterministic die.
  rollDeterministic() + rollDeterministic() + rollDeterministic()

proc playDeterministic(game: var Game): int =
  ## Play the game with the deterministic die.
  ## Return the product of the loser score and the total number of die rolls.
  var a = 1
  var b = 2
  var rolls = 0
  while true:
    let val = rollThreeDeterministic()
    game[a].position.move(val)
    inc game[a].score, game[a].position
    inc rolls, 3
    if game[a].score >= 1000:
      return game[b].score * rolls
    swap a, b

let save = game
echo "Part 1 answer: ", game.playDeterministic()


# Part 2.

# Count of won games for each player..
type Counts = array[Player, int]

# Table to map (game, player) to counts.
var countsTable: Table[(Game, Player), Counts]

iterator rollThreeDirac(): int =
  ## Yield the successive three possible sum of three Dirac die rolls.
  for i in 1..3:
    for j in 1..3:
      for k in 1..3:
        yield i + j + k

proc playDirac(game: Game; player: Player): Counts =
  ## Play the game with the Dirac die.
  ## Return the counts of won games for each player.
  if (game, player) in countsTable: return countsTable[(game, player)]
  let nextPlayer = 3 - player
  for val in rollThreeDirac():
    var g = game
    g[player].position.move(val)
    inc g[player].score, g[player].position
    if g[player].score >= 21:
      inc result[player]
    else:
      let counts = g.playDirac(nextPlayer)
      inc result[1], counts[1]
      inc result[2], counts[2]
  countsTable[(game, player)] = result

game = save
echo "Part 2 answer: ", game.playDirac(1)[1]
