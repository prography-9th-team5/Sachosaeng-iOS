//
//  AppleSignInButton.swift
//  Sachosaeng
//
//  Created by LJh on 5/28/24.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    var body: some View {
        
        SignInWithAppleButton(
            .continue,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                    case .success(let authResults):
                        print("apple login success")
                        switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                let userIdentifier = appleIDCredential.user
                                let fullName = appleIDCredential.fullName
                                let name = (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
                                let email = appleIDCredential.email
                                let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                                let authrizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                                print("userIdentifier: \(userIdentifier)")
//                                print("fullName: \(fullName)")
                                print("name: \(name)")
                                print("email: \(String(describing: email))")
                                print("identityToken: \(String(describing: identityToken))")
                                print("authrizationCode: \(String(describing: authrizationCode))")
                            default:
                                break
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                        print("error")
                }
            }
        )
        .frame(width : UIScreen.main.bounds.width * 0.9, height:50)
        .cornerRadius(5)
    }
}
