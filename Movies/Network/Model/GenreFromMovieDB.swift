//
//  GenreFromMovieDB.swift
//  Movies
//
//  Created by Nicolas Marchal on 08/11/2020.
//

import Foundation

// MARK: - GenreFromMovieDBResponse
struct GenreFromMovieDBResponse: Codable {
    let genres: [GenreFromMovieDB]
}

// MARK: - Genre
struct GenreFromMovieDB: Codable {
    let id: Int
    let name: String
}
