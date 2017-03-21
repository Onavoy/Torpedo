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

    public func filterNot<T>(withType type: T.Type) -> [Element] {
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
    
    public func chucnked(inPartsOf numberOfPiecesInChunk: Int) -> [[Element]] {
        var chunks : [[Element]] = []
        let remainderOfSplits = self.count % numberOfPiecesInChunk
        let remainderAddition = remainderOfSplits > 0 ? 1 : 0
        let numberOfChunks = (self.count / numberOfPiecesInChunk) + remainderAddition
        numberOfChunks.times { (index) in
            chunks.append(self.safeSubArray(startIndex:
                index * numberOfPiecesInChunk
                , finalIndex: ((index + 1) * numberOfPiecesInChunk) - 1))
        }
        return chunks
    }
    
    public func safeSubArray(startIndex: Int, finalIndex: Int) -> [Element] {
        let minusCount = self.count - 1
        let finalEndIndex = minusCount < finalIndex ? minusCount : finalIndex
        return Array(self[startIndex...finalEndIndex])
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
