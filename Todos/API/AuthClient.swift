//
//  UserClient.swift
//  Todos
//
//  Created by Kody Deda on 10/26/21.
//

import ComposableArchitecture
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import AuthenticationServices

struct AuthClient {
  let signInAnonymously: () -> Effect<User, APIError>
  let signInEmailPassword: (_ email: String, _ password: String) -> Effect<User, APIError>
  let signInApple: (SignInWithAppleToken) -> Effect<User, APIError>
}

extension AuthClient {
  static let live = AuthClient(
    signInAnonymously: {
      let rv = PassthroughSubject<User, APIError>()
      Auth.auth().signInAnonymously { _, error in
        if let user = Auth.auth().currentUser {
          rv.send(user)
          return
        } else {
          rv.send(completion: .failure(.init(error)))
        }
      }
      return rv.eraseToEffect()
    },
    signInEmailPassword: { email, password in
      let rv = PassthroughSubject<User, APIError>()
      Auth.auth().signIn(withEmail: email, password: password) { _, error in
        if let user = Auth.auth().currentUser {
          rv.send(user)
          return
        } else {
          rv.send(completion: .failure(.init(error)))
        }
      }
      return rv.eraseToEffect()
    },
    signInApple: { token in
      let rv = PassthroughSubject<User, APIError>()
      Auth.auth().signIn(with: OAuthProvider.credential(
        withProviderID: "apple.com",
        idToken: token.appleID.description,
        rawNonce: token.nonce
      )) { _, error in
        if let user = Auth.auth().currentUser {
          rv.send(user)
          return
        } else {
          rv.send(completion: .failure(.init(error)))
        }
      }
      return rv.eraseToEffect()
    }
  )
}
