import Foundation

func zipped<A>(xs: [A]) -> Zip2Sequence<ArraySlice<A>, ArraySlice<A>> { zip(xs[...], xs[1...]) }

let parsedInts = try! load(fileNamed: "data", lineTransform: Int.init)
let partOneAnswer = zipped(xs: parsedInts).map(<).filter(id).count
//: > Assuming at least 3 lines, groupings = count - 2
let groupedSum = Array(0..<(parsedInts.count - 2)).map({ parsedInts[$0...($0+2)].reduce(0, +) })
let partTwoAnswer = zipped(xs: groupedSum).map(<).filter(id).count
