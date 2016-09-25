import Foundation

open class ArrayUtils {
    
    open class func equalsIgnoreSort<Element:Equatable>(_ firstArray: [Element], secondArray: [Element]) -> Bool {
        guard firstArray.count == secondArray.count else {
            return false
        }
        for element in firstArray {
            if !secondArray.contains(element) {
                return false
            }
        }
        return true
    }
    
}
