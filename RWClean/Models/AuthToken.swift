import Foundation

// MARK: - AuthToken

public protocol AuthToken {
    func authenticationHeaders() -> [String: String]
}

extension AuthToken {
    public func setAuthenticationHeaders(on request: inout URLRequest) {
        let headers = authenticationHeaders()
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
