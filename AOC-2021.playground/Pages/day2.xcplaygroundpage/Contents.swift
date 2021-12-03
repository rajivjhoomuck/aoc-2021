import Foundation

//: # Part 1
enum Command {
  case x(Int)
  case y(Int)

  init?(rawValue: String) {
    let command = rawValue.split(separator: " ")
    switch (command[0], Int(command[1])) {
    case ("forward", let value?): self = .x(value)
    case ("down", let value?): self = .y(value)
    case ("up", let value?): self = .y(-value)
    default: return nil
    }
  }
}

let displacement = try! load(
  fileNamed: "data",
  withExtension: "txt",
  lineTransform: Command.init(rawValue:)
).reduce(into: (x: 0, y: 0), { acc, command in
  switch command {
  case let .x(x): acc.x += x
  case let .y(y): acc.y += y
  }
})

let partOneAnswer = displacement.x * displacement.y

//: # Part 2
struct State {
  var aim: Int = 0
  var depth: Int = 0
  var displacement: Int = 0

  mutating func roger(command: Command) {
    switch command {
    case let .x(x):
      displacement += x
      depth += aim * x
    case let .y(y):
      aim += y
    }
  }
}

let reducedState = try! load(
  fileNamed: "data",
  withExtension: "txt",
  lineTransform: Command.init(rawValue:)
).reduce(into: State(), { state, command in state.roger(command: command) })

let partTwoAnswer = reducedState.displacement * reducedState.depth
