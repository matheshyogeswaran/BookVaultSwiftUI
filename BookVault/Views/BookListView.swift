//
//  BookListView.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 06/05/2026.
//

import SwiftUI

struct BookListView: View {
    @ObservedObject var vm: LibraryViewModel
    @State private var showAddBook = false

    var body: some View {
        NavigationView {
            List(vm.books) { book in
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author?.name ?? "Unknown Author")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("My Library")
            .toolbar {
               
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddBook = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAddBook) {
                AddBookView(vm: vm)
            }
            .onAppear {
                Task {
                    await vm.fetchBooks()
                }
            }
        }
    }
}
