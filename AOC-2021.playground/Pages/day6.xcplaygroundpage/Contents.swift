let data = try! load(fileNamed: "data").trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").compactMap(substring2Int)
let sample = [3,4,3,1,2]
let initials = (0...8).reduce(into: [Int: Int](), { acc, key in acc[key] = 0 })
let counts = Dictionary(grouping: data, by: id).mapValues(\.count).merging(initials, uniquingKeysWith: +)

let partOneAnswer = (0..<80).reduce(into: counts, { acc, _ in
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
})


let bblele = (0..<80).reduce(into: counts, { acc, _ in
  let head = acc[0] ?? 0
  var buffer = [Int: Int]()

  for x in 0...7 { buffer[x] = acc[x + 1]; }
  buffer[6] = (buffer[6] ?? 0) + head;
  buffer[8] = head;

  acc = buffer
})
partOneAnswer.values.reduce(0, +)
bblele.values.reduce(0, +)

data.reduce(0, +)
print(data)
