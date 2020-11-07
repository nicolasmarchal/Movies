//
//  TabBarView.swift
//  Movies
//
//  Created by Nicolas Marchal on 04/11/2020.
//

import SwiftUI
import Combine

fileprivate struct SelectedTab {
    let index: Int
    let position: CGRect
}

fileprivate struct TabView: View {
    var index: Int
    var title: String
    let coordinateSpace: String
    
    @Binding var selectedTab: SelectedTab
    @State var position: CGRect = .zero
    
    var body: some View  {
        Text(title)
            .font(.appTitle)
            .foregroundColor(selectedTab.index == index ? .darkBlue : .myGray)
            .background(GeometryHelper.GeometryGetter(coordinateSpace: .named(coordinateSpace), rect: $position))
            .onTapGesture(count: 1, perform: {
                selectedTab = SelectedTab(index: self.index, position: self.position)
            })
            .animation(.default)
    }
}

fileprivate struct TabsView2: View {
    private let coordinateSpace = "tabBarStack"
    var spacing: CGFloat
    var titles: [String]
    @Binding var selectedTab: SelectedTab
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(titles.indices, id: \.self) { index in
                TabView(index: index, title: titles[index], coordinateSpace: coordinateSpace, selectedTab: $selectedTab)
            }
        }
        .coordinateSpace(name: coordinateSpace)
    }
}

fileprivate struct IndicatorView: View {
    let width: CGFloat
    let height: CGFloat
    var selectedTab: SelectedTab
    
    var body: some View {
        GeometryReader { reader in
            Color.myPink.frame(width: width, height: height)
                .cornerRadius(100)
                .offset(x: selectedTab.position.origin.x)
                .animation(.default)
        }.frame(height: height)
    }
}

struct TopBarView2: View {
    var titles: [String]
    @Binding var selectedTabName: String
    
    private let spacing: CGFloat = 40
    @State private var selectedTab: SelectedTab = SelectedTab(index: 0, position: .zero)
    
    init(titles: [String], selectedTitle: Binding<String>) {
        self.titles = titles
        self._selectedTabName = selectedTitle
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { reader in
                VStack(alignment: .leading, spacing: 16) {
                    TabsView2(spacing: spacing, titles: titles, selectedTab: $selectedTab)
                        .onReceive(Just(selectedTab), perform: { _ in
                            withAnimation {
                                reader.scrollTo(selectedTab.index, anchor: .center)
                            }
                        })
                }
                IndicatorView(width: spacing, height: 6, selectedTab: selectedTab)
            }.padding(.horizontal, spacing)
        }
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopBarView2(titles: ["In Theater", "Box office", "Coming soon"], selectedTitle: .constant(""))
    }
}
