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
                
                // MARK: - Book Header Display
                VStack(spacing: 12) {
                    ZCornerIconCard {
                        Image(systemName: "book.closed.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 25)
                    
                    Text(book.title)
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                }
                .padding(.bottom, 10)
                
                // MARK: - Information Card Grid
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(label: "Genre", value: book.genre?.name ?? "N/A")
                    
                    Divider()
                    
                    DetailRow(label: "Published", value: book.publishedYear != nil ? "\(book.publishedYear!)" : "Unknown")
                    
                    Divider()
                    
                    DetailRow(label: "Database ID", value: book._id)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditSheet = true
                }
                .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditBookView(vm: vm, book: book)
        }
    }
}

// MARK: - Reusable Info Row
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

// MARK: - Background Accent Layout Helper
fileprivate struct ZCornerIconCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background(
                LinearGradient(
                    colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}
