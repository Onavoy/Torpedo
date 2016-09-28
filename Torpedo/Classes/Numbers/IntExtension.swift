import Foundation

public extension Int {

    public static func random(_ min: Int = 0, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }

    public func times(_ closure: @escaping (Int) -> Void) {
        for index in 0 ..< self {
            closure(index)
        }
    }

    public func isEven() -> Bool {
        return (self % 2) == 0
    }

    public func isOdd() -> Bool {
        return !isEven()
    }

}
