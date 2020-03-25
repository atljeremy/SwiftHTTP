import Foundation

public enum Path {
    case only(String)
    case mapped(String, [PathTypeMap])
    
    public var pathString: String {
        switch self {
        case .only(let path):
            return path
        case .mapped(let keyedPath, _):
            return keyedPath
        }
    }
    
    public var pathTypeMaps: [PathTypeMap]? {
        switch self {
        case .only(_):
            return nil
        case .mapped(_, let types):
            return types
        }
    }
}

public enum PathTypeMap {
    case expect(String, Codable.Type)
}

public protocol PathMappable {
    var pathValue: String { get }
}

public struct Service {
    @GET<[User]>(
        path: .only("/users"),
        version: .path(.v1_1)
    )
    public var users: HTTPRequest

    @GET<User>(
        path: .mapped("/users/{user}", [.expect("user", User.self)]),
        version: .path(.v1_2)
    )
    public var user: HTTPRequest

    @GET<List>(
        path: .mapped("/users/{user}/lists/{list}", [.expect("user", User.self), .expect("list", List.self)]),
        version: .path(.v1_2)
    )
    public var userList: HTTPRequest
    
    public init() {}
}
