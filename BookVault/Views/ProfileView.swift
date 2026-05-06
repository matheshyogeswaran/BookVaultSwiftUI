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
        NavigationView {
            List {
                Section(header: Text("Account Information")) {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(vm.username).foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button(action: {
                        vm.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Log Out")
                                .foregroundColor(.red)
                                .bold()
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("About Vault")) {
                    Text("This is a secure personal library. Your books are encrypted and tied to your unique account ID.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Profile")
        }
    }
}
