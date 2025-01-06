//
//  iPadInfoView.swift
//  SMR App
//
//  Created by Tanner George on 6/22/23.
//

import SwiftUI
import EventKit

struct iPadInfoView: View {
    let event: EKEvent
    
    init(event: EKEvent) {
        self.event = event
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("app_bg")
                    .edgesIgnoringSafeArea(.all)
                
                TabView {
                    InfoView(course: event, emoji: "🧭", title: "Location", property: 0)
                    InfoView(course: event, emoji: "⏰", title: "Time", property: 1)
                    //InfoView(course: event, emoji: "🧠", title: "Details", property: 2)
                }
            }
            .navigationTitle(event.title)
        }
    }
}
