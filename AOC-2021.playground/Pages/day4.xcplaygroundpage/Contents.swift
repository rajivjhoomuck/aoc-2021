import Foundation

struct Board: Equatable {
  let columns: [[Int]]
  let rows: [[Int]]

  init(rawValue: String) {
    self.rows = rawValue.split(separator: "\n").map({ $0.split(separator: " ").compactMap(String.init >>> Int.init) })
    self.columns = transpose(rows)
  }

  func isWinner(for draws: [Int]) -> Bool { (rows + columns).map({ Set(draws).isSuperset(of: $0) }).reduce(false, { $0 || $1 }) }
}

struct GameState {
  var contenders: [Board] = []
  var lastWinners: ([Int], [Board])?
  var lastWin: ([Int], Board)? { zip2(lastWinners?.0, lastWinners?.1.last) }

  mutating func play(_ draw: [Int]) {
    let wins = draw |> flip(Board.isWinner)
    let winners = contenders.filter(wins)
    contenders = contenders.filter(wins >>> (!))
    if !winners.isEmpty { lastWinners = (draw, winners) }
  }
}

func gameStats(fromFile fileName: String) -> ([[Int]], [Board]) {
  /// Creates all draw events from provided input
  func _draws(_ input: [Int]) -> [[Int]] { (4..<input.count).map({ Array(input[0...$0]) }) }

  let output = try! load(fileNamed: fileName).components(separatedBy: "\n\n")
  let drawSequences = output[0].split(separator: ",").compactMap(String.init >>> Int.init) |> _draws
  let boards = output.dropFirst().map(Board.init)
  return (drawSequences, boards)
}

func firstWinningBoard(with draw: [Int], and boards: [Board]) -> ([Int], Board)? {
  zip2(draw, boards.first(where: draw |> flip(Board.isWinner))) ?? nil
}

func calculateScore(draw: [Int], board: Board) -> Int {
  draw.reversed()[0] * board.rows.flatMap(id).filter({ !draw.contains($0) }).reduce(0, +)
}

let (draws, boards) = gameStats(fromFile: "data")

//: * Experiment: Part One Answer
let partOneAnswer = zip(draws, Array(repeating: boards, count: draws.count))
  .compactMap { firstWinningBoard(with: $0, and: $1) }
  .first.map { calculateScore(draw: $0, board:$1) }

//: * Experiment: Part One Answer
let partTwoAnswer = draws
  .reduce(into: GameState(contenders: boards), { state, draw in state.play(draw) })
  .lastWin
  .map(calculateScore(draw: board:))
