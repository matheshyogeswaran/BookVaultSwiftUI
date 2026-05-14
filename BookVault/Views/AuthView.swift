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
    @State private var validationError = "" 

    // Logic: Password must be at least 6 characters
    var isPasswordValid: Bool {
        password.count >= 6
    }

    var body: some View {
        AppBackground {
            VStack {
                Spacer()
                
                // MARK: Title (Keep existing)
                VStack(spacing: 8) {
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    
                    Text(isSignup ? "Create Account" : "Welcome Back")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                }
                .padding(.bottom, 30)
                
                // MARK: Card
                VStack(spacing: 15) {
                    // Username Field (Keep existing)
                    HStack {
                        Image(systemName: "person.fill").foregroundColor(.gray)
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock.fill").foregroundColor(.gray)
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                    // VALIDATION ERROR DISPLAY
                    if isSignup && !password.isEmpty && !isPasswordValid {
                        Text("Password must be at least 6 characters")
                            .font(.caption)
                            .foregroundColor(.orange) // Use orange for "warning"
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // SERVER ERROR DISPLAY
                    if !vm.errorMessage.isEmpty {
                        Text(vm.errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        // Dismiss Keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        // Check validation only for Signup
                        if isSignup && !isPasswordValid {
                            vm.errorMessage = "Please fix the errors above."
                        } else {
                            Task {
                                await vm.authenticate(
                                    user: username,
                                    pass: password,
                                    isSignup: isSignup
                                )
                            }
                        }
                    } label: {
                        Text(isSignup ? "Create Account" : "Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                // Grey out the button if signup password is invalid
                                (isSignup && !isPasswordValid) ?
                                LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing) :
                                LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    // Disable button if fields are empty
                    .disabled(username.isEmpty || password.isEmpty)
                    
                    Button {
                        isSignup.toggle()
                        vm.errorMessage = "" // Clear errors when switching
                    } label: {
                        Text(isSignup ? "Already have an account? Login" : "New here? Create account")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}
