import Foundation

public protocol HTTPRequestProtocol {
    associatedtype ResponseObject: Codable
    var path: Path { get }
    var method: HTTPMethod { get }
    var query: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Codable? { get }
    var versionFormat: ApiVersionFormat? { get }
    init(method: HTTPMethod, path: Path, versionFormat: ApiVersionFormat?, query: [URLQueryItem]?, headers: [String: String]?, body: Codable?)
    func execute(completion: (Result<ResponseObject, HTTPRequestError>) -> Void) -> Void
}
