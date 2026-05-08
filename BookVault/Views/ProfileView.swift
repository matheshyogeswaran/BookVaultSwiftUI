//
//  ProfileView.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 06/05/2026.
//
import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var vm: LibraryViewModel
    
    var body: some View {
        
        AppBackground {
            
            VStack(spacing: 20) {
                
                Text("Profile")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(vm.username)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(15)
                    
                    Button {
                        vm.logout()
                    } label: {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About Vault")
                            .font(.headline)
                        
                        Text("Your books are securely stored and linked to your account.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(15)
                }
                .padding()
                .background(.white.opacity(0.9))
                .cornerRadius(25)
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}
