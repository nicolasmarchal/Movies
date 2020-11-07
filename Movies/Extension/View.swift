//
//  View.swift
//  Movies
//
//  Created by Nicolas Marchal on 04/11/2020.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func onClick(_ onClick: @escaping () -> Void) -> some View {
        Button(action: {
            onClick()
        }, label: {
            self
        })
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    public func navigate<Item, Content>(item: Binding<Item?>, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                if let value = item.wrappedValue {
                    NavigationLink(
                        destination: content(value),
                        isActive: .constant(true)) {
                        EmptyView()
                    }
                }
            }
        }
    }
}
