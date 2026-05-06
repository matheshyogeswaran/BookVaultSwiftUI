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
                // Now we point to the real list view
                BookListView(vm: vm)
            } else {
                AuthView(vm: vm)
            }
        }
    }
}

#Preview {
    ContentView()
}
