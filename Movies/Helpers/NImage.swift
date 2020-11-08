//
//  NImage.swift
//  Movies
//
//  Created by Nicolas Marchal on 07/11/2020.
//

import Foundation
import SwiftUI

struct NImage: View {
    @StateObject var imageLoader:ImageLoader
    
    init(_ url: String) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Image(uiImage: self.imageLoader.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
