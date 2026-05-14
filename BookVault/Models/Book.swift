//
//  Book.swift
//  BookVault
//
//  Created by Mathesh Yogeswaran on 06/05/2026.
//

import Foundation

struct Book: Identifiable, Codable {
    let _id: String
    var title: String
    let author: AuthorDetails?
    let genre: GenreDetails?
    let publishedYear: Int?
    // Identifiable requires 'id', but MongoDB uses '_id'
    var id: String { _id }
}

struct AuthorDetails: Codable {
    let _id: String?
    let name: String?
}

struct GenreDetails: Codable {
    let _id: String?
    let name: String?
}

struct LoginResponse: Codable {
    let accessToken: String
    let username: String
}
