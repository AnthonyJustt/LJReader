//
//  ArchiveView.swift
//  LJReader
//
//  Created by Anton Krivonozhenkov on 03.10.2021.
//

import SwiftUI

struct ArchiveView: View {
    
    @State var archiveYears = [String]()
    @State private var selectedMenuItem = "2021"
    
    @Environment(\.calendar) var calendar
    
    let formatter = DateFormatter()
    
    private var year: DateInterval {
        
        formatter.dateFormat = "yyyy"
        let dateString = formatter.date(from: selectedMenuItem)!
        
        return  calendar.dateInterval(of: .year, for: dateString)!
    }
    
    @State private var isHidden:Bool = false
    @State private var firstLoad: Bool = true
    let concurrentQueue = DispatchQueue(label: "content.loading.years", attributes: .concurrent)
    
    var body: some View {
        ZStack{
            LoaderView()
                .opacity(isHidden ? 0 : 1)
                .onAppear(perform: {
                    if firstLoad == true {
                        let letsgetTags = DispatchWorkItem {
                            print("Task 1 started")
                            let fname = fname(furl: "https://evo-lutio.livejournal.com/calendar")
                            archiveYears = fparseArchiveYear(fhtml: fname)
                            print("Task 1 finished")
                            withAnimation{
                                isHidden.toggle()
                            }
                        }
                        
                        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 30) {
                            letsgetTags.cancel()
                            print("tags - cancelled")
                        }
                        
                        concurrentQueue.async(execute: letsgetTags)
                        firstLoad = false
                    }
                })
            
            VStack {
                
                //                ForEach(archiveYears , id: \.self) { aYear in
                //                    Text(aYear)
                //                }
                
                CalendarView(interval: year) { date in
                    Text("30")
                        .hidden()
                        .padding(8)
                        .padding(.vertical, 2)
                        .overlay(
                            Text(String(self.calendar.component(.day, from: date)))
                        )
                        .overlay(Circle()
                                    .stroke(.blue)
                        )
                        .onTapGesture {
                            print(date)
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy/MM/dd"
                            let dateString = formatter.string(from: date)
                            print(dateString)
                        }
                }
            }
            .opacity(isHidden ? 1 : 0)
        }
        .navigationTitle("Архив за \(selectedMenuItem) год")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Menu {
            ForEach(archiveYears, id: \.self) {
                index in
                Button(action: {
                    selectedMenuItem = "\(index)"
                }, label: {
                    if selectedMenuItem == index{
                        HStack {
                            Text(LocalizedStringKey(index))
                            Image(systemName: "checkmark")
                        }} else {
                            Text(LocalizedStringKey(index))
                        }
                })
            }
        }
                            label: {
            Label("", systemImage: "ellipsis.circle")
                .font(.title2)
                .opacity(isHidden ? 1 : 0)
        }
        )
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
    }
}
