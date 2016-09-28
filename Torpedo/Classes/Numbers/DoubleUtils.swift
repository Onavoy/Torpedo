import Foundation

public class DoubleUtils {
    
    public static func average(_ doubles: [Double]) -> Double {
        return sum(doubles) / Double(doubles.count)
    }
    
    public static func sum(_ doubles: [Double]) -> Double {
        var total : Double = 0.0
        for num in doubles {
            total += num
        }
        return total
    }
    
}
