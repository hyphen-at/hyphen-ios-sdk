import FirebaseAuth

public extension User {
    func getIdToken() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            self.getIDToken { token, error in
                if let token = token {
                    continuation.resume(returning: token)
                } else if let error = error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
