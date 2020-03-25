import Foundation

public typealias HeaderKey = String

public enum ApiVersionFormat {
    case path(ApiVersion)
    case header(HeaderKey, ApiVersion)
}

public enum ApiVersion: String {
    case v1_0 = "v1.0"
    case v1_1 = "v1.1"
    case v1_2 = "v1.2"
    case v2_0 = "v2.0"
}
