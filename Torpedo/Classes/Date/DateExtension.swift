import Foundation

public extension Date {
    
    private static var formatsMap: [String : DateFormatter] = [:]
    
    private var timestamp: Int64 {
        return Int64(timeIntervalSince1970 * 1000.0)
    }
    
    public var timestampString : String {
        return String(timestamp)
    }
    
    public init(timestamp: Int64) {
        self.init(timeIntervalSince1970: TimeInterval(Double(timestamp) / 1000.0))
    }
    
    public init(timestampString: String) {
        self.init(timeIntervalSince1970: TimeInterval(Double(timestampString)! / 1000.0))
    }
    
    public init?(string: String, format: String) {
        let date = Date.formatter(with: format).date(from: string)
        if date != nil {
            self = date!
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
