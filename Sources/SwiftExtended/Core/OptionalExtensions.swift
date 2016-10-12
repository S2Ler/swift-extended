import Foundation

public extension Optional {
  func andThen<U>(f: (Wrapped) throws -> U?) rethrows -> U? {
    switch self {
    case .some(let x):
      return try f(x)
    case .none:
      return nil
    }
  }

  func apply(f: (Wrapped) throws -> ()) rethrows {
    switch self {
    case .some(let x):
      try f(x)
    case .none:
      break
    }
  }

  func unwrap(file: StaticString = #file, line: UInt = #line) -> Wrapped {
    guard let unwrapped = self else {
      let message = "Required value was nil in \(file), at line \(line)"
      preconditionFailure(message)
    }

    return unwrapped
  }
}
