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
    @State private var year: String
    
    init(vm: LibraryViewModel, book: Book) {
        self.vm = vm
        self.book = book
        
        _title = State(initialValue: book.title)
        
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
                    
                    VStack(spacing: 20) {
                        // EDITABLE FIELDS
                        Group {
                            fieldLabel("Book Title")
                            TextField("Enter title", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            fieldLabel("Published Year")
                            TextField("Enter year", text: $year)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }

                        Divider()

                        // READ-ONLY FIELDS (From API)
                        Group {
                            readOnlyField(label: "Author", value: book.author?.name ?? "Unknown")
                            readOnlyField(label: "Genre", value: book.genre?.name ?? "General")
                        }
                        
                        Button {
                            Task {
                                // We still send the existing author/genre names to the API
                                await vm.updateBook(
                                    id: book._id,
                                    title: title,
                                    author: book.author?.name ?? "",
                                    genre: book.genre?.name ?? "",
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
                        .disabled(title.isEmpty)
                        .padding(.top, 10)
                    }
                    .padding(25)
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

    // Helper for labels
    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption.bold())
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Helper for read-only display
    private func readOnlyField(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.caption.bold()).foregroundColor(.gray)
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}
