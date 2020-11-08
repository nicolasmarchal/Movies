//
//  ImageLoader.swift
//  Movies
//
//  Created by Nicolas Marchal on 07/11/2020.
//

import Foundation
import Combine
import SwiftUI
import Alamofire

class ImageLoader: ObservableObject {
    @Published var image: UIImage = UIImage()
    
    init(url: String) {
        ImageNetWorkManager.shared.loadImage(urlString: url) { image in
            self.image = image
        }
    }
}
