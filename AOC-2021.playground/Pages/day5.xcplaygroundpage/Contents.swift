import Foundation

//: > Not guarding against invalid lines
struct Point: Equatable, Hashable { let x, y: Int }

extension Point {
  init(input: String) {
    let coord = input.split(separator: ",").compactMap(substring2Int)
    (self.x, self.y) = (coord[0], coord[1])
  }
}

struct Line {
  let start, end: Point
  var isHorizontal: Bool { start.y == end.y }
  var isVertical: Bool { start.x == end.x }
  var verticalOrHorizontalPoints: [Point] {
    if isHorizontal {
      return makeRange(i: start.x, j: end.x).map({ Point(x: $0, y: start.y) })
    } else if isVertical {
      return makeRange(i: start.y, j: end.y).map({ Point(x: start.x, y: $0) })
    } else { return [] }
  }

  var diagonalPoints: [Point] {
    guard abs(start.x - end.x) == abs(start.y - end.y) else { return [] }
    let xrange = makeRange(i: start.x, j: end.x)
    let yrange = makeRange(i: start.y, j: end.y)
    return zip(xrange, yrange).map(Point.init(x: y:))
  }

  var all: [Point] { verticalOrHorizontalPoints + diagonalPoints }

  init(coords: [Point]) { (self.start, self.end) = (coords[0], coords[1]) }

  func makeRange(i: Int, j: Int) -> [Int] { i <= j ? Array(i...j) : Array(j...i).reversed() }
  // When LT, make the range by reversing, since closed range constructor need first arg to be lower than second arg (bounds)
}

func parsePoints(includingDiagonals diagionals: Bool, input: String) -> [Point] {
  input.components(separatedBy: " -> ").map(Point.init(input:))
    |> Line.init(coords:) >>> (diagionals ? { $0.all } : { $0.verticalOrHorizontalPoints })
}

func dangerPointsCount(from fileName: String, parsePoints: (String) -> [Point]) throws -> Int {
  try load(fileNamed: fileName)
    .lines
    .reduce(into: [Point: [Point]]()) { acc, str in
      acc.merge(Dictionary(grouping: parsePoints(str), by: id), uniquingKeysWith: +)
    }
    .filter(\.1.count >>> compare(>, 1))
    .count
}

//: * Experiment: Answers
let partOneAnswer = try! dangerPointsCount(from: "data", parsePoints: false |> curry(parsePoints(includingDiagonals:input:)))
let partTwoAnswer = try! dangerPointsCount(from: "data", parsePoints: true |> curry(parsePoints(includingDiagonals:input:)))
