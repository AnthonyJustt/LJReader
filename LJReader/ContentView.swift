//
//  ContentView.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 27.09.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var FeedArray = [FeedListItem]()
    @State private var FeedString: String = ""
    var httpsAddress: String = "https://evo-lutio.livejournal.com/"
    let concurrentQueue = DispatchQueue(label: "content.loading.data", attributes: .concurrent)
    // @State private var workItemFeed: DispatchWorkItem = DispatchWorkItem { }
    
    @State private var isHidden:Bool = false
    
    @State private var firstLoad: Bool = true
    
    @State var showMenu = false
    @State var animatingButton = false
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        
        return     NavigationView {
            
            
            
            ZStack {
                
                GeometryReader { proxy in
                    
                    Image("background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    
                }
                .ignoresSafeArea()
                //      .opacity(isHidden ? 0 : 1)
                
                //                RoundedRectangle(cornerRadius: 15)
                //                    .background(.ultraThinMaterial)
                //                    .frame(width: 75, height: 75)
                //                    .opacity(isHidden ? 0 : 1)
                
                //                ProgressView()
                //                    .colorScheme(.dark)
                Animation()
                    .frame(width: 150, height: 150)
                    .opacity(isHidden ? 0 : 1)
                //                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .onAppear(perform: {
                        if firstLoad == true {
                            
                            let workItemFeed = DispatchWorkItem {
                                print("Task 1 started")
                                FeedString = fname(furl: httpsAddress)
                                FeedArray = fparse(fhtml: FeedString)
                                print("Task 1 finished")
                                withAnimation{
                                    isHidden.toggle()
                                }
                            }
                            
                            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 30) {
                                workItemFeed.cancel()
                                print("feed - cancelled")
                            }

                            concurrentQueue.async(execute: workItemFeed)
                            firstLoad = false
                        }
                    })
                
                //                GeometryReader { proxy in
                //                    let topEdge = proxy.safeAreaInsets.top
                //                    //    Home(topEdge: topEdge)
                //                    Home(FeedArray: FeedArray, topEdge: topEdge)
                //                        .ignoresSafeArea(.all, edges: .top)
                //                }
                
                
                GeometryReader { geometry in
                    let topEdge = geometry.safeAreaInsets.top
                    ZStack(alignment: .leading) {
                        Home(FeedArray: FeedArray, topEdge: topEdge)
                            .ignoresSafeArea(.all, edges: .top)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                            .disabled(self.showMenu ? true : false)
                        if self.showMenu {
                            MenuView()
                                .frame(width: geometry.size.width/2)
                                .transition(.move(edge: .leading))
                        }
                    }
                    .gesture(drag)
                }
                .opacity(isHidden ? 1 : 0)
                //                .overlay(
                //                    NavigationLink(destination: TagsView()) {
                //                        Text("Теги")
                //                    }
                //                )
                
                .overlay(Button(action: {
                    withAnimation() {
                        showMenu.toggle()
                        animatingButton.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring()) {
                            animatingButton.toggle()
                        }
                    }
                }){
                    ZStack {
                        blurView(cornerRadius: 25)
                            .frame(width: 50, height: 50)
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color("FontColor"))
                    }
                }
                            .rotationEffect(.degrees(showMenu ? 90 : 0))
                            .scaleEffect(animatingButton ? 1.1 : 1)
                            .shadow(radius: 3)
                            .padding(.top, 5)
                            .padding(.leading, 15)
                         , alignment: .topLeading
                )
                .opacity(isHidden ? 1 : 0)
                
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
