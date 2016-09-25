import Foundation

public extension Int {

    public static func random(_ min: Int = 0, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }

    public func times(_ closure: (Int) -> Void) {
        for index in 0 ..< self {
            closure(index)
        }
    }

    func isEven() -> Bool {
        return (self % 2) == 0
    }

    func isOdd() -> Bool {
        return !isEven()
    }

}
