//
//  ContentView.swift
//  Knightify
//
//  Created by Tanner George on 5/13/23.
//

import SwiftUI
import CoreData
import EventKit

struct ContentView: View {
    //Core Data
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<AgendaItem>
    
    
    @AppStorage("onboarded") var onboarded = false
    @Environment(\.colorScheme) var colorScheme
    
    @State var step = 0
    @State var showingAlert = false
    @State var displaying = false
    @State var ready = false
    @State var animating = true
    
    var emojis = ["👋", "👌", "📆", "🤝", "⚠️", "😎"]
    var titles = ["Hey there!", "Agree to continue", "Subscribe to calendars", "We need permission", "Change refresh frequency", "You're all set"]
     
    var texts = ["Welcome to SMR One! We'll take you through a few quick steps to get set up.",
                  "Before starting, you'll need to agree to the terms listed below",
                  "In Veracross, subscribe to both the \"My Calendar\", \"All Classes\", and \"ALL ASSIGNMENTS\" subscription calendars using the red button on the main page.", "SMR One will need calendar access in order to work.",
                  "In Settings, go to \"Calendar > Accounts > Fetch New Data\". At the bottom of the screen, select \"Every 15 minutes\" under \"Fetch\". SMR One won't work unless you do this!",
                  "Tap below to start using SMR One!"]
     
    var buttons = ["Continue", "I understand and agree", "Continue", "Continue", "Continue"]
    
    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleFont = UIFont(
            descriptor:
                titleFont.fontDescriptor
                .withDesign(.rounded)?
                .withSymbolicTraits(.traitBold)
                ??
                titleFont.fontDescriptor,
            size: titleFont.pointSize
        )
        
        var smallTitleFont = UIFont.preferredFont(forTextStyle: .title3)
        smallTitleFont = UIFont(
            descriptor:
                smallTitleFont.fontDescriptor
                .withDesign(.rounded)?
                .withSymbolicTraits(.traitBold)
                ??
                smallTitleFont.fontDescriptor,
            size: smallTitleFont.pointSize
        )
        
        var tabFont = UIFont.preferredFont(forTextStyle: .footnote)
        tabFont = UIFont(
            descriptor:
                tabFont.fontDescriptor
                .withDesign(.rounded)?
                .withSymbolicTraits(.traitUIOptimized)
                ??
                tabFont.fontDescriptor,
            size: tabFont.pointSize
        )
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
        UINavigationBar.appearance().titleTextAttributes = [.font: smallTitleFont]
        UITabBarItem.appearance().setTitleTextAttributes([.font: tabFont], for: .normal)
    }
    
    var body: some View {
        if animating {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        withAnimation {
                            animating = false
                        }
                    }
                }
        } else {
            if onboarded == false && displaying == false {
                NavigationStack {
                    ZStack {
                        Color("app_bg")
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Spacer()
                            if step < emojis.count {
                                SetupView(emoji: emojis[step], title: titles[step], text: texts[step])
                            } else {
                                SetupView(emoji: "😐", title: "Something went wrong", text: "Please clear the app and restart Setup.")
                            }
                            
                            if step == 1 {
                                NavigationLink {
                                    TermsView()
                                } label: {
                                    Text("View Terms & Conditions")
                                        .fontWeight(.bold)
                                }
                            }
                            
                            if step < 5 {
                                Button {
                                    if step == 3 {
                                        Task {
                                            await getAccess()
                                            withAnimation {
                                                step = step + 1
                                            }
                                        }
                                    } else {
                                        withAnimation {
                                            step = step + 1
                                        }
                                    }
                                    
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text(buttons[step])
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .padding()
                            }
                            
                            Spacer()
                            
                            if step < 5 {
                                Button {
                                    showingAlert = true
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text("Let's go!")
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                                .padding()
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("You need to finish setup"), message: Text("You can't start using SMR One without finishing setup."), dismissButton: .default(Text("Got it!")))
                                }
                            } else {
                                Button {
                                    withAnimation {
                                        displaying = true
                                    }
                                    onboarded = true
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text("Let's go!")
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .padding()
                            }
                        }
                    }
                    .navigationTitle("Setup")
                }
            } else {
                TabView {
                    TodayView()
                        .tabItem {
                            if colorScheme == .light {
                                Label("Classes", systemImage: "books.vertical")
                                    .environment(\.symbolVariants, .none)
                            } else {
                                Label("Classes", systemImage: "books.vertical")
                            }
                        }
                    EventsView()
                        .tabItem {
                            if colorScheme == .light {
                                Label("Events", systemImage: "megaphone")
                                    .environment(\.symbolVariants, .none)
                            } else {
                                Label("Events", systemImage: "megaphone")
                            }
                        }
                    AssignmentsView()
                        .tabItem {
                            if colorScheme == .light {
                                Label("Homework", systemImage: "pencil.and.ruler")
                                    .environment(\.symbolVariants, .none)
                            } else {
                                Label("Homework", systemImage: "pencil.and.ruler.fill")
                            }
                        }
                    AgendaView()
                        .environment(\.managedObjectContext, moc)
                        .tabItem {
                            if colorScheme == .light {
                                Label("Tasks", systemImage: "checklist")
                                    .environment(\.symbolVariants, .none)
                            } else {
                                Label("Tasks", systemImage: "checklist")
                            }
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
