//
//  LibraryViewModel.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 06/05/2026.
//

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    
    @Published var books: [Book] = []
    @Published var isLoggedIn = false
    @Published var token: String = ""
    @Published var errorMessage: String = ""
    @Published var showStatusAlert = false
    @Published var statusMessage = ""
    @Published var username: String = ""
    
    // Use your Mac's IP if 127.0.0.1 fails
    let apiBase = "http://127.0.0.1:3000/api"
    
    init() {
            // Check if a token exists on disk when the app starts
            if let savedToken = UserDefaults.standard.string(forKey: "user_token"),
               let savedUsername = UserDefaults.standard.string(forKey: "user_name") {
                self.token = savedToken
                self.username = savedUsername
                self.isLoggedIn = true // This triggers the immediate jump to BookListView
                
                // Refresh data in the background
                Task {
                    await fetchBooks()
                }
            }
        }
    
    func logout() {
            self.isLoggedIn = false
            self.token = ""
            self.username = ""
            self.books = []
            
            UserDefaults.standard.removeObject(forKey: "user_token")
            UserDefaults.standard.removeObject(forKey: "user_name")
        }
    
    struct LoginResponse: Codable {
        let accessToken: String
        let username: String
    }

    @MainActor
    func authenticate(user: String, pass: String, isSignup: Bool) async {
        let path = isSignup ? "/auth/register" : "/auth/login"
        guard let url = URL(string: "\(apiBase)\(path)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": user, "password": pass]
        request.httpBody = try? JSONEncoder().encode(body)

        do {
                    let (data, response) = try await URLSession.shared.data(for: request)
                    if let httpResponse = response as? HTTPURLResponse, (200...201).contains(httpResponse.statusCode) {
                        let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                        
                        // Save to RAM
                        self.token = decoded.accessToken
                        self.username = decoded.username
                        self.isLoggedIn = true
                        
                        // SAVE TO DISK (Persistence)
                        UserDefaults.standard.set(decoded.accessToken, forKey: "user_token")
                        UserDefaults.standard.set(decoded.username, forKey: "user_name")
                        
                        await fetchBooks()
                    }
        } catch {
            self.errorMessage = "Network Error: \(error.localizedDescription)"
            print("Auth Error: \(error)")
        }
    }

    @MainActor
    func fetchBooks() async {
        guard let url = URL(string: "\(apiBase)/books") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            self.books = try JSONDecoder().decode([Book].self, from: data)
        } catch {
            print("Fetch Error: \(error)")
        }
    }
    
    
    struct CreateBookRequest: Codable {
        let title: String
        let authorName: String
        let genreName: String
        let publishedYear: Int
    }
    
    @MainActor
    func addBook(title: String, author: String, genre: String, year: String) async {
        guard let url = URL(string: "\(apiBase)/books") else { return }
        
        // Convert year string to Int safely
        let yearInt = Int(year) ?? 0
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the data object matching your JSON requirement
        let newBookData = CreateBookRequest(
            title: title,
            authorName: author,
            genreName: genre,
            publishedYear: yearInt
        )

        do {
            request.httpBody = try JSONEncoder().encode(newBookData)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                
                if (200...201).contains(httpResponse.statusCode) {
                    self.statusMessage = "Success! Book added."
                    await fetchBooks() // Refresh the list
                } else {
                    // Read the server's error message if possible
                    let errorReason = String(data: data, encoding: .utf8) ?? "Unknown Error"
                    self.statusMessage = "Failed (400): \(errorReason)"
                    print("Server Error Detail: \(errorReason)")
                }
            }
        } catch {
            self.statusMessage = "Network Error: \(error.localizedDescription)"
        }
        
        self.showStatusAlert = true
    }
}


