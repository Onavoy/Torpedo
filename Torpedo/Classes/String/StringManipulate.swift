import Foundation

public extension String {

    public func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func leftPadWith(_ padding: String, toLength finalLength: Int) -> String {
        guard length < finalLength else {
            return self
        }
        let remainingLength = finalLength - length
        let finalPadding: String = repeatString(padding, toLength: remainingLength)
        return "\(finalPadding)\(self)"
    }

    func rightPadWith(_ padding: String, toLength finalLength: Int) -> String {
        guard length < finalLength else {
            return self
        }
        let remainingLength = finalLength - length
        let finalPadding: String = repeatString(padding, toLength: remainingLength)
        return "\(self)\(finalPadding)"
    }

    func repeatString(_ string: String, toLength finalLength: Int) -> String {
        var finalString = string
        while finalString.length < finalLength {
            finalString.append(string)
        }
        if finalString.length > finalLength {
            let index: String.Index = finalString.characters.index(finalString.startIndex, offsetBy: finalLength)
            return finalString.substring(to: index)
        }
        return finalString
    }

}
