//
//  OnboardingGroupView.swift
//  Footnote
//
//  Created by Raj Raval on 05/10/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct OnboardingGroupView: View {

    let image: String
    let heading: String
    let subheading: String

    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding()
            VStack(alignment: .leading) {
                Text(heading)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                Text(subheading)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

struct OnboardingGroupView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingGroupView(
            image: "QuoteIcon",
            heading: "Pen down your quotes",
            subheading: "Write and save your favourite quotes from the books you read."
        )
    }
}
