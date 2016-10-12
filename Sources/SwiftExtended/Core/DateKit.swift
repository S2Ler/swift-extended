import Foundation

public extension Date {
  var isToday: Bool {
    return Calendar.current.isDateInToday(self)
  }

  var isYesteday: Bool {
    return Calendar.current.isDateInYesterday(self)
  }
}
