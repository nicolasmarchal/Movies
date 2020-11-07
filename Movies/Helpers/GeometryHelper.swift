//
//  GeometryHelper.swift
//  Movies
//
//  Created by Nicolas Marchal on 05/11/2020.
//

import Foundation
import SwiftUI

class GeometryHelper {
    
    struct GeometryGetter: View {
        var coordinateSpace: CoordinateSpace = .global
        @Binding var rect: CGRect
        var body: some View {
            GeometryReader { geometry in
                AnyView(Color.clear)
                    .preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: coordinateSpace))
            }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
                let _ = print("geo: \(value.origin)")
                self.rect = value
            }
        }
    }
    
    fileprivate struct RectanglePreferenceKey: PreferenceKey {
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }
}
