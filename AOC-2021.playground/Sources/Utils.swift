import Foundation

public struct FileLoadingError: Error {
  let desc: String
}

public func load<A>(
  fileNamed name: String,
  withExtension `extension`: String,
  lineTransform: (String) -> A?
) throws -> [A] {
  guard let url = Bundle.main.url(forResource: name, withExtension: `extension`)
  else { throw FileLoadingError(desc: "Invalid url") }

  return try String(contentsOf: url).lines.compactMap(lineTransform)
}

public extension String {
  var lines: [String] { split(separator: "\n").map(Self.init) }
}
