import Foundation

public extension Dictionary {
    
    public func encodedAsJSON() throws -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
    
    public func encodedAsJSONString() throws -> String {
        return try! String(data: encodedAsJSON(), encoding: .utf8)!
    }
    
}

public extension Array {
    
    public func encodedAsJSON() throws -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
    
    public func encodedAsJSONString() throws -> String {
        return try! String(data: encodedAsJSON(), encoding: .utf8)!
    }
    
}

public extension Data {
    
    public func jsonAsArray() throws -> [Any] {
        return try! JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [Any]
    }
    
    public func jsonAsDictionary() throws -> [AnyHashable:Any] {
        return try! JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [AnyHashable:Any]
    }
    
}
