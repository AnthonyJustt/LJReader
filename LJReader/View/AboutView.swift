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
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
