//
//  AboutView.swift
//  KLEO
//
//  Created by Tanner George on 7/17/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        NavigationStack {
            ZStack {
                Color("app_bg")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    
                    Text("With support-related questions, comments, or concerns, please contact:\nkleo.app@smrhs.org")
                        .font(.system(size: 20, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        openURL(URL(string: "https://drive.google.com/drive/folders/1-Oyh3TtLXUVV3MnWqxbzCSvQu-kaS9zR")!)
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "heart")
                            Text("Mental Health Resources")
                                .font(.system(size: 18, design: .rounded))
                            Spacer()
                        }
                    }
                    .tint(.pink)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding([.leading, .trailing])
                    .padding(.bottom, 1)
                    
                    Button {
                        openURL(URL(string: "https://www.termsfeed.com/live/c04bcad6-3112-4b7c-92b0-077b8b7799ff")!)
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "hand.raised")
                            Text("Privacy Policy")
                                .font(.system(size: 18, design: .rounded))
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding([.leading, .trailing])
                    .padding(.bottom, 1)
                    
                
                    Text("Tapping above will take you outside SMR One.")
                        .font(.system(size: 18, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                .navigationTitle("About")
            }
                
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
