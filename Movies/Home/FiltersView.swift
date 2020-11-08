//
//  FiltersView.swift
//  Movies
//
//  Created by Nicolas Marchal on 04/11/2020.
//

import SwiftUI
import Combine

fileprivate class Filter: Identifiable, ObservableObject {
    var id = UUID()
    var name: String = ""
    var isSelected: Bool = false
    
    init(name: String? = nil) {
        self.name = name ?? ""
    }
}

fileprivate struct FilterItemView: View {
    var filter: Filter
    @Binding var selectedFilter: [Filter]
    
    
    private func filterIsSelected() -> Bool {
        return (selectedFilter.first(where: { f in
            filter.name == f.name
        }) != nil)
    }
    
    private func updateSelected() {
        let isSelected = filterIsSelected()
        if (isSelected) {
            selectedFilter.removeAll(where: { f in
                filter.name == f.name
            })
            
        } else {
            selectedFilter.append(filter)
        }
    }
    
    
    private func getBackground(isSelected: Bool) -> AnyView {
        if (isSelected) {
            return AnyView( Color.myPink.cornerRadius(50) )
        } else {
            return AnyView (RoundedRectangle.init(cornerRadius: 50)
                                .strokeBorder(Color.myGray, lineWidth: 1.5))
        }
    }
    
    var body: some View {
        let isSelected = filterIsSelected()
        Text(filter.name)
            .foregroundColor(isSelected ? .white : .myPurple)
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
            .background(getBackground(isSelected: isSelected))
            .onClick {
                updateSelected()
            }
    }
}


struct FiltersView: View {
    @State private var filters: [Filter]
    @State private var selectedFilter = [Filter]()
    
    var filterSelected: ([String]) -> Void
//    @Binding var selectedFilterString: [String]
    
    init(filters: [String], filterSelected: @escaping ([String]) -> Void) {
        self._filters = State(initialValue: filters.map({ Filter(name: $0)}))
        self.filterSelected = filterSelected
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(self.filters) { filter in
                    FilterItemView(filter: filter, selectedFilter: $selectedFilter)
                }
            }.padding(.horizontal, 40)
        }.onReceive(Just(selectedFilter), perform: { value in
            self.filterSelected(selectedFilter.map({ $0.name }))
//            selectedFilterString = selectedFilter.map({ $0.name })
        })
    }
}

struct FiltersView_Previews: PreviewProvider {
    @State private var selectedFilter = []
    static var previews: some View {
        FiltersView(filters: ["toto", "tutu", "tata", "tete", "contenue"], filterSelected: { filters in
            
        })
    }
}
