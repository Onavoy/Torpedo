import Foundation

public extension Date {
    
    private static var formatsMap: [String : DateFormatter] = [:]
    
    public var milliseconds: Double {
        return timeIntervalSince1970 * 1000.0
    }
    
    public var millisecondsString : String {
        return String(milliseconds)
    }
    
    public init(milliseconds: Double) {
        self.init(timeIntervalSince1970: milliseconds / 1000.0)
    }

    public init(milliseconds: Int64) {
        self.init(timeIntervalSince1970: Double(milliseconds) / 1000.0)
    }
    
    public init(milliseconds: Int32) {
        self.init(timeIntervalSince1970: Double(milliseconds) / 1000.0)
    }
    
    public init(milliseconds: UInt) {
        self.init(timeIntervalSince1970: Double(milliseconds) / 1000.0)
    }

    public init(milliseconds: String) {
        self.init(timeIntervalSince1970: Double(milliseconds)! / 1000.0)
    }
    
    public init?(string: String, format: String) {
        let date = Date.formatter(with: format).date(from: string)
        if date != nil {
            self = date!
            return
        }
        return nil
    }
    
    public func format(_ format: String) -> String {
        return Date.formatter(with: format).string(from: self)
    }
    
    public static func formatter(with format: String) -> DateFormatter {
        var foundFormatter = Date.formatsMap[format]
        if foundFormatter == nil {
            foundFormatter = DateFormatter()
            foundFormatter?.dateFormat = format
            Date.formatsMap[format] = foundFormatter!
        }
        return foundFormatter!
    }
    
}
