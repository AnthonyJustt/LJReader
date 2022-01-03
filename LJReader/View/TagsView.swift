//
//  TagsView.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 01.10.2021.
//

import SwiftUI

struct TagsView: View {
    
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    @State var alphabet = [String]()
    @State var values = [String]()
    @State var tagsCount: Int = 0
    
    let concurrentQueue = DispatchQueue(label: "content.loading.tags", attributes: .concurrent)
    
    @State private var isHidden:Bool = false
    @State private var firstLoad: Bool = true
    
    var body: some View {
        ScrollViewReader { value in
            ZStack{
                
                Color("tagsBackground")
                    .ignoresSafeArea()
                    .opacity(isHidden ? 0 : 1)
                
                LoaderView()
                    .opacity(isHidden ? 0 : 1)
                    .onAppear(perform: {
                        if firstLoad == true {
                            let letsgetTags = DispatchWorkItem {
                                print("Task 1 started")
                                let fname = fname(furl: "https://evo-lutio.livejournal.com/tag/")
                                (values, alphabet, tagsCount) = fparseTagsList(fhtml: fname)
                                print("Task 1 finished")
                                withAnimation{
                                    isHidden.toggle()
                                }
                            }
                            
                            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 30) {
                                letsgetTags.cancel()
                                print("tags - cancelled")
                            }

                            concurrentQueue.async(execute: letsgetTags)
                            firstLoad = false
                        }
                    })
                
                List{
                    ForEach(alphabet
                            //                                    .filter{
                            //                            searchBar.text.isEmpty || ($0.lowercased().contains(searchBar.text.lowercased().first!))
                            //                        }
                            , id: \.self) { letter in
                        if letter == alphabet.last {
                            Section(header: Text(letter), footer: HStack {
                                Spacer()
                                Text("\nВсего тегов - \(tagsCount)\n")
                                Spacer()
                            }) {
                                ForEach(values.filter {
                                    $0.hasPrefix(letter)
                                    &&
                                    (searchBar.text.isEmpty || ($0.lowercased().contains(searchBar.text.lowercased())))
                                }, id: \.self) { vals in
                                    NavigationLink(destination: EmptyView()) {
                                        Text(vals).id(vals)
                                    }
                                }
                            }.id(letter)
                        } else {
                            Section(header: Text(letter)) {
                                ForEach(values.filter {
                                    $0.hasPrefix(letter)
                                    &&
                                    (searchBar.text.isEmpty || ($0.lowercased().contains(searchBar.text.lowercased())))
                                }, id: \.self) { vals in
                                    NavigationLink(destination: ContentView(httpsAddress:"https://evo-lutio.livejournal.com/tag/evolutiolab")) {
                                        Text(vals).id(vals)
                                    }
                                }
                            }.id(letter)
                        }
                    }
                }
                .opacity(isHidden ? 1 : 0)
                .addSearchBar(self.searchBar)
                
                HStack{
                    Spacer()
                    VStack {
                        ForEach(0..<alphabet.count, id: \.self) { idx in
                            Button(action: {
                                withAnimation {
                                    value.scrollTo(alphabet[idx])
                                }
                            }, label: {
                                Text(alphabet[idx])
                            })
                        }
                    }
                }
                .opacity(isHidden ? 1 : 0)
                .padding(2)
            }
        }
        .navigationTitle("Теги")
        //  .navigationBarBackButtonHidden(true)
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView()
    }
}
