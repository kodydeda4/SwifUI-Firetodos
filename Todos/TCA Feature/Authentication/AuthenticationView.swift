//
//  AuthenticationView.swift
//  Todos
//
//  Created by Kody Deda on 6/2/21.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationServices

struct AuthenticationView: View {
  let store: Store<AuthenticationState, AuthenticationAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        LoginView(store: store)
          .opacity(viewStore.state.route == .login ? 1 : 0)
        
        SignupView(store: store)
          .opacity(viewStore.state.route == .signup ? 1 : 0)
      }
    }
  }
}

struct Authentication_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView(store: .default)
  }
}

