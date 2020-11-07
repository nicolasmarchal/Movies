//
//  MovieRepository.swift
//  Movies
//
//  Created by Nicolas Marchal on 07/11/2020.
//

import Foundation


protocol MovieRepositoryProtocol {
    func getPlayingNowMovies()
}

class MovieRepository: MovieRepositoryProtocol {
    
    static let shared = MovieRepository()
    
    func getPlayingNowMovies() {
        
    }
}
