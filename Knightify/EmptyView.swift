//
//  EmptyView.swift
//  SMR App
//
//  Created by Tanner George on 6/19/23.
//

import SwiftUI

struct EmptyView: View {
    let emoji: String
    let title: String
    let text: String
    let show: Bool
    let nav: String
    
    @State var fullHand = false
    
    init(emoji: String, title: String, text: String, show: Bool, nav: String) {
        self.emoji = emoji
        self.title = title
        self.text = text
        self.show = show
        self.nav = nav
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if emoji == "👋" {
                    if #available(iOS 17.0, *) {
                        Image(systemName: fullHand ? "hand.wave": "hand.wave.fill")
                            .font(.system(size: 150))
                            .foregroundColor(.yellow)
                            .contentTransition(.symbolEffect(.replace))
                            .onAppear {
                                fullHand = true
                            }
                    }
                } else {
                    Text(emoji)
                        .font(.system(size: 150))
                        .padding()
                }
                Text(title)
                    .fontWeight(.bold)
                    .font(.system(size: 28, design: .rounded))
                    .padding()
                Text(text)
                    .font(.system(size: 16, design: .rounded))
                    .padding([.top, .leading, .trailing])
                    .multilineTextAlignment(.center)
                if show {
                    Text("Try clearing the app and checking your calendar refresh rates in Settings if you think this is a mistake.")
                        .font(.system(size: 16, design: .rounded))
                        .padding([.leading, .trailing])
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle(nav)
        }
    }
}
