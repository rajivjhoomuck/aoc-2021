import Foundation

public func load(fileNamed name: String) throws -> String {
  try Bundle.main.url(forResource: name, withExtension: "txt").map({ try String.init(contentsOf:$0) })!
}

public func load<A>(
  fileNamed name: String,
  lineTransform: (String) -> A?
) throws -> [A] {
  try load(fileNamed: name).lines.compactMap(lineTransform)
}

public extension String {
  var lines: [String] { split(separator: "\n").map(Self.init) }
}

extension String: Error {}

public let parseIntFromBinaryStringRep: (String) -> Int? = 2 |> flip(curry(Int.init(_: radix:)))

public extension Array {
  var head: Element { self[0] }
  var tail: [Element] { Self(self[1...]) }
}

public func transpose<A>(_ input: [[A]]) -> [[A]] {
  guard !input.head.isEmpty else { return [] }
  return [input.map(\.head)] + transpose(input.map(\.tail))
}

public let substring2Int: (Substring) -> Int? = String.init >>> Int.init
public let char2Int: (Character) -> Int? = String.init >>> Int.init

public func isGreaterThan(number: Int) -> (Int) -> Bool { { x in x > number } }
public func compare(_ comparison: @escaping (Int, Int) -> Bool, _ number: Int) -> (Int) -> Bool { { comparison($0, number) } }
