//
//  Button+Modifier.swift
//  Footnote
//
//  Created by Raj Raval on 05/10/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct RoundedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(Color.blue)
            .cornerRadius(10)
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(.horizontal, 36)
    }
}

extension View {
    func roundedButtonStyle() -> some View {
        self.modifier(RoundedButton())
    }
}
