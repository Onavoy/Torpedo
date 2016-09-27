import Foundation

@discardableResult
@inline(never) public func measureBlock(_ closureName: String, _ block: @escaping (() -> Void)) -> Double {
    let begin = Date()
    
    block()
    
    let end = Date()
    
    let timeTaken = end.timeIntervalSince1970 - begin.timeIntervalSince1970
    
    if timeTaken < 1.0 {
        let millsecondsTaken = timeTaken * 1000.0
        print("\(closureName) took \(millsecondsTaken) milliseconds to execute")
    } else {
        print("\(closureName) took \(timeTaken) seconds to execute")
    }
    return timeTaken
}
