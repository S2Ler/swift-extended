import Foundation

public extension RandomAccessCollection where Element: Comparable, Index == Int {
  func binarySearch(key: Element) -> Index? {
    var lowerBound = self.startIndex
    var upperBound = self.endIndex

    while lowerBound < upperBound {
      let midIndex = lowerBound + (upperBound - lowerBound) / 2

      if self[midIndex] == key {
        return midIndex
      } else if self[midIndex] < key {
        lowerBound = midIndex + 1
      } else {
        upperBound = midIndex
      }
    }

    return nil
  }
}
