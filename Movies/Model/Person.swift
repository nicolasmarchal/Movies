//
//  Person.swift
//  Movies
//
//  Created by Nicolas Marchal on 06/11/2020.
//

import Foundation


struct Person: Identifiable {
    var id = UUID()
    var name: String
    var role: String
    var image: String = "profile"
}
