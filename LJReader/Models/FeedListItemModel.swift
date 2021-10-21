//
//  FeedListItemModel.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 27.09.2021.
//

import Foundation

import SwiftUI

struct FeedListItem: Identifiable {
    var id = UUID()
    var title: String
    var link: String
    var rate: String
    var date: String
    var article_snippet: String
    var tags: String
    var likes: String
    var comments: String
}
