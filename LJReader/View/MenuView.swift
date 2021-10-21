//MenuView.swift
//Created by BLCKBIRDS on 26.10.19.
//Visit www.BLCKBIRDS.com for more.

// https://github.com/BLCKBIRDS/Side-Menu--Hamburger-Menu--in-SwiftUI/

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            NavigationLink(destination: TagsView()) {
                BlurMenuButton(imageName: "tag", buttonName: "Теги", paddingNumber: 45)
            }
            
            NavigationLink(destination: ArchiveView()) {
                BlurMenuButton(imageName: "calendar", buttonName: "Календарь", paddingNumber: 0)
            }
            
            NavigationLink(destination: EmptyView()) {
                BlurMenuButton(imageName: "magnifyingglass", buttonName: "Поиск", paddingNumber: 0)
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
                            Text("App Version 1.0")
                                .font(.caption)
                                .fontWeight(.semibold)
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

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
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
                Text(buttonName)
                    .foregroundColor(Color("FontColor"))
                Spacer()
            }
            .padding(.top, paddingNumber)
        }
    }
}
