import Foundation
import AuthenticationServices
import FirebaseAuth
import CommonCrypto

enum FirebaseAuthenticationNotification: String {
    case signOutSuccess
    case signOutError
    case signInSuccess
    case signInError

    var notificationName: NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}

class FirebaseAuthentication: NSObject {
    static let shared = FirebaseAuthentication()

    var window: UIWindow?
    fileprivate var currentNonce: String?

    private override init() {}

    func signInWithApple(window: UIWindow) {
      self.window = window
      let nonce = randomNonceString()
        currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    func signInWithAnonymous() {
        Auth.auth().signInAnonymously() { [weak self] (authResult, error) in
            if error != nil {
                self?.postNotificationSignInError()
                return
            }
            self?.postNotificationSignInSuccess()
        }
    }

    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            postNotificationSignOutSuccess()
        } catch let error {
            postNotificationSignOutError()
        }
    }
}

extension FirebaseAuthentication: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if (error != nil) {
                self?.postNotificationSignInError()
            return
          }
            self?.postNotificationSignInSuccess()
        }
      }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
    }
}

extension FirebaseAuthentication: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window ?? UIWindow()
    }
}

extension FirebaseAuthentication {
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if length == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = hashSHA256(data: inputData)
      let hashString = hashedData!.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }

    private func hashSHA256(data:Data) -> Data? {
        var hashData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

        _ = hashData.withUnsafeMutableBytes {digestBytes in
            data.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(data.count), digestBytes)
            }
        }
        return hashData
    }

    private func postNotificationSignInSuccess() {
        NotificationCenter.default.post(name: FirebaseAuthenticationNotification.signInSuccess.notificationName, object: nil)
    }

    private func postNotificationSignInError() {
        NotificationCenter.default.post(name: FirebaseAuthenticationNotification.signInError.notificationName, object: nil)
    }

    private func postNotificationSignOutSuccess() {
        NotificationCenter.default.post(name: FirebaseAuthenticationNotification.signOutSuccess.notificationName, object: nil)
    }

    private func postNotificationSignOutError() {
        NotificationCenter.default.post(name: FirebaseAuthenticationNotification.signOutError.notificationName, object: nil)
    }
}

extension FirebaseAuthentication {
    public func checkUserExists() -> Bool {
        if Auth.auth().currentUser == nil { return false }
        else { return true }
    }
    
    func getUserEmail() -> String {
        if let user = Auth.auth().currentUser,
           let email = user.email {
            return email
        }
        else { return "can't get user email" }
    }
}
