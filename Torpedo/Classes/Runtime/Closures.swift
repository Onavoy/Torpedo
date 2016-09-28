import Foundation

@inline(never) public func measureBlock(_ block: @escaping (() -> Void)) -> Double {
    let begin = Date()
    block()
    let end = Date()
    let timeTaken = end.timeIntervalSince1970 - begin.timeIntervalSince1970
    return timeTaken
}


@inline(never) public func measureBlockAverage(repeatCount: Int, _ block: @escaping (() -> Void)) -> Double {
    var results :[Double] = []
    repeatCount.times { (currentIndex) in
        results.append(measureBlock(block))
    }
    return DoubleUtils.average(results)
}

@discardableResult
@inline(never) public func measureBlockLog(_ closureName: String, _ block: @escaping (() -> Void)) -> Double {
    let timeTaken = measureBlock(block)
    if timeTaken < 1.0 {
        let millsecondsTaken = timeTaken * 1000.0
        print("\(closureName) took \(millsecondsTaken) milliseconds to execute")
    } else {
        print("\(closureName) took \(timeTaken) seconds to execute")
    }
    return timeTaken
}


