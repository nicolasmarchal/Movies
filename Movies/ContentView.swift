//
//  ContentView.swift
//  Movies
//
//  Created by Nicolas Marchal on 03/11/2020.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var selectedTab: String = ""
    @State private var selectedFilters = [String]()
    @State private var selectedMovie: Movie? = nil
    
    var body: some View {
        VStack {
            HStack {
                Image("menu")
                    .onClick {
                        
                    }
                Spacer()
                Image("search")
                    .onClick {
                        
                    }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            TopBarView2(titles: ["In Theater", "Box office", "Coming soon"], selectedTitle: $selectedTab)
                .padding(.top, 6)
            FiltersView(filters: viewModel.filters, filterSelected: { filters in
                viewModel.filterMovies(filters)
            })
            .padding(.vertical, 12)
            .zIndex(1)
            CarouselView(movies: viewModel.moviesDisplayed, selectedMovie: $selectedMovie)
            Spacer()
        }.background(Color.white)
        //Bug 06.11.2020: https://stackoverflow.com/questions/58720495/why-isnt-onpreferencechange-being-called-if-its-inside-a-scrollview-in-swiftui?noredirect=1&lq=1
        .navigate(item: $selectedMovie, content: { selectedMovie in
            MovieDetailsView(movie: selectedMovie).onDisappear {
                self.selectedMovie = nil
            }
        }).background(viewModel.moviesDisplayed.count > 0 ? NImage(viewModel.moviesDisplayed[0].image).opacity(0.3) : NImage("").opacity(0))
        .onAppear {
            viewModel.fetchMovies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
