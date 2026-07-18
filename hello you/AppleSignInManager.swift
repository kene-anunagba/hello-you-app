//
//  AppleSignInManager.swift
//  hello you
//
//  Runs the native Sign in with Apple flow, exchanges the resulting
//  identity token with Supabase, and reads/writes the "profiles" row for
//  the signed-in user.
//

import AuthenticationServices
import CryptoKit
import Supabase
import UIKit

/// A row in the "profiles" table. See the SQL in the project notes for
/// the table definition and its row-level security policies.
struct Profile: Codable, Equatable {
    let id: UUID
    var displayName: String
    var avatarStyle: String

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case avatarStyle = "avatar_style"
    }
}

enum AppleSignInError: LocalizedError {
    case invalidCredential
    case missingIdentityToken

    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Apple didn't return a usable credential."
        case .missingIdentityToken:
            return "Apple didn't return an identity token."
        }
    }
}

@MainActor
final class AppleSignInManager {
    static let shared = AppleSignInManager()

    private let coordinator = AppleSignInPresentationCoordinator()

    private init() {}

    /// Runs Sign in with Apple, exchanges the identity token with Supabase,
    /// and looks up any existing profile for the resulting user.
    func signIn() async throws -> (userID: UUID, profile: Profile?) {
        let rawNonce = Self.randomNonceString()
        let hashedNonce = Self.sha256(rawNonce)

        let appleCredential = try await coordinator.performRequest(hashedNonce: hashedNonce)
        guard let identityTokenData = appleCredential.identityToken,
              let idToken = String(data: identityTokenData, encoding: .utf8)
        else {
            throw AppleSignInError.missingIdentityToken
        }

        let session = try await SupabaseManager.shared.client.auth.signInWithIdToken(
            credentials: OpenIDConnectCredentials(provider: .apple, idToken: idToken, nonce: rawNonce)
        )

        let profile = try await fetchProfile(id: session.user.id)
        return (session.user.id, profile)
    }

    #if DEBUG
    /// Dev-only stand-in for Sign in with Apple: Supabase anonymous auth,
    /// so the rest of the flow (name entry, avatar picker, profile save,
    /// routing) can be exercised before Apple Developer enrollment clears.
    /// Requires "Allow anonymous sign-ins" enabled in the Supabase project.
    func signInAnonymously() async throws -> (userID: UUID, profile: Profile?) {
        let session = try await SupabaseManager.shared.client.auth.signInAnonymously()
        let profile = try await fetchProfile(id: session.user.id)
        return (session.user.id, profile)
    }
    #endif

    func fetchProfile(id: UUID) async throws -> Profile? {
        let rows: [Profile] = try await SupabaseManager.shared.client
            .from("profiles")
            .select()
            .eq("id", value: id)
            .execute()
            .value
        return rows.first
    }

    func saveProfile(id: UUID, displayName: String, avatarStyle: String) async throws {
        let profile = Profile(id: id, displayName: displayName, avatarStyle: avatarStyle)
        try await SupabaseManager.shared.client
            .from("profiles")
            .upsert(profile)
            .execute()
    }

    // MARK: - Nonce

    private static func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            var randoms = [UInt8](repeating: 0, count: 16)
            let status = SecRandomCopyBytes(kSecRandomDefault, randoms.count, &randoms)
            precondition(status == errSecSuccess, "Unable to generate nonce.")

            for random in randoms where remainingLength > 0 {
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    private static func sha256(_ input: String) -> String {
        SHA256.hash(data: Data(input.utf8))
            .compactMap { String(format: "%02x", $0) }
            .joined()
    }
}

/// Bridges ASAuthorizationController's delegate-based API to async/await.
private final class AppleSignInPresentationCoordinator: NSObject,
    ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
{
    private var continuation: CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?

    func performRequest(hashedNonce: String) async throws -> ASAuthorizationAppleIDCredential {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.nonce = hashedNonce

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        defer { continuation = nil }
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            continuation?.resume(returning: credential)
        } else {
            continuation?.resume(throwing: AppleSignInError.invalidCredential)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
