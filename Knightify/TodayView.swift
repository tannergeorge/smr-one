//
//  TodayView.swift
//  SMR App
//
//  Created by Tanner George on 5/13/23.
//

import SwiftUI
import EventKit
import EventKitUI

var courses: [EKEvent] = []

struct TodayView: View {
    @State var showingPopover = false
    @State var selectedCoursePhone: EKEvent?
    @State var selectedCoursePad: EKEvent?
    @State var showingAbout = false
    
    
    @State var hasClasses = checkCalFor(name: "All Classes")
    
    @Environment(\.dismiss) var dismiss
    
    init() {
        if hasClasses {
            courses = getEvents(name: "All Classes")
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                
                if EKEventStore.authorizationStatus(for: .event) == .denied {
                    NavigationStack {
                        ErrorView(emoji: "😔", title: "You disabled calendar access", text: "You'll need to enable this capability in Settings.", nav: "Classes")
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button {
                                        showingAbout = true
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .font(.callout)
                                    }
                                }
                            }
                    }
                    .sheet(isPresented: $showingAbout) {
                        AboutView()
                    }
                } else if hasClasses == false {
                    NavigationStack {
                        ErrorView(emoji: "🤔", title: "We can't find your calendar", text: "Check that you have the \"All Classes\" calendar in your Calendar app. If not, subscribe to it from Veracross!", nav: "Classes")
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button {
                                        showingAbout = true
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .font(.callout)
                                    }
                                }
                            }
                    }
                    .sheet(isPresented: $showingAbout) {
                        AboutView()
                    }
                } else if courses.count == 0 {
                    NavigationStack {
                        EmptyView(emoji: "🦀", title: "No need to be crabby", text: "You don't have any classes today.", show: true, nav: "Classes")
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button {
                                        showingAbout = true
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .font(.callout)
                                    }
                                }
                            }
                    }
                        .sheet(isPresented: $showingAbout) {
                            AboutView()
                        }
                } else {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        ScrollView {
                            VStack {
                                ForEach(courses, id: \.self) { course in
                                    Button {
                                        selectedCoursePhone = course
                                    } label: {
                                        ZStack {
                                            Image("event_img")
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(15)
                                                .padding([.leading, .trailing, .bottom])
                                             
                                            VStack {
                                                Text(course.title)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 28, design: .rounded))
                                                Text(course.location ?? "No Location")
                                                    .foregroundColor(.white)
                                                    .padding([.top])
                                                    .font(.system(size: 16, design: .rounded))
                                                Text(course.startDate, style: .time)
                                                    .foregroundColor(.white)
                                                    .italic()
                                                    .font(.system(size: 16, design: .rounded))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .sheet(item: $selectedCoursePhone) { course in
                            NavigationStack {
                                ZStack {
                                    background
                                    TabView {
                                        InfoView(course: course, emoji: "🧭", title: "Location", property: 0)
                                        InfoView(course: course, emoji: "⏰", title: "Time", property: 1)
                                        //InfoView(course: course, emoji: "🧠", title: "Details", property: 2)
                                    }
                                    .tabViewStyle(.page)
                                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                                }
                                .navigationTitle(course.title)
                            }
                        }
                        .sheet(isPresented: $showingAbout) {
                            AboutView()
                        }
                        .navigationTitle("Classes")
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button {
                                    showingAbout = true
                                } label: {
                                    Image(systemName: "info.circle")
                                        .font(.callout)
                                }
                            }
                        }
                    } else {
                        NavigationSplitView(columnVisibility: .constant(.all)) {
                            List {
                                ScrollView {
                                    VStack {
                                        ForEach(courses, id: \.self) { course in
                                            Button {
                                                selectedCoursePad = course
                                            } label: {
                                                ZStack {
                                                    Image("event_img")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(15)
                                                        .padding([.leading, .trailing], 5)
                                                        .padding(.bottom, 5)
                                                    VStack {
                                                        Text(course.title)
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
                            .navigationTitle("Classes")
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button {
                                        showingAbout = true
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .font(.callout)
                                    }
                                }
                            }
                        } detail: {
                            if selectedCoursePad != nil {
                                iPadInfoView(event: selectedCoursePad!)
                            } else {
                                ZStack {
                                    background
                                    EmptyView(emoji: "👋", title: "Hello again!", text: "Select a class from the tab bar to see its details.", show: false, nav: "Classes")
                                }
                            }
                        }
                        .navigationSplitViewStyle(.balanced)
                        .sheet(isPresented: $showingAbout) {
                            AboutView()
                        }
                    }
                }
            }
        }
    }
}

extension EKEvent: Identifiable {
    public var id: String { self.eventIdentifier }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}

private extension TodayView {
    var background : some View {
        Color("app_bg")
            .edgesIgnoringSafeArea(.all)
    }
}
