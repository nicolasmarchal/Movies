//
//  ImageNetWorkManager.swift
//  Movies
//
//  Created by Nicolas Marchal on 08/11/2020.
//

import UIKit
import Alamofire
import AlamofireImage

class ImageNetWorkManager {
    static  let shared = ImageNetWorkManager()
    private init () {}
    let imageCache = AutoPurgingImageCache()
    
    
    func loadImage(urlString: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        if let image = self.imageCache.image(for: urlRequest) {
            completion(image)
        } else {
            AF.request(url)
                .validate()
                .responseImage(completionHandler: { response in
                    guard let data = response.data else { return }
                    if let image = UIImage(data: data) {
                        self.imageCache.add(image, for: urlRequest)
                        completion(image)
                    }
                })
        }
    }
}
