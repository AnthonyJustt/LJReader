//
//  Home.swift
//  Home
//
//  Created by Anton Krivonozhenkov on 07.09.2021.
//

import SwiftUI

struct Home: View {
    
    @State private var isShowingDetailView = false
    
    var FeedArray: [FeedListItem]
    
    let pasteboard = UIPasteboard.general
    
    @State var offset: CGFloat = 0
    var topEdge: CGFloat
    
    //    var formattedText: AttributedString {
    //        var thankYouString = AttributedString()
    //
    //        do {
    //            thankYouString = try AttributedString(
    //                markdown:"**Thank you!** Please visit our [website](https://example.com)")
    //            print(thankYouString)
    //        } catch {
    //            print("Couldn't parse: \(error)")
    //        }
    //
    //        return thankYouString
    //    }
    
    var body: some View {
        ZStack {
//            GeometryReader { proxy in
//                
//                Image("background")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: proxy.size.width, height: proxy.size.height)
//                
//            }
//            .ignoresSafeArea()
            //                .overlay(.ultraThinMaterial)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack(alignment: .center, spacing: 5) {
                        Text("EVO-LUTIO")
                            .font(.system(size: 35))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        Text("Эволюция")
                            .font(.system(size: 25))
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        Text("LJreader")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                        Text(" ")
                            .foregroundStyle(.primary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpacity())
                    }
                    .offset(y: -offset)
                    .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
                    .offset(y: getTitleOffset())
                    
                    ForEach(FeedArray) { item in
                        
                        NavigationLink(destination: ArticleView(StringURL: item.link)) {
                            VStack(spacing: 8) {
                                CustomStackView {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color.teal)
                                        Text(item.date)
                                        Spacer()
                                            Image(systemName: "bubble.right")
                                                .foregroundColor(Color.indigo)
                                            Text(item.comments)
                                            .padding(.trailing, 14)
                                        NavigationLink(destination: Text("Комментрии"), isActive: $isShowingDetailView) { EmptyView() }
                                    }
                                    .onTapGesture{
                                        isShowingDetailView = true
                                    }
                                    .foregroundColor(Color("FontColor"))
                                } contentView: {
                                    VStack {
                                        HStack {
                                            if item.rate != "–" {
                                                Text(" ")
                                                Text(item.rate)
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                        }
                                        Text(item.title)
                                            .bold()
                                            .padding()
                                        if item.tags.count > 6 {
                                            Text(item.tags.markdownToAttributed())
                                                .environment(\.openURL, OpenURLAction { url in
                                                    print(url.absoluteString.removingPercentEncoding!)
                                                    return .handled
                                                    
                                                })
                                                .padding(.bottom, 6)
                                        }
                                        
                                        
                                    }
                                    
                                    .foregroundColor(Color("FontColor"))
                                }
                            }
                            
                            .previewContextMenu(preview: ArticlePreview(htmlBody: item.article_snippet), actions: {[
                                PreviewContextAction(
                                    title: "Скопировать ссылку",
                                    systemImage: "doc.on.doc",
                                    action: {
                                        print("Скопировать ссылку")
                                        pasteboard.string = item.link
                                    }),
                                PreviewContextAction(
                                    title: "Открыть в браузере",
                                    systemImage: "safari",
                                    action: {
                                        print("Открыть в браузере")
                                        UIApplication.shared.open(URL(string: item.link)!)
                                    })]})
                            
                        }
                        
                    }
                }
                .padding(.top, 25)
                .padding(.top, topEdge)
                .padding([.horizontal, .bottom])
                .overlay(
                    
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        
                        DispatchQueue.main.async {
                            self.offset = minY
                        }
                        
                        return Color.clear
                        
                        
                    }
                    
                )
            }
        }
    }
    
    func getTitleOpacity() -> CGFloat {
        let titleOffset = -getTitleOffset()
        let progress = titleOffset / 20
        let opacity = 1 - progress
        return opacity
    }
    
    func getTitleOffset() -> CGFloat {
        if offset < 0 {
            let progress = -offset / 120
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            return -newOffset
        }
        return 0
    }
    
}

// https://stackoverflow.com/questions/56892691
extension String {
    func markdownToAttributed() -> AttributedString {
        do {
            return try AttributedString(markdown: self)
        } catch {
            return AttributedString("Error parsing markdown: \(error)")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
