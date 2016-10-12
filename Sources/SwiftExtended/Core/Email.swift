import Foundation

public struct Email {
  private let emailString: String

  public init?(_ emailString: String?) {
    guard let emailString = emailString?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
    if Email.isValidEmailString(emailString) {
      self.emailString = emailString
    } else {
      return nil
    }
  }
}

extension Email: CustomStringConvertible {
  public var description: String {
    return emailString
  }
}

extension Email: Hashable, Equatable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(emailString)
  }

  public static func ==(lhs: Email, rhs: Email) -> Bool {
    return lhs.emailString == rhs.emailString
  }
}

public extension Email {
  static func isValidEmailString(_ emailString: String) -> Bool {
    let emailRegex = try! NSRegularExpression(pattern: "[^@]+@([^@]+)", options: [])

    return emailRegex.firstMatch(in: emailString,
                                 options: [],
                                 range: NSRange(location: 0, length: emailString.utf16.count)) != nil
  }
}

public extension Email {
  var host: String {
    return emailString.components(separatedBy: "@")[1]
  }

  var name: String {
    return emailString.components(separatedBy: "@")[0]
  }
}
