import Foundation

open class BoolSet {

    open let trueString: String
    open let falseString: String
    open static let yesNoSet = BoolSet(trueString: "Yes", falseString: "No")
    open static let yNSet = BoolSet(trueString: "Y", falseString: "N")
    open static let oneZeroSet = BoolSet(trueString: "1", falseString: "0")
    open static let trueFalseSet = BoolSet(trueString: "True", falseString: "False")
    open static let allSets: [BoolSet] = [yesNoSet, yNSet, oneZeroSet, trueFalseSet]

    init(trueString: String, falseString: String) {
        self.trueString = trueString
        self.falseString = falseString;
    }

    open class func bestGuess(_ something: String) -> Bool {
        for set in allSets {
            if (set.isTrue(something)) {
                return true
            }
        }
        return false
    }

    open func isTrue(_ something: String) -> Bool {
        return trueString.equalsIgnoreCase(something)
    }

    open func isFalse(_ something: String) -> Bool {
        return !isTrue(something)
    }

    open func describe(_ something: Bool) -> String {
        if (something) {
            return trueString
        }
        return falseString
    }

}
