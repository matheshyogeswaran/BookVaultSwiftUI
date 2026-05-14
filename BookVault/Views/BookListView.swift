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
    @State private var selectedBook: Book?

    var body: some View {
        NavigationView {
            AppBackground {
                VStack(spacing: 0) {
                    
                    Text("My Library")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding()

                    if vm.books.isEmpty {
                        emptyStateView
                    } else {
                     
                        List {
                            ForEach(vm.books) { book in
                                // NavigationLink makes the row clickable
                                NavigationLink(destination: BookDetailView(vm: vm, book: book)) {
                                    VStack(alignment: .leading) {
                                        Text(book.title)
                                            .font(.headline)
                                        Text(book.author?.name ?? "Unknown")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 4)
                                }
                                    .swipeActions(edge: .trailing) {
                                        // DELETE BUTTON
                                        Button(role: .destructive) {
                                            Task {
                                                if let index = vm.books.firstIndex(where: { $0.id == book.id }) {
                                                    await vm.deleteBook(at: IndexSet(integer: index))
                                                }
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        
                                        // EDIT BUTTON
                                        Button {
                                            selectedBook = book
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.orange)
                                    }
                            }
                            .listRowBackground(Color.white.opacity(0.9)) // Clean look on background
                        }
                        .listStyle(.insetGrouped) // Modern iOS look
                        .scrollContentBackground(.hidden) // Makes AppBackground visible through the list
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddBook = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
            // MODAL FOR ADDING
            .sheet(isPresented: $showAddBook) {
                AddBookView(vm: vm)
            }
            // MODAL FOR EDITING (Triggers when selectedBook is set)
            .sheet(item: $selectedBook) { book in
                EditBookView(vm: vm, book: book)
            }
            .onAppear {
                Task { await vm.fetchBooks() }
            }
        }
    }

    // Helper for a cleaner row UI
    private func bookRow(_ book: Book) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(book.title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(book.author?.name ?? "Unknown Author")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }

    // Helper for Empty State
    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "books.vertical")
                .font(.system(size: 50))
                .foregroundColor(.white)
            Text("No books yet").foregroundColor(.white)
            Text("Tap + to add your first book")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
    }
}
