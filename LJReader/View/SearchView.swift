//
//  SearchView.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 03.01.2022.
//

import SwiftUI

struct SearchView: View {
    var planets = ["", ""]
    
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    var body: some View {
        List {
            ForEach(
                planets.filter {
                    searchBar.text.isEmpty ||
                    $0.localizedStandardContains(searchBar.text)
                },
                id: \.self
            ) { eachPlanet in
                Text(eachPlanet)
            }
        }
        .navigationBarTitle("Planets")
        .addSearchBar(searchBar)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
