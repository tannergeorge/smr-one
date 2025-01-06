//
//  ErrorView.swift
//  SMR App
//
//  Created by Tanner George on 6/19/23.
//

import SwiftUI

struct ErrorView: View {
    let emoji: String
    let title: String
    let text: String
    let nav: String
    
    init(emoji: String, title: String, text: String, nav: String) {
        self.emoji = emoji
        self.title = title
        self.text = text
        self.nav = nav
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(emoji)
                    .font(.system(size: 150))
                    .padding()
                Text(title)
                    .fontWeight(.bold)
                    .font(.system(size: 28))
                    .padding()
                    .multilineTextAlignment(.center)
                Text(text)
                    .padding([.top, .leading, .trailing])
                    .multilineTextAlignment(.center)
            }
            .navigationTitle(nav)
        }
    }
}
