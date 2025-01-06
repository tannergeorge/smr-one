//
//  SplashView.swift
//  SMR App
//
//  Created by Tanner George on 6/19/23.
//

import SwiftUI

struct SplashView: View {
    @State var animating = true
    @State var size = 0.1
    
    var body: some View {
        if animating {
            ZStack {
                Color("launch_bg")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        Image("launch_logo")
                    }
                    /*
                    .scaleEffect(size)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation {
                                self.size = 0.9
                            }
                        }
                    }
                     */
                }
                /*
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        withAnimation {
                            animating = false
                        }
                    }
                }
                 */
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
