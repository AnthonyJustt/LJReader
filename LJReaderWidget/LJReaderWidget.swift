//
//  LJReaderWidget.swift
//  LJReaderWidget
//
//  Created by Anton Krivonozhenkov on 03.01.2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct LJReaderWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        
        
        if family == .systemSmall {
            Text("ss")
        }
        
        if family == .systemMedium {
            VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.teal)
                                Text("01-01-2022")
                                Spacer()
                                Image(systemName: "bubble.right")
                                    .foregroundColor(Color.indigo)
                                Text("123")
                            }
                            .font(.callout)
                            .lineLimit(1)
                            .frame(height: 38)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .background(.ultraThinMaterial)
                            .zIndex(1)
                            VStack {
                                HStack {
                                    //   if item.rate != "–" {
                                    Text(" ")
                                    Text("rate")
                                        .font(.system(size: 14))
                                    Spacer()
                                    //   }
                                }
                                Text("TITLE1")
                                    .bold()
                                    .padding()
                                Text("tags")
                                    .padding(.bottom, 6)
                            }
                            .background(.regularMaterial)
                            .foregroundColor(.primary)
                        }
        }
    }
}

@main
struct LJReaderWidget: Widget {
    let kind: String = "LJReaderWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LJReaderWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("LJReader Widget")
        .description("Widget shows newly added articles")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct LJReaderWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LJReaderWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            LJReaderWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
