//
//  Movie.swift
//  Movies
//
//  Created by Nicolas Marchal on 04/11/2020.
//

import Foundation

struct Movie: Identifiable {
    var id: Int = 0
    var name: String
    var image: String
    var ranking: Float
    var tags: [String] = [String]()
    var summary: String
    var credits: Credits = Credits()
    
}

struct Credits: Identifiable {
    var id: Int = 0
    var cast: [Person] = [Person]()
    var crew: [Person] = [Person]()
}
