//
//  LeftTextView.swift
//  SMR One
//
//  Created by Tanner George on 8/6/23.
//

import SwiftUI

struct LeftTextView: View {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 24))
                .bold()
                .padding()
            Spacer()
        }
    }
}

struct LeftTextView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTextView(text: "Test")
    }
}
