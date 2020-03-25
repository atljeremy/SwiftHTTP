import Foundation

public struct User: Codable {
    let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension User: PathMappable {
    public var pathValue: String {
        self.id
    }
}

public struct List: Codable {
    let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension List: PathMappable {
    public var pathValue: String {
        self.id
    }
}
