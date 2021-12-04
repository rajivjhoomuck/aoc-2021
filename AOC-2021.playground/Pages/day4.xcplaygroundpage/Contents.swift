import Foundation

struct Board {
  let columns: [[Int]]
  let rows: [[Int]]
  init(rawValue: String) {
    self.rows = rawValue
      .split(separator: "\n")
      .map({ $0.split(separator: " ").compactMap(String.init >>> Int.init) })
    self.columns = transpose(rows)
  }
}

/// Creates all draw events from provided input
func _draws(_ input: [Int]) -> [[Int]] { (4..<input.count).map({ Array(input[0...$0]) }) }

func gameStats(fromFile fileName: String) -> ([[Int]], [Board]) {
  let output = try! load(fileNamed: fileName).components(separatedBy: "\n\n")
  let drawSequences = output[0].split(separator: ",").compactMap(String.init >>> Int.init) |> _draws
  let boards = output.dropFirst().map(Board.init)
  return (drawSequences, boards)
}

func firstWinningBoard(with draws: [Int], and boards: [Board]) -> ([Int], Board)? {
  guard
    let board = boards.first (where: { _board in
      (_board.rows + _board.columns).map({ Set(draws).isSuperset(of: $0) }).reduce(false, { $0 || $1 })
    }) else { return nil }
  return (draws, board)
}

func calculateScore(draw: [Int], board: Board) -> Int {
  draw.reversed()[0] * board.rows.flatMap(id).filter({ !draw.contains($0) }).reduce(0, +)
}

let (drawSequences, boards) = gameStats(fromFile: "data")

//: * Experiment: Part One Answer
let partOneAnswer = zip(drawSequences, Array(repeating: boards, count: drawSequences.count))
  .compactMap { firstWinningBoard(with: $0, and: $1) }
  .first.map { calculateScore(draw: $0, board:$1) }
