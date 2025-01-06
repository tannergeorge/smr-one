//
//  TermsView.swift
//  SMR App
//
//  Created by Tanner George on 6/23/23.
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("app_bg")
                    .edgesIgnoringSafeArea(.all)
                List {
                    Text("By selecting the button \"I understand and agree\", you agree to and affirm your understanding of the following terms and conditions.\n1. The information provided is for general informational purposes only. All information is provided in good faith, however the Developer nor St. Mary’s Ryken makes no representation or warranty of any kind, expressed or implied, regarding the accuracy, validity, reliability, availability, or completeness of any information.\n2. The services are provided on an “as is” and “as available” basis and by using them, users accept that they may contain defects or not meet their expectations.\n3. The User is responsible for completing Setup with complete thoroughness to the best of their ability. Not doing so may result in less accurate content displayed in SMR One.\n4. SMR One, the Developer, nor St. Mary’s Ryken may be held liable for tardiness or missed assignments associated with SMR One.\n5. The Developer nor St. Mary’s Ryken assumes no responsibility or liability for any errors or omissions in presented content.\n6. Although it requires access to Calendar, SMR One never stores or shares user data in any capacity.\n7. Until notified otherwise, SMR One does not support summer classes and summer assignments.\n8. By your use of SMR One, the use is at your sole risk.")
                }
                .padding(.top)
            }
            .navigationTitle("Terms & Conditions")
        }
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
