import FirebaseAuth

public extension User {
    func getIdToken() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            self.getIDToken { token, error in
                if let token {
                    continuation.resume(returning: token)
                } else if let error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
