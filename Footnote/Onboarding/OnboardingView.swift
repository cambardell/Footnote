//
//  OnboardingView.swift
//  Footnote
//
//  Created by Raj Raval on 05/10/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer(minLength: 64)
            VStack(alignment: .center) {
                Text("What's New")
                    .font(.system(size: 44))
                    .fontWeight(.heavy)
                    .kerning(-0.92)
                VStack(alignment: .leading) {
                    OnboardingGroupView(
                        image: "QuoteIcon",
                        heading: "Pen down your quotes",
                        subheading: "Write and save your favourite quotes from the books you read."
                    )
                    OnboardingGroupView(
                        image: "TextIcon",
                        heading: "Customise your quotes",
                        subheading: "Customise and tune your quotes using different fonts and colors."
                    )
                    OnboardingGroupView(
                        image: "ShareIcon",
                        heading: "Share your quotes",
                        subheading: "Share your customise quotes with your friends."
                    )
                }
                .padding(.horizontal)
            }
            Spacer()
            Button("Continue") {
                presentationMode.wrappedValue.dismiss()
            }
            .roundedButtonStyle()
            .padding(.bottom)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
