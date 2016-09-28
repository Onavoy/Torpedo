import Foundation

public extension String {

    public func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    public func leftPadded(with padding: String, toLength finalLength: Int) -> String {
        guard length < finalLength else {
            return self
        }
        let remainingLength = finalLength - length
        let finalPadding: String = repeating(string: padding, toLength: remainingLength)
        return "\(finalPadding)\(self)"
    }

    public func rightPadded(with padding: String, toLength finalLength: Int) -> String {
        guard length < finalLength else {
            return self
        }
        let remainingLength = finalLength - length
        let finalPadding: String = repeating(string: padding, toLength: remainingLength)
        return "\(self)\(finalPadding)"
    }

    public func repeating(string: String, toLength finalLength: Int) -> String {
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
