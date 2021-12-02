import Foundation

public struct FileLoadingError: Error {
  let desc: String
}

public func load(fileNamed name: String, withExtension `extension`: String) throws -> String {
  guard let url = Bundle.main.url(forResource: name, withExtension: `extension`)
  else { throw FileLoadingError(desc: "Invalid url") }

  return try String(contentsOf: url)
}

public extension String {
  var lines: [String] { split(separator: "\n").map(Self.init) }
}
