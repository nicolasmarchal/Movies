//
//  MoviesDbApiManager.swift
//  Movies
//
//  Created by Nicolas Marchal on 07/11/2020.
//

import Foundation
import Alamofire


class MoviesDbApiManager {
    
    static let shared = MoviesDbApiManager()
    
    private let baseUrl = "https://api.themoviedb.org/3"
    private let apiKey = "913c9c7a9c4341e511697672d8dc7e2c"
    
    init() {
        
    }
    
    private func doGetRequest<T: Decodable>(url: String, of: T.Type, completion: @escaping (T) -> Void) {
        let parameter: Parameters = ["api_key": apiKey]
        AF.request(baseUrl + url, parameters: parameter)
            .validate()
            .responseDecodable(of: of) { (response) in
                print(response)
                guard let object = response.value else { return }
                completion(object)
            }
    }
    
    
    func fetchNowPlayingMovies(completion: @escaping ([MovieFromMovieDb]) -> Void) {
        let url = "/movie/now_playing"
        doGetRequest(url: url, of: MovieDBResponse.self) { result in
            completion(result.results)
        }
    }
    
    func fetchGenres(completion: @escaping ([GenreFromMovieDB]) -> Void){
        let url = "/genre/movie/list"
        doGetRequest(url: url, of: GenreFromMovieDBResponse.self) { result in
            completion(result.genres)
        }
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (MovieDetailsFromMovieDB) -> Void) {
        let url = "/movie/\(id)"
        doGetRequest(url: url, of: MovieDetailsFromMovieDB.self, completion: completion)
    }
    
    func fetchCredits(idMovie: Int, completion: @escaping (CreditsFromMovieDB) -> Void) {
        let url = "/movie/\(idMovie)/credits"
        doGetRequest(url: url, of: CreditsFromMovieDB.self, completion: completion)
    }
}
