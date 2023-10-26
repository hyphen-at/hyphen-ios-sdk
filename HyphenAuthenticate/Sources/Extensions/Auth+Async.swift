import FirebaseAuth

// MARK: - Support signIn Function async - await

public extension Auth {
    func signIn(with credential: AuthCredential) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            self.signIn(with: credential) { result, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: result!)
                }
            }
        }
    }
}
