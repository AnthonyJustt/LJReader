//
//  ParsingMethods.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 27.09.2021.
//

import Foundation
import SwiftSoup

func fname(furl: String) -> String {
    var contents: String = ""
    
    let encodedUrl = furl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    print("fname: \(furl)")
    
    if let url = URL(string: encodedUrl) {
        do {
            contents = try String(contentsOf: url)
            print("fname: content was successfully received")
        } catch {
            print(url)
            print("fname: contents could not be loaded")
        }
    } else {
        print("fname: the URL was bad!")
    }
    
    return contents
}

func fparse(fhtml: String) -> Array<FeedListItem> {
    print("fparse was started")
    
    var arrayToReturn: [FeedListItem] = []
    //var tagsArray = [String]()
    var tagsString: String = "Теги: "
    
    do {
        let html_nil: String = "<p>–";
        let doc_nil: Document = try SwiftSoup.parse(html_nil)
        let element_nil: Element = try doc_nil.select("p").first()!
        
        let html: String = fhtml;
        
        let doc: Document = try SwiftSoup.parse(html)
        let els00: Elements = try doc.select("div.entry-wrap")
        
        for i in 0 ..< els00.array().count {
            
            let els0: Element = try els00[i].select("a.subj-link").first() ?? element_nil // заголовок статьи
            let els1: Element = try els00[i].select("span.entry-rating__text").first() ?? element_nil // рейтинг
            let els2: Element = try els00[i].select("abbr.updated").first()! // дата
            let els3: Element = try els00[i].select("div.entry-content ").first()! // превью статьи
            let els6: Element = try els00[i].select("span.reaction-stats__count").first() ?? element_nil // лайки - не будет без js
            let els7: Element = try els00[i].select("li.comments").first() ?? element_nil // комментарии
            
            let els01: Elements = try els00[i].select("a[rel=tag]")
            for j in 0 ..< els01.array().count {
                // tagsArray.append(try els01[j].text())
                let s = try els01[j].text()
                tagsString = tagsString + "[\(s)](" + s.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + ")"
                if j < els01.array().count-1 {
                    tagsString = tagsString + ", "
                }
            }
            
            arrayToReturn.append(FeedListItem(
                title: try els0.text(),
                link: try els0.attr("href"),
                rate: try els1.text(),
                date: try els2.text(),
                article_snippet: try els3.text(),
                tags: tagsString,
                likes: try els6.text(),
                comments: try els7.text().components(separatedBy: " ")[0]))
            
            tagsString = "Теги: "
        }
        
        print("fparse: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    
    return arrayToReturn
}

func fparseArticle(fhtml: String) -> String {
    print("fparseArticle was started")
    
    var stringToReturn: String = ""
    
    let start1 = """
                <html lang="ru" data-vue-meta="lang">
                <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width,user-scalable=0,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
                </head>
                <body>
"""
    
    let end1 = "<br>&nbsp;<br>&nbsp;<br>&nbsp;</body></html>"
    
    do {
        let html_nil: String = "<p>–";
        let doc_nil: Document = try SwiftSoup.parse(html_nil)
        let element_nil: Element = try doc_nil.select("p").first()!
        
        let html: String = fhtml;
        
        let doc: Document = try SwiftSoup.parse(html)
        let els00: Element = try doc.select("div.b-singlepost-bodywrapper").first() ?? element_nil // тело поста
        stringToReturn = try els00.html()
        
        let els01: Elements = try doc.select("a.tag__link") // категории поста
        for i in 0 ..< els01.array().count {
            print(try els01[i].text())
        }
        
        print("fparseArticle: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    
    stringToReturn = start1 + stringToReturn + end1
    
    return stringToReturn
}

func fparseTagsList(fhtml: String) -> ([String], [String], Int) {
    print("fparseTagsList was started")
    
    var tagsArray = [String]()
    var alphabetArray = [String]()
    var unique = [String]()
    var tagsCount: Int = 0
    
    do {
        
        let html: String = fhtml;
        
        let doc: Document = try SwiftSoup.parse(html)
        
        let els01: Elements = try doc.select("a[rel=tag]") // категории поста
        
        tagsCount = els01.array().count
        
        for i in 0 ..< tagsCount {
            let sTag = try els01[i].text()
            let sCount = try els01[i].attr("title")
            tagsArray.append("\(sTag) - \(sCount)".uppercased())
            alphabetArray.append(String(sTag.first!.uppercased()))
        }
        
        unique = Array(Set(alphabetArray)).sorted()
        
        print("fparseTagsList: content was successfully parsed")
        
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    
    return (tagsArray, unique, tagsCount)
}

func fparseArchiveYear(fhtml: String) -> [String] {
    print("fparseArchive was started")
    
    var archiveYearArray = [String]()
    
    do {
        let html: String = fhtml;
        
        let doc: Document = try SwiftSoup.parse(html)
        let els00: Element = try doc.select("div.entry-text").first()!
        let els01: Elements = try els00.select("li")
        
        for i in 0 ..< els01.array().count {
            archiveYearArray.append(try els01[i].text())
        }
        
        print("fparseArchive: content was successfully parsed")
    }
    catch Exception.Error(let type, let message) {
        print(type, message)
    }
    catch {
        print("error")
    }
    
    print(archiveYearArray)
    return archiveYearArray
}
