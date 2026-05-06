//
//  AuthView.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 06/05/2026.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var vm: LibraryViewModel
    @State private var username = ""
    @State private var password = ""
    @State private var isSignup = false

    var body: some View {
        VStack(spacing: 20) {
            Text(isSignup ? "Create Account" : "Welcome Back")
                .font(.largeTitle).bold()
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            if !vm.errorMessage.isEmpty {
                Text(vm.errorMessage).foregroundColor(.red).font(.caption)
            }

            Button(action: {
                // Dismiss keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                Task {
                    await vm.authenticate(user: username, pass: password, isSignup: isSignup)
                }
            }) {
                Text(isSignup ? "Sign Up" : "Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(isSignup ? "Already have an account? Login" : "New here? Create account") {
                isSignup.toggle()
            }
        }
        .padding()
    }
}
