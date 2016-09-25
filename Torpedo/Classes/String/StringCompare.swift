import Foundation

public extension String {

    public var length: Int {
        return characters.count
    }

    public func equalsIgnoreCase(_ another: String?) -> Bool {
        if another == nil {
            return length == 0
        }
        return caseInsensitiveCompare(another!) == .orderedSame
    }

    public func equals(_ another: String?) -> Bool {
        return self == another
    }

    public func containsStringIgnoreCase(_ other: String) -> Bool {
        let lowerSelf = lowercased()
        let lowerOther = other.lowercased()
        return lowerSelf.contains(lowerOther)
    }

}
