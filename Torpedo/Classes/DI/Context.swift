import Foundation

public protocol Dependent: class {
    func resolveDependencies(context: Context)
}

public enum ConstructionError: Error {
    case invalidParameters(message: String)
    case noConstructorFound
    case notMyJob
}

public protocol Constructor: class {
    
    func construct<T>(type: T.Type, withContext: Context, params: [String:Any]) throws -> T
    
}

open class Context {
    
    private var dependencies: [Any] = []
    private var properties: [String:Any] = [:]
    private var isActive: Bool = false
    private var typeConstructorsMap : [String:Constructor] = [:]
    
    public init() {
        #if os(iOS)
            UIKitTorpedoContext.configure()
        #endif
        self.register(property: FileManager.default.urls(for :.documentDirectory, in : .userDomainMask).first!, withKey: "DocumentsDirectory")
    }
    
    open func get<T>(_ type: T.Type) -> T! {
        for obj in dependencies {
            if let objT = obj as? T {
                return objT
            }
        }
        return nil
    }
    
    open func getAll<T>(_ type: T.Type) -> [T] {
        var result :[T] = []
        for obj in dependencies {
            if let objT = obj as? T {
                result.append(objT)
            }
        }
        return result
    }
    
    open func getProperty<T>(key: String, type: T.Type) -> T? {
        if let foundProperty = properties[key.uppercased()] as? T {
            return foundProperty
        }
        return nil
    }
    
    open func getProperty(key: String) -> Any? {
        return properties[key.uppercased()]
    }
    
    open func activate() {
        guard !isActive else {
            print("WARNING: Context already activated")
            return
        }
        isActive = true
        dependencies.append(self)
        resolveDependenciesDependencies()
    }
    
    open func register(_ object: Any) {
        dependencies.append(object)
        if isActive {
            resolveDependencies(object)
        }
    }
    
    open func register(objects: [Any]) {
        dependencies.append(contentsOf: objects)
        if isActive {
            resolveDependencies(objects: objects)
        }
    }
    
    open func register(property: Any, withKey key: String) {
        properties[key.uppercased()] = property
    }
    
    open func register<T>(constructor: Constructor, forType type: T.Type) {
        typeConstructorsMap["\(type)"] = constructor
        register(constructor)
    }
    
    open func resolveDependencies(objects: [Any]) {
        for dependent in objects {
            resolveDependencies(dependent)
        }
    }
    
    open func instance<T>(ofType type : T.Type, params: [String:Any] = [:]) throws -> T {
        guard let constructor = findConstructor(type: type) else {
            throw ConstructionError.noConstructorFound
        }
        let instance = try constructor.construct(type: type, withContext: self, params: params)
        resolveDependencies(instance)
        return instance
    }
    
    open func resolveDependencies(_ object: Any) {
        if let asProto = object as? Dependent {
            asProto.resolveDependencies(context: self)
        }
    }
    
    open func clone() -> Context {
        let cloneContext = Context()
        cloneContext.dependencies = dependencies
        cloneContext.properties = properties
        cloneContext.typeConstructorsMap = typeConstructorsMap
        return cloneContext
    }
    
    private func resolveDependenciesDependencies() {
        for object in dependencies {
            resolveDependencies(object)
        }
    }
    
    private func findConstructor<T>(type: T.Type) -> Constructor? {
        let key = "\(type)"
        return typeConstructorsMap[key]
    }
    
}
