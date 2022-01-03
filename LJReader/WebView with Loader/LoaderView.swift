//
//  LoaderView.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 03.01.2022.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
            }
            .frame(width: 75, height: 75, alignment: .center)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .colorScheme(.dark)
            .shadow(radius: 5)
            
            ProgressView()
                .colorScheme(.dark)
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
            .previewLayout(.sizeThatFits)
            .padding()
//         .preferredColorScheme(.dark)
    }
}
