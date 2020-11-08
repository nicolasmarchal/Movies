//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Nicolas Marchal on 08/11/2020.
//

import Foundation


class MovieDetailsViewModel: ObservableObject {
    let movie: Movie
    @Published var credits = Credits()
    
    private let movieRepository: MovieRepositoryProtocol = MovieRepository.shared
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    
    func fetchCredit() {
        movieRepository.getMovieCredits(idMovie: movie.id, completion: { credit in
            self.credits = credit
        })
    }
}
