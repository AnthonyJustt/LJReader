//
//  ArticleView.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 28.09.2021.
//

import SwiftUI
import WebKit

struct ArticleView: View {
    var StringURL: String = ""
    
    //    @State private var RequestedString: String = "ghbdtn"
    //    let concurrentQueue = DispatchQueue(label: "content.loading.data", attributes: .concurrent)
    //    @State private var isHidden:Bool = false
    //    @State private var firstLoad: Bool = true
    
    @ObservedObject var viewModel = ViewModel()
    @State var showLoader = false
    
    var body: some View {
        ZStack {
            VStack {
                WebView(url: .parsedURL, StringURL: StringURL, viewModel: viewModel)
                    .opacity(showLoader ? 0 : 1)
            }
            .overlay(
                Button(action: {
                    
                }) {
                    Menu {
                        Button(action: {
                        }) {
                            Label("Комментарии", systemImage: "bubble.right")
                        }
                        Button(action: {
                            
                        }) {
                            Label("Теги", systemImage: "tag")
                        }
                        Button(action: {
                            
                        }) {
                            Label("Категории", systemImage: "tray.full")
                        }
                    } label: {
                        ZStack {
                            blurView(cornerRadius: 25)
                                .frame(width: 50, height: 50)
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color("FontColor"))
                        }
                    }
                }
                    .shadow(radius: 3)
                    .padding(.bottom, 25)
                    .padding(.trailing, 25)
                    .onTapGesture {
                        
                    }
                , alignment: .bottomTrailing
            )
            .edgesIgnoringSafeArea(Edge.Set.bottom)
            .navigationTitle("Статья")
            .navigationBarTitleDisplayMode(.inline)
            //            .navigationBarItems(trailing:
            //                                    Button(action: {
            //                self.viewModel.webViewNavigationPublisher.send(.reload)
            //            }) {
            //                Image(systemName: "arrow.clockwise")
            //            })
            
            .onReceive(
                self.viewModel.showLoader.receive(on: RunLoop.main)) { value in
                    self.showLoader = value
                }
            
            if showLoader {
                LoaderView()
                    .onAppear(perform: {
                        //                    if firstLoad == true {
                        //                        let workItemFeed = DispatchWorkItem {
                        //                            print("Task 1 started")
                        //                            RequestedString = fparseArticle(fhtml: fname(furl: StringURL))
                        //                            print("Task 1 finished")
                        //                            withAnimation{
                        //                                isHidden.toggle()
                        //                            }
                        //                        }
                        //
                        //                        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 30) {
                        //                            workItemFeed.cancel()
                        //                            print("feed - cancelled")
                        //                        }
                        //
                        //                        //     concurrentQueue.async(execute: workItemFeed)
                        //                        firstLoad = false
                        //                    }
                    })
            }
        }
    }
}

struct WebView_ : UIViewRepresentable {
    let request: String
    var webview: WKWebView = WKWebView()
    //    let requestURL: URLRequest
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView_
        
        init(_ parent: WebView_) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // turning web page dark by inverting colors for dark mode
            let css = "@media (prefers-color-scheme: dark) { html{ filter: invert(1)  hue-rotate(.5turn); } img { filter: invert(1)  hue-rotate(.5turn); } }"
            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
            webView.evaluateJavaScript(js, completionHandler: nil)
            // end of turning
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        DispatchQueue.main.async {
            webview.navigationDelegate = context.coordinator
            webview.loadHTMLString(request, baseURL: nil)
        }
        
        webview.isOpaque = false // для темной темы, чтобы задний фон не был белым
        webview.backgroundColor = UIColor.clear  // для темной темы, чтобы задний фон не был белым
        return webview
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //        uiView.load(requestURL)
    }
}

struct blurView: UIViewRepresentable {
    var cornerRadius: CGFloat = 0
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .light)
        uiView.effect = blurEffect
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView()
    }
}
