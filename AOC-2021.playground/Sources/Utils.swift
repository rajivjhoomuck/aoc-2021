import Foundation

public struct FileLoadingError: Error {
  let desc: String
}

public func load<A>(
  fileNamed name: String,
  lineTransform: (String) -> A?
) throws -> [A] {
  guard let url = Bundle.main.url(forResource: name, withExtension: "txt")
  else { throw FileLoadingError(desc: "Invalid url") }

  return try String(contentsOf: url).lines.compactMap(lineTransform)
}

public extension String {
  var lines: [String] { split(separator: "\n").map(Self.init) }
}

public let parseIntFromBinaryStringRep: (String) -> Int? = 2 |> flip(curry(Int.init(_: radix:)))
