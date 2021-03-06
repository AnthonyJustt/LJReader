//MenuView.swift
//Created by BLCKBIRDS on 26.10.19.
//Visit www.BLCKBIRDS.com for more.

// https://github.com/BLCKBIRDS/Side-Menu--Hamburger-Menu--in-SwiftUI/

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            NavigationLink(destination: TagsView()) {
                BlurMenuButton(imageName: "tag", buttonName: "MenuView.Tags", paddingNumber: 45)
            }
            
            NavigationLink(destination: ArchiveView()) {
                BlurMenuButton(imageName: "calendar", buttonName: "MenuView.Calendar", paddingNumber: 0)
            }
            
            NavigationLink(destination: SearchView()) {
                BlurMenuButton(imageName: "magnifyingglass", buttonName: "MenuView.Search", paddingNumber: 0)
            }
            Spacer()
            NavigationLink(destination: AboutView()) {
                ZStack {
                    blurView(cornerRadius: 8)
                        .frame(width: 170, height: 50)
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("LJreader")
                                .fontWeight(.semibold)
                            HStack {
                                Text(LocalizedStringKey("MenuView.AppVersion"))
                                Text("1.0")
                            }
                            .font(.caption)
                          //  .fontWeight(.semibold)
                            //   .foregroundColor(.white)
                            .opacity(0.6)
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BlurMenuButton: View {
    
    var imageName: String = "tag"
    var buttonName: String = "Теги"
    var paddingNumber: CGFloat = 150
    
    var body: some View {
        ZStack {
            blurView(cornerRadius: 8)
                .frame(width: 170, height: 50)
                .padding(.top, paddingNumber)
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.gray)
                    .imageScale(.large)
                    .padding()
                Text(LocalizedStringKey(buttonName))
                    .foregroundColor(Color("FontColor"))
                Spacer()
            }
            .padding(.top, paddingNumber)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            //.environment(\.locale, .init(identifier: "ru"))
    }
}
