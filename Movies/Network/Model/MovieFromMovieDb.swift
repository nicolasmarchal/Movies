//
//  NowPlayingMovieDb.swift
//  Movies
//
//  Created by Nicolas Marchal on 07/11/2020.
//

import Foundation


struct MovieDBResponse: Decodable {
    let results: [MovieFromMovieDb]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct MovieFromMovieDb: Decodable {
    let popularity: Float
    let voteCount: Int
    let video: Bool
    let posterPath: String
    let id: Int
    let adult: Bool
    let backdropPath, originalLanguage, originalTitle: String
    let genreIDS: [Int]
    let title: String
    let voteAverage: Float
    let overview, releaseDate: String

    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id, adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
}

