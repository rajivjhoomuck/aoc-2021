import Foundation

let parsedInts = try! load(fileNamed: "data", withExtension: "txt")
  .lines
  .compactMap(Int.init)

let answer = zip(parsedInts[...], parsedInts[1...]).map(<).filter(id).count
