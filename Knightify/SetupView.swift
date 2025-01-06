//
//  SetupView.swift
//  SMR App
//
//  Created by Tanner George on 6/9/23.
//

import SwiftUI

struct SetupView: View {
    let emoji: String
    let title: String
    let text: String
    
    init(emoji: String, title: String, text: String) {
        self.emoji = emoji
        self.title = title
        self.text = text
    }
    
    
    var body: some View {
        VStack {
            Text(emoji)
                .font(.system(size: 150))
                .padding()
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 28))
                .padding()
            Text(text)
                .font(.system(size: 18))
                .padding([.leading, .trailing, .bottom])
                .multilineTextAlignment(.center)
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView(emoji: "", title: "", text: "")
    }
}
