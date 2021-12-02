import Foundation

// Credit: pointfree.co

// Forward Application
precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication   // pipe-forward operator; F#, Elm, Elixir
public func |> <A,B>(a: A, f: (A) -> B) -> B { // Usage: value |> f
  return f(a)
}

/// Forward Compose
precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication, EffectfulComposition, BackwardsComposition
}

infix operator >>>: ForwardComposition  // called 'forward-compose' or 'right-arrow'
public func >>> <A,B,C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { $0 |> f |> g } // { a in g(f(a)) }
}

/// Backwards Compose
precedencegroup BackwardsComposition {
  associativity: left
}

infix operator <<<: BackwardsComposition
public func <<< <A,B,C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
  return {a in f(g(a)) }
}

/// Single Type Compose
precedencegroup SingleTypeComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition
public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
  return f >>> g
}

public func <> <A>(
  f: @escaping (inout A) -> Void,
  g: @escaping (inout A) -> Void)
-> ((inout A) -> Void) {

  return { a in
    f(&a)
    g(&a)
  }
}

public func <> <A>(
  f: @escaping (A) -> Void,
  g: @escaping (A) -> Void)
-> ((A) -> Void) {

  return { a in
    f(a)
    g(a)
  }
}

/// Kleisli Composition
public func compose<A,B,C>(
  _ f: @escaping (A) -> (B, [String]),
  _ g: @escaping (B) -> (C, [String])
) -> (A) -> (C, [String]) {
  return { a in
    let (b, logs) = f(a)
    let (c, moreLogs) = g(b)
    return (c, logs + moreLogs)
  }
}

precedencegroup EffectfulComposition {
  associativity: left
  higherThan: ForwardApplication
  //lowerThan: ForwardComposition // Xcode does not like this one.
}

infix operator >=>: EffectfulComposition

// Optionaals
public func >=> <A, B, C>(
  _ f: @escaping (A) -> B?,
  _ g: @escaping (B) -> C?
) -> ((A) -> C?) {
  return { a in
    return f(a).flatMap(g)  // This kind of does the job
  }
}

// On Array
public func >=> <A, B, C>(
  _ f: @escaping (A) -> [B],
  _ g: @escaping (B) -> [C]
) -> ((A) -> [C]) {
  return { a in
    return f(a).flatMap(g)
  }
}

// Curry
public func curry<A,B,C>(_ f: @escaping (A,B) -> C) -> (A) -> (B) -> C {
  return { a in { b in f(a,b) } }
}

// Flips
public func flip<A,B,C>(_ f: @escaping (A)-> (B) -> C) -> (B) -> (A) -> C {
  return { b in { a in f(a)(b) } }
}

public func flip<A,B>(_ f: @escaping (A)-> () -> (B)) -> () -> (A) -> B {
  return { { a in f(a)() } }
}

// zurry
public func zurry<A>(_ f: () -> A) -> A {
  return f()
}

// map on Array
public func map<A,B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { $0.map(f) }
}

// map on functions
public func map<A, B, E>(_ f: @escaping (A) -> B)
-> (@escaping (E) -> A)
-> ((E) -> B)  {
  { g in g >>> f }
}

// pullback on functions
public func pullback<A, B, R>(_ f: @escaping (B) -> A) -> (@escaping (A) -> R) -> ((B) -> R)  {
  return { g in g <<< f }
}

// filter on Array
public func filter<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> [A] {
  return { $0.filter(p) }
}

// map on Optional
public func map<A, B>(_ f: @escaping (A) -> B) -> (A?) -> (B?) {
  return {
    switch $0  {
    case .none: return .none
    case let a?: return f(a)
    }
  }
}

// Constant function
public func const<A, B>(_ a: A) -> (B) -> A { { _ in a } }

public func id<A>(a: A) -> A { a }


