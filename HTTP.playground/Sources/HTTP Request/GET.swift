import Foundation

@propertyWrapper
public struct GET<Expected: Codable> {
    var versionFormat: ApiVersionFormat?
    var path: Path
    var headers: [String: String]?
    public var wrappedValue: HTTPRequest<Expected> {
        return HTTPRequest<Expected>(method: .get, path: path, versionFormat: versionFormat, headers: headers)
    }

    public init(path: Path, version: ApiVersionFormat? = nil, headers: [String: String]? = nil) {
        self.versionFormat = version
        self.path = path
        self.headers = headers
    }
}
