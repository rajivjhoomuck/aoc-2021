import Foundation

//: # Part 1
let parsedInts = try! load(fileNamed: "data", withExtension: "txt").lines.compactMap(Int.init)
let partOneAnswer = zip(parsedInts[...], parsedInts[1...]).map(<).filter(id).count

//: Part 2
//: > Assuming at least 3 lines, groupings = count - 2
let groupingsCount = parsedInts.count - 2
let groupedSum = Array(0..<groupingsCount)
  .map({ parsedInts[$0...($0+2)].reduce(0, +) })
let partTwoAnswer = zip(groupedSum[...], groupedSum[1...]).map(<).filter(id).count
