import Foundation

public enum HTTPRequestError: Error {
    case badRequest(String)
    case unauthorized(String)
    case serverError(String)
    case invalidPath(String)
}
