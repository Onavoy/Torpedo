import Foundation

public struct CalendarConstants {
    public static let AllComponents : Set<Calendar.Component> = [.era, .year,.month,.day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .nanosecond, .calendar, .timeZone]
}

public class DateUtils {
    
    public static func start(of date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(CalendarConstants.AllComponents, from: date)
        components.hour  = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }
    
    public static func end(of date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(CalendarConstants.AllComponents, from: date)
        components.hour  = 23
        components.minute = 59
        components.second = 59
        components.nanosecond = 999
        return calendar.date(from: components)!
    }
    
    public static func isToday(_ date: Date) -> Bool {
        return isDate(date, sameDayAs: Date())
    }
    
    public static func isPast(_ date: Date) -> Bool {
        return isDate(date, before: Date())
    }
    
    public static func isFuture(_ date: Date) -> Bool {
        return isDate(date, after: Date())
    }
    
    public static func isDate(_ date: Date, sameDayAs secondDate: Date) -> Bool {
        let calendar = Calendar.current
        var firstComponents = calendar.dateComponents(CalendarConstants.AllComponents, from: date)
        
        var secondComponents = calendar.dateComponents(CalendarConstants.AllComponents, from: secondDate)
        
        if firstComponents.year != secondComponents.year {
            return false
        }
        if firstComponents.month != secondComponents.month {
            return false
        }
        return firstComponents.day == secondComponents.day
    }
    
    public static func daysSince(_ date: Date) -> Int {
        return daysBetween(date, and: Date())
    }
    
    public static func daysBetween(_ date: Date, and secondDate: Date) -> Int {
        let intervalBetween = Int(date.timeIntervalSince1970 - secondDate.timeIntervalSince1970)
        let absoluteInterval = abs(intervalBetween)
        return absoluteInterval / 86400
    }
    
    public static func isDate(_ date: Date, before secondDate: Date) -> Bool {
        return date.compare(secondDate) == .orderedAscending
    }
    
    public static func isDate(_ date: Date, after secondDate: Date) -> Bool {
        return date.compare(secondDate) == .orderedDescending
    }
    
    public static func date(_ date :Date, minusDays: Int) -> Date {
        return self.date(date, plusDays: -1 * minusDays)
    }
    
    public static func date(_ date :Date, plusDays: Int) -> Date {
        return date.addingTimeInterval(TimeInterval(86400 * plusDays))
    }
    
    public static func date(_ date :Date, minusMinutes: Int) -> Date {
        return self.date(date, plusMinutes: -1 * minusMinutes)
    }
    
    public static func date(_ date :Date, plusMinutes: Int) -> Date {
        return date.addingTimeInterval(TimeInterval(60 * plusMinutes))
    }
    
}
