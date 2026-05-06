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
            Form {
                Section(header: Text("Book Details")) {
                    TextField("Book Title", text: $title)
                    TextField("Author Name", text: $author)
                    TextField("Genre (e.g. Fantasy)", text: $genre)
                    TextField("Published Year", text: $year)
                        .keyboardType(.numberPad) // Ensures numeric input
                }
                
                Button(action: {
                    Task {
                        await vm.addBook(title: title, author: author, genre: genre, year: year)
                    }
                }) {
                    Text("Save Book").bold().frame(maxWidth: .infinity)
                }
                .disabled(title.isEmpty || author.isEmpty || genre.isEmpty || year.isEmpty)
            }
            .navigationTitle("Add New Book")
            .alert(isPresented: $vm.showStatusAlert) {
                Alert(
                    title: Text("Status"),
                    message: Text(vm.statusMessage),
                    dismissButton: .default(Text("OK")) {
                        if vm.statusMessage.contains("Success") { dismiss() }
                    }
                )
            }
        }
    }
}
