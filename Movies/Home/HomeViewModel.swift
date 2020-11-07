//
//  HomeViewModel.swift
//  Movies
//
//  Created by Nicolas Marchal on 07/11/2020.
//

import Foundation


class HomeViewModel: ObservableObject {
    
    private let movieRepository: MovieRepositoryProtocol
    
    @Published var nowPlaying: [Movie] = [Movie]()
    @Published var isComing: [Movie] = [Movie]()
    @Published var popular: [Movie] = [Movie]()
    
    init(movieRepository: MovieRepositoryProtocol = MovieRepository.shared) {
        self.movieRepository = movieRepository
    }
    
    func fetchMovies() {
        self.nowPlaying = MockData.movies
    }

}
