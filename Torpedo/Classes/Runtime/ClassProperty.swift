import Foundation

public enum PropertyType {
    case unkown
    case primitive
    case selector
    case aClass
    case closure
    case object
}

public enum PrimitiveType {
    case unkown
    case char
    case uChar
    case bool
    case int
    case uInt
    case long
    case uLong
    case longLong
    case uLongLong
    case double
    case float
    case short
    case uShort
}

public struct ClassProperty {
    let propertyType: PropertyType
    let name: String
    let isReadOnly: Bool
    let isWeak: Bool
    let isNonatomic: Bool
    let isCopying: Bool
    let iVarName: String?
    let sourceClass: AnyClass
    let objectClass: AnyClass?
    let primitiveType: PrimitiveType?
    let protocols: [String]?
}
