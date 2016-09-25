import Foundation

public class Context: NSObject {
    
    private var dependencies: [AnyObject] = []
    private var properties: [String:AnyObject] = [:]
    private var isActive: Bool = false
    
    override init() {
        super.init()
        self.register(property: FileManager.default.urls(for :.documentDirectory, in : .userDomainMask).first! as AnyObject, withKey: "DocumentsDirectory")
    }
    
    public func get<T>(_ type: T.Type) -> T? {
        for obj in dependencies {
            if let objT = obj as? T {
                return objT
            }
        }
        return nil
    }
    
    public func getAll<T>(_ type: T.Type) -> [T] {
        var result :[T] = []
        for obj in dependencies {
            if let objT = obj as? T {
                result.append(objT)
            }
        }
        return result
    }
    
    public func get(withClass aClass: AnyClass) -> AnyObject? {
        for dependency in dependencies {
            if dependency.isKind(of: aClass) {
                return dependency
            }
        }
        return nil
    }
    
    public func getAll(withClass aClass: AnyClass) -> [AnyObject] {
        var result :[AnyObject] = []
        for dependency in dependencies {
            if dependency.isKind(of: aClass) {
                result.append(dependency)
            }
        }
        return result
    }
    
    public func getProperty<T>(key: String, type: T.Type) -> T? {
        if let foundProperty = properties[key.uppercased()] as? T {
            return foundProperty
        }
        return nil
    }
    
    public func getProperty(key: String) -> AnyObject? {
        return properties[key.uppercased()]
    }
    
    public func activate() {
        guard !isActive else {
            print("WARNING: Context already activated")
            return
        }
        isActive = true
        dependencies.append(self)
        resolveDependenciesDependencies()
    }
    
    public func register(_ object: AnyObject) {
        dependencies.append(object)
        if isActive {
            resolveDependencies(object)
        }
    }
    
    public func register(objects: [AnyObject]) {
        dependencies.append(contentsOf: objects)
        if isActive {
            resolveDependencies(objects: objects)
        }
    }
    
    public func register(property: AnyObject, withKey key: String) {
        properties[key.uppercased()] = property
    }
    
    public func resolveDependencies(objects: [AnyObject]) {
        for dependent in objects {
            resolveDependencies(dependent)
        }
    }
    
    public func instance(of aClass: AnyClass) -> AnyObject {
        let obj = RuntimeUtils.instance(of: aClass)
        resolveDependencies(obj)
        return obj
    }
    
    public func resolveDependencies(_ object: AnyObject) {
        let allProperties = ClassPropertiesUtil.generate(forClass: object_getClass(object))
        
        getDependencyProperties(allProperties).forEach { (aProperty) in
            if !aProperty.isWeak {
                print("WARNING: dependency property \(aProperty.name) on \(aProperty.sourceClass) not weak!")
            }
            satisfyDependency(aProperty, forDependent: object)
        }
        getPropertiesProperties(allProperties).forEach { (aProperty) in
            satisfyProperty(aProperty, forDependent: object)
        }
        getNewInstanceProperties(allProperties).forEach { (aProperty) in
            if aProperty.isWeak {
                print("ERROR: instance property \(aProperty.name) on \(aProperty.sourceClass) not strong!")
            }
            satisfyNewInstance(aProperty, forDependent: object)
        }
    }
    
    public func clone() -> Context {
        let cloneContext = Context()
        cloneContext.dependencies = dependencies
        cloneContext.properties = properties
        return cloneContext
    }
    
    private func resolveDependenciesDependencies() {
        for object in dependencies {
            resolveDependencies(object)
        }
    }
    
    private func getDependencyProperties(_ allProperties: [ClassProperty]) -> [ClassProperty] {
        return getProperties(allProperties, withPrefix: "d_")
    }
    
    private func getPropertiesProperties(_ allProperties: [ClassProperty]) -> [ClassProperty] {
        return getProperties(allProperties, withPrefix: "p_")
    }
    
    private func getNewInstanceProperties(_ allProperties: [ClassProperty]) -> [ClassProperty] {
        return getProperties(allProperties, withPrefix: "n_")
    }
    
    private func getProperties(_ allProperties: [ClassProperty], withPrefix prefix: String) -> [ClassProperty] {
        return allProperties.filter { (property) -> Bool in
            return property.name.hasPrefix(prefix)
        }
    }
    
    private func satisfyDependency(_ aProperty: ClassProperty, forDependent dependent: AnyObject) {
        if let dependency = get(withClass: aProperty.objectClass!) {
            dependent.setValue(dependency, forKeyPath: aProperty.name)
        } else {
            print("ERROR: could not satisfy \(aProperty.name) for \(aProperty.sourceClass)")
        }
    }
    
    private func satisfyProperty(_ aProperty: ClassProperty, forDependent dependent: AnyObject) {
        let propertyName = aProperty.name
        let propertyKey = propertyName.substring(from: propertyName.index(propertyName.startIndex, offsetBy: 2))
        if let dependency = getProperty(key: propertyKey) {
            dependent.setValue(dependency, forKeyPath: aProperty.name)
        } else {
            print("ERROR: could not satisfy \(aProperty.name) for \(aProperty.sourceClass)")
        }
    }
    
    private func satisfyNewInstance(_ aProperty: ClassProperty, forDependent dependent: AnyObject) {
        dependent.setValue(self.instance(of: aProperty.objectClass!), forKeyPath: aProperty.name)
    }
    
}
