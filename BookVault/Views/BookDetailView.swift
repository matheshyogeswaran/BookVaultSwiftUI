//
//  BookDetailView.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 14/05/2026.
//
import SwiftUI

struct BookDetailView: View {
    @ObservedObject var vm: LibraryViewModel
    let book: Book
    
    @State private var showEditSheet = false
    
    var body: some View {
        AppBackground {
            VStack(spacing: 20) {
                                  
               
                
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(label: "Genre", value: book.genre?.name ?? "N/A")
                    DetailRow(label: "Published", value: book.publishedYear != nil ? "\(book.publishedYear!)" : "Unknown")
                    DetailRow(label: "Database ID", value: book._id)
                }
                .padding()
                .background(.white.opacity(0.9))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        // Add the Edit button to the top right of the Detail View
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditSheet = true
                }
            }
        }
        // Present the EditBookView as a sheet
        .sheet(isPresented: $showEditSheet) {
            EditBookView(vm: vm, book: book)
        }
    }
}


struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .bold()
                .foregroundColor(.black)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}
