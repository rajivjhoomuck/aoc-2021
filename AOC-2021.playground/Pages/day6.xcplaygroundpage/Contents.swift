let data = try! load(fileNamed: "data").trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").compactMap(substring2Int)
let sample = [3,4,3,1,2]
let initials = (0...8).reduce(into: [Int: Int](), { acc, key in acc[key] = 0 })
let counts = Dictionary(grouping: data, by: id).mapValues(\.count).merging(initials, uniquingKeysWith: +)

func calcAnswer(days: Int) -> Int {
  (0..<days).reduce(into: counts, { acc, _ in
    var buffer = [Int: Int]()
    for (key, value) in acc {
      if key == 0 {
        buffer[6, default: 0] += value
        buffer[8, default: 0] += value
      } else {
        buffer[key - 1, default: 0] += value
      }
    }
    acc = buffer
  }).values.reduce(0, +)
}

let partOneAnswer = calcAnswer(days: 80)
let partTwoAnswer = calcAnswer(days: 256)
