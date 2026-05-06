//
//  ContentView.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 05/05/2026.
//


import SwiftUI

struct ContentView: View {
    @StateObject var vm = LibraryViewModel()

    var body: some View {
        Group {
            if vm.isLoggedIn {
                TabView {
                    // TAB 1: The Book List
                    BookListView(vm: vm)
                        .tabItem {
                            Label("Vault", systemImage: "lock.shield")
                        }

                    // TAB 2: The Profile
                    ProfileView(vm: vm)
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle")
                        }
                }
            } else {
                AuthView(vm: vm)
            }
        }
    }
}

#Preview {
    ContentView()
}
