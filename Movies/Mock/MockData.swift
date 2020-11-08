//
//  MockData.swift
//  Movies
//
//  Created by Nicolas Marchal on 04/11/2020.
//

import Foundation


class MockData {
    
    static let movie1 = Movie(name: "Ford v Ferrari", image: "ford", ranking: 8.2, tags: ["action", "biography", "drama"], summary: "American car designer Carroll Shelby and driver Kn Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order. American car designer Carroll Shelby and driver Kn Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order. American car designer Carroll Shelby and driver Kn Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order. American car designer Carroll Shelby and driver Kn Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order.")
    static let movie2 = Movie(name: "Inception", image: "inception", ranking: 8.8, tags: ["action", "biography", "drama"], summary: "American car designer Carroll Shelby and driver Kn Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order.")
    static let movie3 = Movie(name: "Pulp Fiction", image: "pulp", ranking: 8.9, tags: ["action", "biography", "drama"], summary: "American car designer Carroll Shelby and driver Kn Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order.")
    static let movie4 = Movie(name: "The Matrix", image: "matrix", ranking: 8.7, tags: ["action", "biography", "drama"], summary: "American car designer Carroll Shelby and driver Kn Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order.")

    static let person1 = Person(name: "James Mangold", role: "Director")
    static let person2 = Person(name: "Matt Damon", role: "Carroll")
    static let person3 = Person(name: "Christian Bale", role: "Ken Miles")
    static let person4 = Person(name: "Caitriona Balfe", role: "Mollie")
    static let person5 = Person(name: "Christopher Nolan", role: "Director")
    static let person6 = Person(name: "Leonardo Dicaprio", role: "main")

    
    static let movies = [movie1, movie2, movie3, movie4]

}
