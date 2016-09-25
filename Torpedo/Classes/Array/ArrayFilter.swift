import Foundation

public extension Array {

    public func filter<T>(withType type: T.Type) -> [T] {
        var result: [T] = []
        for element in self {
            if let element = element as? T {
                result.append(element)
            }
        }
        return result;
    }

    public func filterElementsNotWithType<T>(_ type: T.Type) -> [Element] {
        var result: [Element] = []
        for element in self {
            if let _ = element as? T {
                continue
            }
            result.append(element)
        }
        return result;
    }

    public func filterUniqueElements<Element:Equatable>() -> [Element] {
        var result: [Element] = []
        for element in self {
            if !result.contains(element as! Element) {
                result.append(element as! Element)
            }
        }
        return result
    }
    
}

public extension Array where Element: Equatable {
    
    public func elementAfter(_ element: Element) -> Element? {
        if let index = self.index(of: element) {
            let nextIndex = index.advanced(by: 1)
            if self.count > nextIndex {
                return self[nextIndex]
            }
        }
        return nil
    }
    
    public func elementsNotIn(_ otherArray: [Element]) -> [Element] {
        var result : [Element] = []
        for element in self {
            if !otherArray.contains(element) {
                result.append(element)
            }
        }
        return result
    }
    
    public mutating func removeAll(_ elements: [Element]) {
        for element in elements {
            if let index = self.index(of: element) {
                self.remove(at: index)
            }
        }
    }
    
}
