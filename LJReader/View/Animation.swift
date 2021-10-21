//
//  Animation.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 04.10.2021.
//

import SwiftUI

struct Animation: View {
    
    @State private var x: CGFloat = 1
    @State private var y: CGFloat = 1
    @State private var count: Int = 0
    @State private var blurOffset: CGFloat = 175
    
    let animationTime: Double = 0.8
    
    var body: some View {
        ZStack {
            ZStack {
                Image("ios15")
                    .resizable()
                    .foregroundColor(.blue)
                Circle()
                    .foregroundColor(.white)
                    .opacity(0.8)
                    .offset(x: blurOffset, y: 50)
                    .blur(radius: 30)
            }
            .frame(width: 150, height: 150)
            .mask(Image("ios15").resizable().frame(width: 150, height: 150))
            .shadow(radius: 10)
            .rotation3DEffect(.degrees(15), axis: (x: x, y: y, z: 0))
        }
        .onAppear{
            Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { timer in
                withAnimation(.linear(duration: animationTime)) {
                    switch count {
                    case 0:
                        x = -1
                    case 1:
                        y = -1
                    case 2:
                        x = 1
                    default:
                        blurOffset = -175
                        y = 1
                        count = -1
                    }
                }
                if count == 2 {
                    blurOffset = 175
                }
                count += 1
            }
        }
    }
}

struct Animation_Previews: PreviewProvider {
    static var previews: some View {
        Animation()
    }
}
