//
//  ContributorsView.swift
//  Footnote
//
//  Created by Vivian Phung on 9/29/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct ContributorsView: View {
    var body: some View {
        VStack {
            /// style this
            Text("Contributors:")
            Spacer()
                .frame(height: 10)
            Text("cambardell")
        }
    }
}

struct ContributorsView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorsView()
    }
}
