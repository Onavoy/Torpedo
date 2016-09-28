import Foundation

open class StringUtils {

    open class func isBlank(_ aString: String?) -> Bool {
        if isEmpty(aString) {
            return true
        } else {
            let trimmed = aString!.trimmed()
            if trimmed.length == 0 {
                return true
            }
        }
        return false
    }

    open class func isNotBlank(_ aString: String?) -> Bool {
        return !isBlank(aString)
    }

    open class func isEmpty(_ aString: String?) -> Bool {
        if NSNull().isEqual(aString) {
            return true
        } else {
            if let aString = aString {
                if aString.length == 0 {
                    return true
                }
            } else {
                return true
            }
        }
        return false
    }

    open class func isNotEmpty(_ aString: String?) -> Bool {
        return !isEmpty(aString)
    }

    open class func equals(_ first: String?, second: String?) -> Bool {
        if first == nil && second == nil {
            return true
        }
        if first == nil && isEmpty(second!) {
            return true
        }
        if second == nil && isEmpty(first!) {
            return true
        }
        return first!.equals(second!)
    }

    open class func equalsIgnoreCase(_ first: String?, second: String?) -> Bool {
        if (equals(first, second: second)) {
            return true
        }
        return first!.equalsIgnoreCase(second!)
    }

}