@inline(__always) public func unpack<A, B, C>(_ tuple: (A, (B, C))) -> (A, B, C) { (tuple.0, tuple.1.0, tuple.1.1) }
@inline(__always) public func unpack<A, B, C, D>(_ tuple: (A, (B, C, D))) -> (A, B, C, D) { (tuple.0, tuple.1.0, tuple.1.1, tuple.1.2) }
@inline(__always) public func unpack<A, B, C, D, E>(_ tuple: (A, (B, C, D, E))) -> (A, B, C, D, E) { (tuple.0, tuple.1.0, tuple.1.1, tuple.1.2, tuple.1.3) }

@inline(__always) public func zip2<A,B>(_ xs: [A], _ ys: [B]) -> [(A, B)] {
  var result = [(A, B)]()
  (0..<min(xs.count, ys.count)).forEach { idx in
    result.append((xs[idx], ys[idx]))
  }
  return result
}

@inline(__always) public func zip3<A, B, C>(_ xs: [A], _ ys: [B], _ zs: [C]) -> [(A, B, C)] { zip2(xs, zip2(ys, zs)).map(unpack(_:)) }

@inline(__always) public func zip4<A, B, C, D>(_ ws: [A], _ xs: [B], _ ys: [C], _ zs: [D]) -> [(A, B, C, D)] { zip2(ws, zip3(xs, ys, zs)).map(unpack(_:)) }

@inline(__always) public func zip5<A, B, C, D, E>(_ vs: [A], _ ws: [B], _ xs: [C], _ ys: [D], _ zs: [E]) -> [(A, B, C, D, E)] { zip2(vs, zip4(ws, xs, ys, zs)).map(unpack(_:)) }

//: Zip with for Arrays
@inline(__always) public func zip2<A, B, C>(with f: @escaping (A, B) -> C) -> ([A], [B]) -> [C] { { zip2($0, $1).map(f) } }

@inline(__always) public func zip3<A, B, C, D>(with f: @escaping (A, B, C) -> D) -> ([A], [B], [C]) -> [D] { { zip3($0, $1, $2).map(f) } }

@inline(__always) public func zip4<A, B, C, D, E>(with f: @escaping (A, B, C, D) -> E) -> ([A], [B], [C], [D]) -> [E] { { zip4($0, $1, $2, $3).map(f) } }

@inline(__always) public func zip5<A, B, C, D, E, F>(with f: @escaping (A, B, C, D, E) -> F) -> ([A], [B], [C], [D], [E]) -> [F] { { zip5($0, $1, $2, $3, $4).map(f) } }

//: Optionals
@inline(__always) public func zip2<A,B>(_ a: A?, _ b: B?) -> (A, B)? {
  guard let a = a, let b = b else { return nil }
  return (a, b)
}

@inline(__always) public func zip3<A, B, C>(_ a: A?, _ b: B?, _ zs: C?) -> (A, B, C)? { zip2(a, zip2(b, zs)).map(unpack(_:)) }

@inline(__always) public func zip4<A, B, C, D>(_ a: A?, _ b: B?, _ c: C?, _ d: D?) -> (A, B, C, D)? { zip2(a, zip3(b, c, d)).map(unpack(_:)) }

@inline(__always) public func zip5<A, B, C, D, E>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?) -> (A, B, C, D, E)? { zip2(a, zip4(b, c, d, e)).map(unpack(_:)) }

//: Zip with for Optionals
@inline(__always) public func zip2<A, B, C>(with f: @escaping (A, B) -> C) -> (A?, B?) -> C? { { zip2($0, $1).map(f) } }

@inline(__always) public func zip3<A, B, C, D>(with f: @escaping (A, B, C) -> D) -> (A?, B?, C?) -> D? { { zip3($0, $1, $2).map(f) } }

@inline(__always) public func zip4<A, B, C, D, E>(with f: @escaping (A, B, C, D) -> E) -> (A?, B?, C?, D?) -> E? { { zip4($0, $1, $2, $3).map(f) } }

@inline(__always) public func zip5<A, B, C, D, E, F>(with f: @escaping (A, B, C, D, E) -> F) -> (A?, B?, C?, D?, E?) -> F? { { zip5($0, $1, $2, $3, $4).map(f) } }
