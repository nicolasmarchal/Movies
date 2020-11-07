//
//  CarouselView.swift
//  Movies
//
//  Created by Nicolas Marchal on 04/11/2020.
//

import SwiftUI


fileprivate class CardViewProperties {
    var imageSize: CGSize = .zero
    var bottomHeight: CGFloat = 100
    // Percent of the screen (0 to 1)
    var cardWidthPercent: CGFloat = 0.7
    var cardSpacing: CGFloat = 10
    
    var paddingSize: CGFloat = 0
    var realWidth: CGFloat = 0
    var halfWidth: CGFloat = 0
    
    var containerReader: GeometryProxy? = nil {
        didSet {
            if let containerReader = self.containerReader{
                self.paddingSize = containerReader.size.width * (1 - cardWidthPercent)
                self.realWidth = containerReader.size.width - self.paddingSize
                self.halfWidth = containerReader.size.width / 2
                self.imageSize = getSizeOfImage(containerReader: containerReader)
            }
        }
    }
    
    init() {
        
    }
    
    private func getSizeOfImage(containerReader: GeometryProxy) -> CGSize {
        let desiredWidth = self.realWidth
        let desiredHeight = containerReader.size.height - self.bottomHeight
        let newWidth = desiredHeight * 0.67
        if (newWidth > desiredWidth) {
            let newHeight = desiredWidth * 1.47
            if (newHeight <= desiredHeight) {
                return CGSize(width: desiredWidth, height: newHeight)
            }
        } else {
            return CGSize(width: newWidth, height: desiredHeight)
        }
        return CGSize(width: desiredWidth, height: desiredHeight)
    }
}

fileprivate struct CardView: View {
    let movie: Movie
    let cardViewProperties: CardViewProperties
    
    var body: some View {
        GeometryReader { cardGeo in
            VStack(spacing: 0) {
                Spacer()
                Image(movie.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cardViewProperties.imageSize.width, height:  cardViewProperties.imageSize.height)
                    .clipped()
                    .cornerRadius(50)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 20, x: 0, y: 20)
                    .zIndex(0)
                    .opacity(getOpacity(cardGeo: cardGeo))
                    .rotationEffect(Angle(degrees: Double(5 * getRotation(cardGeo: cardGeo))), anchor: .bottom)
                VStack(spacing: 5) {
                    Text(movie.name).font(.appTitle)
                        .foregroundColor(.darkBlue)
                    HStack {
                        Image("star")
                        Text(String.init(movie.ranking)).foregroundColor(.myGray)
                    }
                }.frame(width: cardGeo.size.width, height: cardViewProperties.bottomHeight ,alignment: .center)
                Spacer()
            }
        }.frame(width: cardViewProperties.realWidth)
    }
    
    func getRotation(cardGeo : GeometryProxy) -> Double {
        let diff = (cardGeo.frame(in: .global).midX - cardViewProperties.halfWidth) / 400
        return Double(diff)
    }
    func getOpacity(cardGeo : GeometryProxy) -> Double {
        let diff = (cardGeo.frame(in: .global).midX - cardViewProperties.halfWidth) / 1000
        return Double(1 - abs(diff))
    }
}

struct CarouselView: View {
    var movies: [Movie]
    @Binding var selectedMovie: Movie?
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    @State private var currentItem = 0
    
    private let cardViewProperties: CardViewProperties = CardViewProperties()
    
    private func handleSwipeChange(value: DragGesture.Value) {
        self.offsetX = lastOffsetX + value.translation.width
    }
    
    private func handleSwipeEndend(_ geo : GeometryProxy, _ value: DragGesture.Value) {
        if value.translation.width > 0 && currentItem > 0 { // Swipe -> Right
            currentItem -= 1
        } else if value.translation.width < 0 && currentItem < self.movies.count - 1 {
            currentItem += 1
        }
        self.offsetX = -(cardViewProperties.realWidth + cardViewProperties.cardSpacing) * CGFloat(currentItem)
        self.lastOffsetX = self.offsetX
    }
    
    private func saveGeo(_ geo: GeometryProxy) -> Bool{
        cardViewProperties.containerReader = geo
        return true
    }
    
    var body: some View {
        GeometryReader { geo in
            let _ = saveGeo(geo)
            LazyHStack(spacing: cardViewProperties.cardSpacing) {
                ForEach(movies) { movie in
                    CardView(movie: movie, cardViewProperties: cardViewProperties)
                        .offset(x: offsetX)
                        .onTapGesture(count: 1, perform: {
                            self.selectedMovie = movie
                        })
                        .highPriorityGesture(DragGesture()
                                                .onChanged(handleSwipeChange)
                                                .onEnded({ value in handleSwipeEndend(geo, value)}))
                    
                }
            }.animation(.spring())
            .padding(.horizontal, cardViewProperties.paddingSize / 2)
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView(movies: MockData.movies, selectedMovie: .constant(nil))
    }
}
