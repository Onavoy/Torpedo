import Foundation

public enum DayOfWeek: String {
    case Sun = "Sun"
    case Mon = "Mon"
    case Tue = "Tue"
    case Wed = "Wed"
    case Thu = "Thu"
    case Fri = "Fri"
    case Sat = "Sat"
    
    public var fullName: String {
        switch (self) {
        case .Sun:
            return "Sunday"
        case .Mon:
            return "Monday"
        case .Tue:
            return "Tuesday"
        case .Wed:
            return "Wednesday"
        case .Thu:
            return "Thursday"
        case .Fri:
            return "Friday"
        case .Sat:
            return "Saturday"
        }
    }
    
    public static let allValues = [Sun,Mon,Tue,Wed,Thu,Fri,Sat]
}

public extension Date {
    public func dayOfWeek() -> DayOfWeek {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let weekday = (calendar as NSCalendar).component(.weekday, from: self)
        switch weekday {
        case 0:
            return .Sat
        case 1:
            return .Sun
        case 2:
            return .Mon
        case 3:
            return .Tue
        case 4:
            return .Wed
        case 5:
            return .Thu
        case 6:
            return .Fri
        case 7:
            return .Sat
        default:
            return .Mon
        }
    }
}
