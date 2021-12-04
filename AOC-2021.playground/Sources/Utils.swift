import Foundation

public func load<A>(
  fileNamed name: String,
  lineTransform: (String) -> A?
) throws -> [A] {
  guard let url = Bundle.main.url(forResource: name, withExtension: "txt")
  else { throw "Invalid url" }

  return try String(contentsOf: url).lines.compactMap(lineTransform)
}

public extension String {
  var lines: [String] { split(separator: "\n").map(Self.init) }
}

extension String: Error {}

public let parseIntFromBinaryStringRep: (String) -> Int? = 2 |> flip(curry(Int.init(_: radix:)))
