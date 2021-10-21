//
//  ArticlePreview.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 04.10.2021.
//

import SwiftUI

struct ArticlePreview: View {
    var htmlBody: String
    let start1 = """
                <html lang="ru" data-vue-meta="lang">
                <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width,user-scalable=0,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
                </head>
                <body>
"""
    var body: some View {
        WebView_(request: start1 + htmlBody)
            .padding()
    }
}

struct ArticlePreview_Previews: PreviewProvider {
    static var previews: some View {
        ArticlePreview(htmlBody: "html")
    }
}
