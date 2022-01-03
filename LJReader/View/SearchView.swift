//
//  SearchView.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 03.01.2022.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchString = ""
    
    @State var toggleOpacity: Bool = false
    
    func search() {
        DispatchQueue.global(qos: .userInitiated).async {
            print(searchString)
        }
    }
    func cancel() {
        searchString = ""
    }
    
    var body: some View {
        SearchNavigation(text: $searchString, search: search, cancel: cancel) {
            
            ZStack {
                ScrollView(.vertical, showsIndicators: true) {
                    Text("text")
                        .onTapGesture(perform: {
                        })
                }
            }
        }
        .navigationBarHidden(true)
    }
    
}

struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var search: () -> Void
    var cancel: () -> Void
    var content: () -> Content
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text, searchAction: search, cancelAction: cancel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)
        var search: () -> Void
        var cancel: () -> Void
        
        init(content: Content, searchText: Binding<String>, searchAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController
            
            _text = searchText
            search = searchAction
            cancel = cancelAction
        }
        
        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            search()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
