import Foundation

struct Board: Equatable {
  let columns: [[Int]]
  let rows: [[Int]]

  init(rawValue: String) {
    self.rows = rawValue.split(separator: "\n").map({ $0.split(separator: " ").compactMap(substring2Int) })
    self.columns = transpose(rows)
  }

  func isWinner(for draw: [Int]) -> Bool { (rows + columns).map({ Set(draw).isSuperset(of: $0) }).reduce(false, { $0 || $1 }) }
}

struct GameState {
  var contenders: [Board] = []
  var leaderboards: [([Int], [Board])] = []
  var lastWinners: ([Int], [Board])?
  var lastWin: ([Int], Board)? { zip2(lastWinners?.0, lastWinners?.1.last) }
  var firstWin: ([Int], Board)? { zip2(leaderboards.first?.0, leaderboards.first?.1.first) }

  mutating func play(_ draw: [Int]) {
    let wins = draw |> flip(Board.isWinner)
    let winners = contenders.filter(wins)
    contenders = contenders.filter(wins >>> (!))
    if !winners.isEmpty {
      leaderboards.append((draw, winners))
      lastWinners = (draw, winners)
    }
  }
}

func gameStats(fromFile fileName: String) -> ([[Int]], [Board]) {
  /// Creates all draw events from provided input
  func _draws(_ input: [Int]) -> [[Int]] { (4..<input.count).map({ Array(input[0...$0]) }) }

  let output = try! load(fileNamed: fileName).components(separatedBy: "\n\n")
  let drawSequences = output[0].split(separator: ",").compactMap(substring2Int) |> _draws
  let boards = output.dropFirst().map(Board.init)
  return (drawSequences, boards)
}

func calculateScore(draw: [Int], board: Board) -> Int {
  draw.reversed()[0] * board.rows.flatMap(id).filter({ !draw.contains($0) }).reduce(0, +)
}
//: * Experiment: Answers for both parts
let (draws, boards) = gameStats(fromFile: "data")
let playedGame = draws.reduce(into: GameState(contenders: boards), { state, draw in state.play(draw) })
let partOneAnswer = playedGame.firstWin.map(calculateScore)
let partTwoAnswer = playedGame.lastWin.map(calculateScore)
