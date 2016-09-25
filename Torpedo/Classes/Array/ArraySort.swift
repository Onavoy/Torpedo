import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


public extension Array where Element: Equatable {
    
    public func sorted(withArray otherArray: [Element]) -> [Element] {
        let sorted = self.sorted(by: {
            (first, second) -> Bool in
            let firstIndex = otherArray.index(of: first)
            let secondIndex = otherArray.index(of: second)
            return firstIndex < secondIndex
        })
        return sorted
    }
    
}
