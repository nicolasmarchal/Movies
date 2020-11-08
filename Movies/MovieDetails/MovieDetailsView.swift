//
//  MovieDetails.swift
//  Movies
//
//  Created by Nicolas Marchal on 06/11/2020.
//

import SwiftUI

fileprivate class HeaderProperties {

    var blur: CGFloat = 0
    var radius: CGFloat = 0
    var geometryProxy: GeometryProxy? = nil {
        didSet {
            if let proxy = self.geometryProxy {
                let percent = getPercentoffset(proxy)
                self.radius = 50 * (1 - percent)
                self.blur = percent * 6
            }
        }
    }
    
    var barSize: CGFloat
    
    init(barSize: CGFloat) {
        self.barSize = barSize
    }
    
    private func getPercentoffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY - barSize
        let height = geometry.size.height - barSize
        let percent = (height - max(offset, 0)) / height
        if percent < 0 {
            return 0
        }
        return percent
    }
}

fileprivate struct HeaderView: View {
    @Environment(\.presentationMode) var presentation
    
    let parentReader: GeometryProxy
    let movie: Movie
    var headerProperties: HeaderProperties

    init(parentReader: GeometryProxy, movie: Movie, barSize: CGFloat) {
        self.parentReader = parentReader
        self.movie = movie
        self.headerProperties = HeaderProperties(barSize: barSize)
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = geometry.size.height - headerProperties.barSize
        if offset < -sizeOffScreen {
            let imageOffset = abs(min(-sizeOffScreen, offset))
            return imageOffset - sizeOffScreen
        }
        
        if offset > 0 {
            return -offset
        }
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    var body: some View {
        GeometryReader { reader in
            let _ = headerProperties.geometryProxy = reader
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                NImage(movie.image)
                    .aspectRatio(contentMode: .fill)
                    .frame(height: getHeightForHeaderImage(reader), alignment: .center)
                    .blur(radius: headerProperties.blur)
                    .overlay(Color(red: 0, green: 0, blue: 0, opacity: 0.1), alignment: .center)
                    .clipped()
                    .background(Color.black)
                    .cornerRadius(headerProperties.radius, corners: [.bottomLeft])
                    .offset(x: 0, y: self.getOffsetForHeaderImage(reader))
            }
        }.frame(width: parentReader.size.width, height: parentReader.size.height * 0.35)
    }
}

fileprivate struct TitleBarView: View {
    let movie: Movie
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.name).font(.appTitle).foregroundColor(.darkBlue)
                    HStack {
                        Text("2019").font(.appBody).foregroundColor(.myGray)
                        Spacer()
                        Text("PG-13").font(.appBody).foregroundColor(.myGray)
                        Spacer()
                        Text("2h14min").font(.appBody).foregroundColor(.myGray)
                        Spacer()
                        Spacer()
                    }
                }
                Spacer()
                Image("plus")
                    .frame(width: 64, height: 64)
                    .background(Color.myPink.cornerRadius(20))
                    .onClick { }
            }
            TagsView(tags: movie.tags)
        }
    }
}


fileprivate struct TagsView: View {
    let tags: [String]
    
    var body: some View {
        HStack {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.appBodyMedium)
                    .foregroundColor(.myPurple)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(RoundedRectangle(cornerRadius: 50)
                                    .strokeBorder(Color.myGray, lineWidth: 1.5))
            }
        }
    }
}

fileprivate struct PlotSummaryView: View {
    let movie: Movie
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview").font(.appSubTitle)
                .foregroundColor(.darkBlue)
            Text(movie.summary).font(.body)
                .foregroundColor(.lightPurple)
        }
    }
}

fileprivate struct CastCrewView: View {
    let cast: [Person]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cast & Crew").font(.appSubTitle)
                .foregroundColor(.darkBlue)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 28) {
                    ForEach(cast) { person in
                        VStack(spacing: 0) {
                            NImage(person.image)
                                .frame(width: 80, height: 80, alignment: .center)
                                .clipShape(Circle())
                    
                            Text(person.name)
                                .font(.appBodyMedium)
                                .foregroundColor(.darkBlue)
                                .multilineTextAlignment(.center).padding(.top, 12)
                            Text(person.role)
                                .font(.appBodyMedium)
                                .foregroundColor(.myGray)
                                .multilineTextAlignment(.center).padding(.top, 4)
                        }.frame(width: 90)
                    }
                }.padding(.trailing, 20)
            }
        }
    }
}


struct HeaderBarView: View {
    @Environment(\.presentationMode) var presentation
    var barSize: CGFloat
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            HStack {
                Image("left-arrow")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .frame(width: 32, height: 32)
                    .background(Color(red: 1, green: 1, blue: 1, opacity: 0.8))
                    .cornerRadius(10)
                    .padding()
                    .onClick {
                        presentation.wrappedValue.dismiss()
                    }
                Spacer()
            }
            Spacer()
        }.frame(height: barSize)
    }
}


struct MovieDetailsView: View {
    
    @ObservedObject var viewModel: MovieDetailsViewModel
    private let barSize: CGFloat = 100
    
    init(movie: Movie) {
        self.viewModel = MovieDetailsViewModel(movie: movie)
        self.viewModel.fetchCredit()
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                HeaderBarView(barSize: barSize).zIndex(2)
                
                ScrollView(.vertical, showsIndicators: false) {
                    HeaderView(parentReader: reader, movie: viewModel.movie, barSize: barSize)
                        .zIndex(1)
                    VStack(alignment: .leading, spacing: 48) {
                        TitleBarView(movie: viewModel.movie).padding(.horizontal, 20)
                        PlotSummaryView(movie: viewModel.movie).padding(.horizontal, 20)
                        CastCrewView(cast: viewModel.credits.cast).padding(.leading, 20)
                        
                    }
                    .padding(.top, 24)
                    Spacer(minLength: reader.size.height * 0.1)
                }
            }
        }.background(Color.white)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: MockData.movie1)
    }
}
