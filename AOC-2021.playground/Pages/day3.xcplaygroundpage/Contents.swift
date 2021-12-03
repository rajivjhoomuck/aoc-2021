import Foundation

//: # Part 1
let lines = try! load(fileNamed: "data", lineTransform: id)
let linesCount = lines.count
let seed = Array(repeating: 0, count: lines[0].count)
let gammaReport = lines
  .reduce(seed, { acc, line in zip(line.compactMap(String.init >>> Int.init), acc).map(+) })
  .map({ $0 >= (linesCount / 2) ? "1" : "0" })
  .reduce("", +)
  .trimmingCharacters(in: .whitespacesAndNewlines)
let epsilonReport = gammaReport.map({ (c: Character) in c == "1" ? "0" : "1" }).reduce("", +)
let answerPartOne = [gammaReport, epsilonReport].compactMap(parseIntFromBinaryStringRep).reduce(1, *)

//: # Part 2
func gasLevelReporter(data: [String], comparison: @escaping (Int, Int) -> Bool, bitOffset: Int) throws -> String {
  let sieve = Dictionary(grouping: data, by: { s in s[s.index(s.startIndex, offsetBy: bitOffset)] })
  guard
    let next = zip2(with:{ ones, zeros in comparison(ones.count, zeros.count) ? ones : zeros })(sieve["1"], sieve["0"])
  else { throw NSError(domain: "", code: 7, userInfo: nil) }
  return next.count == 1
    ? next[0]
    : try gasLevelReporter(data: next, comparison: comparison, bitOffset: bitOffset + 1)
}
let o2 = try! gasLevelReporter(data: lines, comparison: >=,  bitOffset: 0)
let co2 = try! gasLevelReporter(data: lines, comparison: <,  bitOffset: 0)

let partTwoAnswer = [o2, co2].compactMap(parseIntFromBinaryStringRep).reduce(1, *)
