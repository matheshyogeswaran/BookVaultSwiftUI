//
//  AddBookView.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 06/05/2026.
//
import SwiftUI

struct AddBookView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: LibraryViewModel
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var year = ""
    
    var body: some View {
        NavigationView {
            AppBackground {
                VStack {
                    Text("Add New Book")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    VStack(spacing: 15) {
                        Group {
                            TextField("Book Title", text: $title)
                            TextField("Author Name", text: $author)
                            TextField("Genre", text: $genre)
                            TextField("Published Year", text: $year)
                                .keyboardType(.numberPad)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                       
                        if !vm.statusMessage.isEmpty {
                            Text(vm.statusMessage)
                                .font(.caption)
                                .foregroundColor(vm.statusMessage.contains("Success") ? .green : .red) // Turn green for success!
                        }
                        
                        Button {
                            Task {
                                await vm.addBook(
                                    title: title,
                                    author: author,
                                    genre: genre,
                                    year: year
                                )
                                
                                if vm.statusMessage.contains("Success") {
                                    dismiss()
                                }
                            }
                        } label: {
                            Text("Save Book")
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
                        .disabled(title.isEmpty || author.isEmpty || genre.isEmpty || year.isEmpty)
                        .opacity((title.isEmpty || author.isEmpty || genre.isEmpty || year.isEmpty) ? 0.5 : 1)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationBarHidden(true)
            .onAppear {
                vm.statusMessage = ""
            }
        }
    }
}
