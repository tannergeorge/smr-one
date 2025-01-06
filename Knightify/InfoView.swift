//
//  InfoView.swift
//  SMR App
//
//  Created by Tanner George on 6/8/23.
//

import EventKit
import SwiftUI

struct InfoView: View {
    let course: EKEvent
    let emoji: String
    let title: String
    let property: Int
    
    @State var animationValue = 0
    @State var animationValue2 = 0
    @State var showingWalk = true
    
    init(course: EKEvent, emoji: String, title: String, property: Int) {
        self.course = course
        self.emoji = emoji
        self.title = title
        self.property = property
    }
    
    var body: some View {
        VStack {
            if #available(iOS 17.0, *) {
                if emoji == "⏰" {
                    Image(systemName: "alarm.waves.left.and.right")
                        .symbolEffect(.bounce.up.byLayer, value: animationValue)
                        .foregroundColor(.green)
                        .font(.system(size: 150))
                        .onAppear {
                            withAnimation {
                                animationValue += 1
                            }
                        }
                } else {
                    Image(systemName: "building.2")
                        .symbolEffect(.bounce.up.byLayer, value: animationValue2)
                        .foregroundColor(.blue)
                        .font(.system(size: 150))
                        .onAppear {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                withAnimation {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                        animationValue2 += 1
                                    }
                                }
                            } else {
                                withAnimation {
                                    animationValue2 += 1
                                }
                            }
                        }
                }
            } else {
                // Fallback on earlier versions
            }
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 28, design: .rounded))
                .padding()
            if property == 0 {
                Text(course.location ?? "No location found.")
                    .font(.system(size: 24, design: .rounded))
                    .padding()
                    .multilineTextAlignment(.center)
            } else if property == 1 {
                Text("\(course.startDate, style: .time) to \(course.endDate, style: .time)")
                    .font(.system(size: 24, design: .rounded))
                    .padding()
                    .multilineTextAlignment(.center)
            } else {
                Text(course.notes ?? "No details found.")
                    .font(.system(size: 24, design: .rounded))
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }
}

/*
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(emoji: "🔥", title: "Title", )
    }
}
*/
