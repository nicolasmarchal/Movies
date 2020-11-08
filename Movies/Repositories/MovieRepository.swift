//
//  MovieRepository.swift
//  Movies
//
//  Created by Nicolas Marchal on 07/11/2020.
//

import Foundation

protocol MovieRepositoryProtocol {
    func getPlayingNowMovies(completion: @escaping ([Movie]) -> Void)
    func getMovieGenres(completion: @escaping ([String]) -> Void)
    func getMovieDetails(id: Int, completion: @escaping (Movie) -> Void)
    func getMovieCredits(idMovie: Int, completion: @escaping (Credits) -> Void)
}

class MovieRepository: MovieRepositoryProtocol {
    
    
    static let shared = MovieRepository()
    
    private let networkMovieRepository: MovieRepositoryProtocol
    
    
    private init(networkMovieRepository: MovieRepositoryProtocol = NetworkMovieRepository.shared) {
        self.networkMovieRepository = networkMovieRepository
    }
    
    func getPlayingNowMovies(completion: @escaping ([Movie]) -> Void) {
        networkMovieRepository.getPlayingNowMovies(completion: completion)
    }
    
    func getMovieGenres(completion: @escaping ([String]) -> Void) {
        networkMovieRepository.getMovieGenres(completion: completion)
    }
    
    func getMovieDetails(id: Int, completion: @escaping (Movie) -> Void) {
        
    }
    func getMovieCredits(idMovie: Int, completion: @escaping (Credits) -> Void) {
        networkMovieRepository.getMovieCredits(idMovie: idMovie, completion: completion)
    }
}


class NetworkMovieRepository: MovieRepositoryProtocol {
    
    static let shared = NetworkMovieRepository()
    
    private let movieDbApiManager: MoviesDbApiManager
    
    private var genres: [GenreFromMovieDB] = [GenreFromMovieDB]()
    
    init(movieDbApiManager: MoviesDbApiManager = MoviesDbApiManager.shared) {
        self.movieDbApiManager = movieDbApiManager
    }
    
    func getPlayingNowMovies(completion: @escaping ([Movie]) -> Void ) {
        movieDbApiManager.fetchNowPlayingMovies(completion: { movies in
            let dtoMovies = movies.map({ movie in
                Movie(
                    id: movie.id,
                    name: movie.title,
                    image: "https://image.tmdb.org/t/p/w500" + movie.posterPath,
                    ranking: movie.voteAverage,
                    tags: movie.genreIDS.map({ genre in
                        self.genres.first(where: { $0.id == genre})?.name ?? ""
                    }),
                    summary: movie.overview
                )
            })
            completion(dtoMovies)
        })
    }
    
    func getMovieGenres(completion: @escaping ([String]) -> Void) {
        movieDbApiManager.fetchGenres(completion: { genres in
            self.genres = genres
            completion(genres.map({ $0.name}))
        })
    }
    
    func getMovieDetails(id: Int, completion: @escaping (Movie) -> Void) {
        movieDbApiManager.fetchMovieDetails(id: id, completion: { response in
            
        })
    }
    
    func getMovieCredits(idMovie: Int, completion: @escaping (Credits) -> Void) {
        movieDbApiManager.fetchCredits(idMovie: idMovie, completion: { response in
            let cast: [Person] = response.cast.map({ cast in
                Person(
                    id: cast.id,
                    name: cast.name,
                    role: cast.character,
                    image: (cast.profilePath != nil) ? "https://image.tmdb.org/t/p/w500\(cast.profilePath!)" : ""
                )
            })
            let crew: [Person] = response.crew.map({ crew in
                Person(
                    id: crew.id,
                    name: crew.name,
                    role: crew.job,
                    image: (crew.profilePath != nil) ? "https://image.tmdb.org/t/p/w500\(crew.profilePath!)" : ""
                )
            })
            completion(Credits(id: response.id, cast: cast, crew: crew))
        })
    }
    
}
