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

  init(coords: [Point]) { (self.start, self.end) = (coords[0], coords[1]) }

  func makeRange(i: Int, j: Int) -> [Int] { Array(i <= j ? i...j : j...i) }
}

func parsePointsOnHVLines(_ input: String) -> [Point] {
  input.components(separatedBy: " -> ").map(Point.init(input:))
    |> Line.init(coords:) >>> \Line.verticalOrHorizontalPoints
}

//: * Experiment: Answers
let partOneAnswer = try! load(fileNamed: "data")
  .lines
  .reduce(into: [Point: [Point]]()) { acc, str in
    acc.merge(Dictionary(grouping: parsePointsOnHVLines(str), by: id), uniquingKeysWith: +)
  }
  .filter(\.1.count >>> compare(>, 1))
  .count
