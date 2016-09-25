import Foundation

open class ClassPropertiesUtil {
    
    open static var restrictedBaseClasses: [AnyClass] = [NSObject.self]
    
    open static func generate(forClass aClass: AnyClass?, limitAtBaseClasses baseClasses: [AnyClass] = []) -> [ClassProperty] {
        guard let theClass = aClass else {
            return []
        }
        
        guard !isAny(inList: restrictedBaseClasses, theClass: theClass) else {
            return []
        }
        
        var thisClassProps = generateOrRetrieveCached(theClass)
        if isAny(inList: baseClasses, theClass: theClass) {
            return thisClassProps
        } else if let theSuperClass = theClass.superclass() {
            if isAny(inList: baseClasses, theClass: theSuperClass) {
                let superClassProps = generateOrRetrieveCached(theSuperClass)
                thisClassProps.append(contentsOf: superClassProps)
                return thisClassProps
            } else {
                let superClassProps = generate(forClass: theSuperClass, limitAtBaseClasses: baseClasses)
                thisClassProps.append(contentsOf: superClassProps)
                return thisClassProps
            }
        }
        return thisClassProps
    }
    
    private static func generateOrRetrieveCached(_ aClass: AnyClass) -> [ClassProperty] {
        let className = NSStringFromClass(aClass)
        let cachedProps = propertiesCache[className]
        if cachedProps != nil {
            return cachedProps!
        }
        let generated = internalGenerate(forClass: aClass)
        propertiesCache[className] = generated
        return generated
    }
    
    private static func internalGenerate(forClass aClass: AnyClass) -> [ClassProperty] {
        var objProperties: [ClassProperty] = []
        var count = UInt32()
        
        guard let propertiesList = class_copyPropertyList(aClass, &count) else {
            return []
        }
        
        for index in 0..<Int(count) {
            let objProperty = propertiesList[index]!
            let attributesStr = self.unsafeToString(property_getAttributes(objProperty))
            let attributes = attributesStr.components(separatedBy: ",")
            let typeAttribute = self.propertyTypeAttribute(attributes)
            
            let name = self.propertyName(objProperty)
            let readOnly = self.isReadOnly(attributes)
            let weak = self.isWeak(attributes)
            let nonatomic = self.isNonatomic(attributes)
            let copying = self.isCopying(attributes)
            let propertyType = self.propertyType(typeAttribute)
            let iVarName = self.iVarName(attributes)
            
            var primitiveType : PrimitiveType?
            var objectClass : AnyClass?
            var protocols: [String]?
            
            
            if propertyType == .object {
                objectClass = self.objectClass(typeAttribute)
                protocols = self.protocols(typeAttribute)
            } else if propertyType == .primitive {
                 primitiveType = self.primitiveType(typeAttribute)
            }
            
            let property = ClassProperty(propertyType: propertyType, name: name, isReadOnly: readOnly, isWeak: weak, isNonatomic: nonatomic, isCopying: copying, iVarName: iVarName, sourceClass: aClass, objectClass: objectClass, primitiveType: primitiveType, protocols: protocols)
            
            objProperties.append(property)
        }
        free(propertiesList)
        return objProperties
    }
    
    private static func iVarName(_ attributes: [String]) -> String? {
        for attribute in attributes {
            if attribute.hasPrefix("V") {
                return attribute.substring(from: attribute.index(attribute.startIndex, offsetBy: 1))
            }
        }
        return nil;
    }
    
    private static func objectClass(_ typeAttr: String?) -> AnyClass? {
        if typeAttr == nil {
            return nil
        }
        let classNameAndProtocols = extractClassNameAndProtocolsString(typeAttr!)
        if StringUtils.isBlank(classNameAndProtocols) {
            return nil
        }
        let scanner = Scanner(string: classNameAndProtocols!)
            scanner.scanString("\"", into: nil)
        var className: NSString?
        scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "\"<"), into: &className)
        if StringUtils.isNotBlank(className as? String) {
            return NSClassFromString(className as! String)
        }
        return nil
    }
    
    private static func protocols(_ typeAttr: String?) -> [String] {
        guard typeAttr != nil else {
            return []
        }
        let classNameAndProtocols = extractClassNameAndProtocolsString(typeAttr!)
        if StringUtils.isBlank(classNameAndProtocols) {
            return []
        }
        
        let scanner = Scanner(string: classNameAndProtocols!)
        var protocols : [String] = []
        
        scanner.scanUpTo("<", into: nil)
        while scanner.scanString("<", into: nil) {
            var protocolName : NSString? = nil
            scanner.scanUpTo(">", into: &protocolName)
            if StringUtils.isNotBlank(protocolName as String?) {
                protocols.append(protocolName as! String)
            }
            scanner.scanString(">", into: nil)
        }
        
        return protocols
    }
    
    private static func extractClassNameAndProtocolsString(_ attribute: String) -> String? {
        if attribute.length > 2 {
            return attribute.substring(from: attribute.index(attribute.startIndex, offsetBy: 2))
        }
        return nil
    }
    
    private static func propertyName(_ property: objc_property_t) -> String {
        return unsafeToString(property_getName(property))
    }
    
    private static func unsafeToString(_ unsafe: UnsafePointer<Int8>) -> String {
        return String(utf8String: unsafe)!
    }
    
    private static func isReadOnly(_ cAttrs: [String]) -> Bool {
        return cAttrs.contains("R")
    }
    
    private static func isWeak(_ cAttrs: [String]) -> Bool {
        return cAttrs.contains("W")
    }
    
    private static func isNonatomic(_ cAttrs: [String]) -> Bool {
        return cAttrs.contains("N")
    }
    
    private static func isCopying(_ cAttrs: [String]) -> Bool {
        return cAttrs.contains("C")
    }
    
    private static func primitiveType(_ typeAttr: String?) -> PrimitiveType? {
        if StringUtils.isBlank(typeAttr) {
            return .unkown
        }
        let actualTypeAttr = typeAttr!
        let primitiveChar = actualTypeAttr.substring(from: actualTypeAttr.index(actualTypeAttr.startIndex, offsetBy: 1))
        return primitivesMap[primitiveChar]
    }
    
    private static func propertyType(_ attributeString: String?) -> PropertyType {
        guard attributeString != nil else {
            return .primitive
        }
        
        let actualAttr = attributeString!
        
        if actualAttr.hasPrefix("T@?") {
            return .closure
        } else if actualAttr.hasPrefix("T@") {
            return .object
        } else if actualAttr.hasPrefix("T:") {
            return .selector
        } else if actualAttr.hasPrefix("T#") {
            return .aClass
        }
        
        return .primitive
    }

    private static func propertyTypeAttribute(_ attributes: [String]) -> String? {
        for attr in attributes {
            if attr.hasPrefix("T") {
                return attr
            }
        }
        return nil
    }
    
    private static func isAny(inList: [AnyClass], theClass : AnyClass) -> Bool {
        for aClass in inList {
            if aClass == theClass {
                return true
            }
        }
        return false
    }
    
    private static var propertiesCache: [String:[ClassProperty]] = [:]
    
    private static let primitivesMap : [String:PrimitiveType] = [
        "C" : .uChar,
        "B" : .bool,
        "i" : .int,
        "I" : .uInt,
        "l" : .long,
        "L" : .uLong,
        "q" : .longLong,
        "Q" : .uLongLong,
        "d" : .double,
        "f" : .float,
        "s" : .short,
        "S" : .uShort
    ]
}
