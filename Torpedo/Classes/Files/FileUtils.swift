import Foundation

public class FileUtils {

    class func files(at path: String, withExtension fileExtension: String? = nil) throws -> [String] {
        let content = try FileManager.default.contentsOfDirectory(atPath: path)
        if let exten = fileExtension {
            return content.filter({ (aFile) -> Bool in
                let nsFile = aFile as NSString
                return nsFile.pathExtension == exten
            })
        }
        return content
    }

}
