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

let commands = try! load(fileNamed: "data", lineTransform: Command.init(rawValue:))
let displacement = commands
  .reduce(into: (x: 0, y: 0), { acc, command in
    switch command {
    case let .x(x): acc.x += x
    case let .y(y): acc.y += y
    }
  })

let partOneAnswer = displacement.x * displacement.y

//: # Part 2
struct State {
  var aim = 0
  var depth = 0
  var horizontalDisplacement = 0

  mutating func roger(command: Command) {
    switch command {
    case let .x(x): horizontalDisplacement += x; depth += aim * x
    case let .y(y): aim += y
    }
  }
}

let reducedState = commands.reduce(into: State(), { state, command in state.roger(command: command) })
let partTwoAnswer = reducedState.horizontalDisplacement * reducedState.depth
