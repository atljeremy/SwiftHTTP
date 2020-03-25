import Foundation

public class HTTPRequest<T: Codable>: HTTPRequestProtocol {

    public typealias ResponseObject = T
    
    public let path: Path
    public var method: HTTPMethod
    public var query: [URLQueryItem]?
    public var headers: [String: String]?
    public var body: Codable?
    public var pathObjects: [PathMappable]?
    public var versionFormat: ApiVersionFormat?
    
    public required init(method: HTTPMethod, path: Path, versionFormat: ApiVersionFormat? = nil, query: [URLQueryItem]? = nil, headers: [String: String]? = nil, body: Codable? = nil) {
        self.method = method
        self.path = path
        self.versionFormat = versionFormat
        self.query = query
        self.headers = headers
        self.body = body
    }
    
    public func execute(completion: (Result<ResponseObject, HTTPRequestError>) -> Void) {
        var path = ""
        var headers: [String: String] = self.headers ?? [:]
        
        // Check to see there's a versionFormat and if so, apply to path or headers accordingly
        switch versionFormat {
        case .path(let version):
            path = "/\(version.rawValue)/\(self.path.pathString.sanitizedPath)"
        case .header(let key, let version):
            path = self.path.pathString.sanitizedPath
            headers[key] = version.rawValue
        default:
            path = self.path.pathString.sanitizedPath
        }
        
        var pathParts = path.split(separator: "/")
        
        // After path has been finalized, replace path variables with actual values
        if let expectedPathTypes = self.path.pathTypeMaps, let pathObjects = pathObjects {
            for t in expectedPathTypes {
                switch t {
                case .expect(let pathKey, let pathType):
                    for obj in pathObjects {
                        guard type(of: obj) == pathType.self else { continue }
                        pathParts = pathParts.map { self.mapped(part: $0, pathKey: pathKey, pathObj: obj) }
                    }
                }
            }
        }
        
        path = pathParts.joined(separator: "/")
        
        do {
            try valid(path: path)
        } catch {
            completion(.failure(.invalidPath(path)))
        }
        
        // Append any query params to the path
        if let query = query {
            path.append(query.reduce(into: "") { (result, item) in
                guard let value = item.value else { return }
                if result.count > 0 {
                    result.append("&")
                }
                result.append("\(item.name)=\(value)")
            })
        }
        
        // TODO: Serialize and add body to request
        if let body = body {
            print("body: \(body)")
        }
        
        print("path: \(path)")
        print("headers: \(headers)")
        
        do {
            let data = "{\"id\":\"123\"}".data(using: .utf8)!
            let value = try JSONDecoder().decode(ResponseObject.self, from: data)
            completion(.success(value))
        } catch {
            completion(.failure(.serverError("Error: \(error.localizedDescription)")))
        }
    }
    
    public func `for`(_ pathObject: PathMappable) -> HTTPRequest {
        self.pathObjects = [pathObject]
        return self
    }
    
    public func with(_ pathObjects: [PathMappable]) -> HTTPRequest {
        self.pathObjects = pathObjects
        return self
    }
    
    @discardableResult
    private func valid(path: String) throws -> Bool {
        guard !path.contains("{"), !path.contains("}") else {
            throw HTTPRequestError.invalidPath(path)
        }
        
        return true
    }
    
    private func mapped(part: Substring, pathKey: String, pathObj: PathMappable, charSet: CharacterSet = CharacterSet.alphanumerics.inverted) -> Substring {
        let partChars = CharacterSet(charactersIn: String(part))
        let replacementCharsFound = !partChars.intersection(charSet).isEmpty
        guard replacementCharsFound else { return part }
        let key = part.trimmingCharacters(in: charSet)
        guard key.lowercased() == pathKey.lowercased() else { return part }
        return Substring(pathObj.pathValue)
    }
}
