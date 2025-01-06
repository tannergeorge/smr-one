//
//  AssignmentsView.swift
//  SMR App
//
//  Created by Tanner George on 5/14/23.
//

import SwiftUI
import EventKit
import EventKitUI
import Combine

var assignments: [EKEvent] = []

struct AssignmentsView: View {
    @State var hasAssignments = checkCalFor(name: "ALL ASSIGNMENTS")
    
    init() {
        if hasAssignments {
            assignments = getEvents(name: "ALL ASSIGNMENTS")
        }
    }
    
    @State var selectedAssignmentPhone: EKEvent?
    @State var selectedAssignmentPad: EKEvent?
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                
                if EKEventStore.authorizationStatus(for: .event) == .denied {
                    ErrorView(emoji: "😔", title: "You disabled calendar access", text: "You'll need to enable this capability in Settings.", nav: "Homework")
                } else if hasAssignments == false {
                    ErrorView(emoji: "🤔", title: "We can't find your calendar", text: "Check that you have the \"ALL ASSIGNMENTS\" calendar in your Calendar app. If not, subscribe from Veracross!", nav: "Homework")
                } else if assignments.count == 0 {
                    EmptyView(emoji: "⛱️", title: "Another day in paradise", text: "You don't have any assignments due today.", show: true, nav: "Homework")
                } else {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        ScrollView {
                            VStack {
                                ForEach(assignments, id: \.self) { a in
                                    Button {
                                        selectedAssignmentPhone = a
                                    } label: {
                                        ZStack {
                                            Image("event_img")
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(15)
                                                .padding([.leading, .trailing, .bottom])
                                            VStack {
                                                Text(a.title)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 28, design: .rounded))
                                                    .padding([.leading, .trailing], 25)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .popover(item: $selectedAssignmentPhone) { assign in
                            NavigationStack {
                                ZStack {
                                    background
                                    List {
                                        Text("Details")
                                            .fontWeight(.bold)
                                            .font(.system(size: 28, design: .rounded))
                                        Text(assign.notes ?? "No details found.")
                                            .font(.system(size: 16, design: .rounded))
                                    }
                                    .padding(.top)
                                }
                                .navigationTitle(assign.title)
                            }
                        }
                        .navigationTitle("Homework")
                    } else {
                        NavigationSplitView(columnVisibility: .constant(.all)) {
                            List {
                                ScrollView {
                                    VStack {
                                        ForEach(assignments, id: \.self) { assign in
                                            Button {
                                                selectedAssignmentPad = assign
                                            } label: {
                                                ZStack {
                                                    Image("event_img")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(15)
                                                        .padding([.leading, .trailing], 5)
                                                        .padding(.bottom, 5)
                                                    VStack {
                                                        Text(assign.title)
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
                            .navigationTitle("Homework")
                        } detail: {
                            if selectedAssignmentPad != nil {
                                NavigationStack {
                                    ZStack {
                                        background
                                        List {
                                            Text("Due Today")
                                                .font(.system(size: 28, design: .rounded))
                                                .bold()
                                            Text(selectedAssignmentPad!.notes ?? "No details found")
                                                .font(.system(size: 16, design: .rounded))
                                        }
                                        .padding(.top)
                                    }
                                    .navigationTitle(selectedAssignmentPad!.title)
                                }
                            } else {
                                ZStack {
                                    background
                                    EmptyView(emoji: "👋", title: "Hello again!", text: "Select an assignment from the tab bar to see its details.", show: false, nav: "Homework")
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


struct AssignmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsView()
    }
}

private extension AssignmentsView {
    
    var background : some View {
        Color("app_bg")
            .edgesIgnoringSafeArea(.all)
    }
}
