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
        
        AppBackground {
            
            VStack {
                
                Spacer()
                
                // MARK: Title
                VStack(spacing: 8) {
                    
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    
                    Text(isSignup ? "Create Account" : "Welcome Back")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text(isSignup ? "Join and build your library" : "Login to continue")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 30)
                
                // MARK: Card
                VStack(spacing: 15) {
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    if !vm.errorMessage.isEmpty {
                        Text(vm.errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                        
                        Task {
                            await vm.authenticate(
                                user: username,
                                pass: password,
                                isSignup: isSignup
                            )
                        }
                    } label: {
                        Text(isSignup ? "Create Account" : "Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    
                    Button {
                        isSignup.toggle()
                    } label: {
                        Text(isSignup
                             ? "Already have an account? Login"
                             : "New here? Create account")
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
