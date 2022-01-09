//
//  AboutView.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 05.10.2021.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack{
            Animation()
                .frame(width: 150, height: 150)
                .padding()
            
            Spacer()
            
                GroupBox {
                    Group {
                        ExternalLinkView(text: "Text Effect", link: "https://www.freepik.com/free-psd/creative-vanishing-text-effect_16691788.htm", name: "freepik")
                        Divider()
                            .padding(4)
                        ExternalLinkView(text: "Animation", link: "https://vm.tiktok.com/ZSexKat9c", name: "inncoder")
                        Divider()
                            .padding(4)
                        ExternalLinkView(text: "Custom Stack View", link: "https://www.youtube.com/watch?v=LcjI3K78xpI", name: "kavsoft")
                        Divider()
                            .padding(4)
                        ExternalLinkView(text: "Блог Эволюция", link: "https://evo-lutio.livejournal.com/", name: "evo-lutio")
                        Divider()
                            .padding(4)
                    }
                    Group {
                        ExternalLinkView(text: "Calendar", link: "https://gist.github.com/Krishna/54d1774336d242e6de5006207cb95382", name: "Krishna")
                        Divider()
                            .padding(4)
                        ExternalLinkView(text: "WebView", link: "https://github.com/yamin335", name: "Md. Yamin")
                        ExternalLinkView(text: "HTML Parser", link: "https://github.com/scinfu/SwiftSoup", name: "SwiftSoup")
                        Divider()
                            .padding(4)
                    }
                }
                .padding()

            Spacer()
        }
    }
}

struct ExternalLinkView: View {
    var text: String
    var link: String
    var name: String
    var body: some View {
      //  GroupBox {
            HStack {
                Image(systemName: "globe")
                Text(text)
                Spacer()
                Link(name, destination: (URL(string: link))!)
                Group {
                    Image(systemName: "arrow.up.right.square")
                }
                .foregroundColor(.accentColor)
            }
     //   }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
        
        ExternalLinkView(text: "Text Effect", link: "", name: "freepik")
            .previewLayout(.sizeThatFits)
            .padding()
        //                    .preferredColorScheme(.dark)
    }
}
