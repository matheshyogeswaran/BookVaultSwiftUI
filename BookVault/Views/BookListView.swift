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
            
            AppBackground {
                
                VStack(spacing: 15) {
                    
                    Text("My Library")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    if vm.books.isEmpty {
                        
                        VStack(spacing: 10) {
                            
                            Image(systemName: "books.vertical")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            
                            Text("No books yet")
                                .foregroundColor(.white)
                            
                            Text("Tap + to add your first book")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 50)
                        
                    } else {
                        
                        ScrollView {
                            
                            VStack(spacing: 15) {
                                
                                ForEach(vm.books) { book in
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        
                                        Text(book.title)
                                            .font(.headline)
                                        
                                        Text(book.author?.name ?? "Unknown Author")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.white)
                                    .cornerRadius(15)
                                }
                            }
                            .padding()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top)
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
