import Foundation

//: Part 1
let lines = try! load(fileNamed: "data", lineTransform: id)
let linesCount = lines.count
let seed = Array(repeating: 0, count: lines[0].count)
let sum = lines.reduce(seed) { acc, line in zip(line.compactMap(String.init >>> Int.init), acc).map(+) }
let gammaReport = sum
  .map({ $0 >= (linesCount / 2) ? "1" : "0" })
  .reduce("", +)
  .trimmingCharacters(in: .whitespacesAndNewlines)
let epsilonReport = gammaReport.map({ (c: Character) in c == "1" ? "0" : "1" }).reduce("", +)
let gammaRate = Int(gammaReport, radix: 2)
let epsilonRate = Int(epsilonReport, radix: 2)
let answerPartOne = zip2(gammaRate, epsilonRate).map(*)

