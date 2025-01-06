//
//  EventsView.swift
//  KLEO
//
//  Created by Tanner George on 7/19/23.
//

import SwiftUI
import EventKit

var events: [EKEvent] = []

struct EventsView: View {
    @State var hasEvents = checkCalFor(name: "My Calendar")
    @State var selectedEvent: EKEvent?
    
    init() {
        if hasEvents {
            events = getEvents(name: "My Calendar")
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("app_bg")
                    .edgesIgnoringSafeArea(.all)
                if EKEventStore.authorizationStatus(for: .event) == .denied {
                    ErrorView(emoji: "😔", title: "You disabled calendar access", text: "You'll need to enable this capability in Settings.", nav: "Events")
                } else if hasEvents == false {
                    ErrorView(emoji: "🤔", title: "We can't find your calendar", text: "Check that you have the \"My Calendar\" calendar in your Calendar app. If not, subscribe from Veracross!", nav: "Events")
                } else if events.count == 0 {
                    EmptyView(emoji: "🐳", title: "Have a whale of a day", text: "No events are happening today.", show: true, nav: "Events")
                } else {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        ScrollView {
                            VStack {
                                ForEach(events, id: \.self) { event in
                                    Button {
                                        selectedEvent = event
                                    } label: {
                                        ZStack {
                                            Image("event_img")
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(15)
                                                .padding([.leading, .trailing, .bottom])
                                            
                                            VStack {
                                                Text(event.title)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 28, design: .rounded))
                                                    .padding([.leading, .trailing], 25)
                                                
                                                Text(event.location ?? "No Location")
                                                    .foregroundColor(.white)
                                                    .padding([.top])
                                                    .font(.system(size: 16, design: .rounded))
                                            
                                                Text(event.startDate, style: .time)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 16, design: .rounded))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .sheet(item: $selectedEvent) { e in
                            NavigationStack {
                                ZStack {
                                    Color("app_bg")
                                        .edgesIgnoringSafeArea(.all)
                                    TabView {
                                        InfoView(course: e, emoji: "🧭", title: "Location", property: 0)
                                        InfoView(course: e, emoji: "⏰", title: "Time", property: 1)
                                        //InfoView(course: e, emoji: "🧠", title: "Details", property: 2)
                                    }
                                    .tabViewStyle(.page)
                                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                                }
                                .navigationTitle(e.title)
                            }
                        }
                        .navigationTitle("Events")
                    } else {
                        NavigationSplitView(columnVisibility: .constant(.all)) {
                            List {
                                ScrollView {
                                    VStack {
                                        ForEach(events, id: \.self) { event in
                                            Button {
                                                selectedEvent = event
                                            } label: {
                                                ZStack {
                                                    Image("event_img")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(15)
                                                        .padding([.leading, .trailing], 5)
                                                        .padding(.bottom, 5)
                                                    VStack {
                                                        Text(event.title)
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 24, design: .rounded))
                                                            .padding([.leading, .trailing], 10)
                                                            .multilineTextAlignment(.center)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .navigationTitle("Events")
                        } detail: {
                            if selectedEvent != nil {
                                iPadInfoView(event: selectedEvent!)
                            } else {
                                ZStack {
                                    Color("app_bg")
                                        .edgesIgnoringSafeArea(.all)
                                    EmptyView(emoji: "👋", title: "Hello again!", text: "Select an event from the tab bar to see its details.", show: false, nav: "Events")
                                }
                            }
                        }
                        .navigationSplitViewStyle(.balanced)
                    }
                }
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
