import Foundation

extension String {
    public var sanitizedPath: String {
        var path = self
        if path.hasPrefix("/") {
            path.remove(at: path.firstIndex(of: "/")!)
        }
        return path
    }
}
