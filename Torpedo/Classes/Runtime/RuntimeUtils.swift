import Foundation

open class RuntimeUtils {
    
    open static func instance(of clz: AnyClass) -> AnyObject {
        let tt = clz as! NSObject.Type
        return tt.init()
    }
    
    open static func classesConforming(toProtocol aProtocol: Protocol) -> [AnyClass] {
        var result: [AnyClass] = []
        let allClasses = self.allClasses()
        for cls in allClasses {
            if class_conformsToProtocol(cls, aProtocol) {
                result.append(cls)
            }
        }
        return result
    }
    
    open static func allClasses() -> [AnyClass] {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
        let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            if let currentClass: AnyClass = allClasses[Int(i)] {
                classes.append(currentClass)
            }
        }
        
        allClasses.deallocate(capacity: Int(expectedClassCount))
        
        return classes
    }
    
}
