//
//  EditBookView.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 14/05/2026.
//
import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: LibraryViewModel
    
    let book: Book
    
    @State private var title: String
    @State private var author: String
    @State private var genre: String
    @State private var year: String
    
    init(vm: LibraryViewModel, book: Book) {
        self.vm = vm
        self.book = book
        
        // --- DYNAMIC INITIALIZATION FROM API DATA ---
        _title = State(initialValue: book.title)
        _author = State(initialValue: book.author?.name ?? "")
        _genre = State(initialValue: book.genre?.name ?? "")
        
        // Convert the Int? from API to String for the TextField
        if let yearValue = book.publishedYear {
            _year = State(initialValue: String(yearValue))
        } else {
            _year = State(initialValue: "")
        }
    }
    
    var body: some View {
        NavigationView {
            AppBackground {
                VStack {
                    Text("Edit Book")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    VStack(spacing: 15) {
                        Group {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Title").font(.caption).foregroundColor(.gray)
                                TextField("Book Title", text: $title)
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Author").font(.caption).foregroundColor(.gray)
                                TextField("Author Name", text: $author)
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Genre").font(.caption).foregroundColor(.gray)
                                TextField("Genre", text: $genre)
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Year").font(.caption).foregroundColor(.gray)
                                TextField("Published Year", text: $year)
                                    .keyboardType(.numberPad)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        Button {
                            Task {
                                await vm.updateBook(
                                    id: book._id,
                                    title: title,
                                    author: author,
                                    genre: genre,
                                    year: year
                                )
                                dismiss()
                            }
                        } label: {
                            Text("Update Changes")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(title.isEmpty || author.isEmpty)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
