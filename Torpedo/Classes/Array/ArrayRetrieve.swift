import Foundation

public extension Array {

    public func randomElement() -> Element {
        return self[Int.random(max: count - 1)]
    }

}