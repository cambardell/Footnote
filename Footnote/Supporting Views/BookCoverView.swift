//
//  bookCoverView.swift
//  Footnote
//
//  Created by Cameron Bardell on 2020-01-25.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct BookCoverView: View {
    var image: Image
    var body: some View {
        image
            .resizable()
            .frame(width: 60, height: 80)
            .clipShape(Rectangle())
            .overlay(
                Rectangle().stroke(Color.footnoteRed, lineWidth: 2))
            
    }
}

struct bookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        BookCoverView(image: Image(systemName: "square"))
    }
}
