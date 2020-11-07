//
//  Movie.swift
//  Movies
//
//  Created by Nicolas Marchal on 04/11/2020.
//

import Foundation

struct Movie: Identifiable {
    var id = UUID()
    var name: String
    var image: String
    var ranking: Float
    var tags: [String] = [String]()
    var summary: String
    var cast: [Person] = [Person]()
}
