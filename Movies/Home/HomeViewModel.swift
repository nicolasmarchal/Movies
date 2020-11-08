//
//  HomeViewModel.swift
//  Movies
//
//  Created by Nicolas Marchal on 07/11/2020.
//

import Foundation


class HomeViewModel: ObservableObject {
    
    @Published var moviesDisplayed: [Movie] = [Movie]()
    @Published var selectedFilters = [String]()
    let filters: [String] =  ["Action", "Crime", "Comedy", "Drama", "Horror", "Thriller"]
    private let movieRepository: MovieRepositoryProtocol
    private var nowPlaying: [Movie] = [Movie]()
    private var isComing: [Movie] = [Movie]()
    private var popular: [Movie] = [Movie]()
    
    init(movieRepository: MovieRepositoryProtocol = MovieRepository.shared) {
        self.movieRepository = movieRepository
    }
    
    func fetchMovies() {
        self.movieRepository.getMovieGenres(completion: { _ in
            self.movieRepository.getPlayingNowMovies(completion: { movies in
                self.nowPlaying = movies
                self.moviesDisplayed = self.nowPlaying
            })
        })
    }
    
    func containSameElements(_ firstArray: [String], _ secondArray: [String]) -> Bool {
        firstArray.count == secondArray.count && firstArray.sorted() == secondArray.sorted()
    }
    
    private var previousFilters = [String]()
    
    func filterMovies(_ filters: [String]) {
        if !containSameElements(previousFilters, filters) {
            moviesDisplayed = nowPlaying.filter({ movie in
                return Set(filters).isSubset(of: Set(movie.tags))
            })
            previousFilters = filters
        }
    }
}
