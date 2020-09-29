//
//  QuoteItemView.swift
//  Footnote
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI
import CoreData

struct QuoteItemView: View {
    @ObservedObject var quote: Quote
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top) {
                if quote.coverImage != nil {
                    BookCoverView(image: Image(uiImage: UIImage(data: quote.coverImage!)!))
                        
                }
                
                Text(quote.text ?? "")
                .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .lineSpacing(4.0)
                Spacer()
            }
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(quote.title ?? "")").font(.body)
                        .foregroundColor(Color.footnoteRed)
                    Text("by \(quote.author ?? "")").font(.body)
                        .foregroundColor(Color.footnoteRed)
                }
                Spacer()
                Text(formatDate(date: quote.dateCreated ??
                Date())).font(.body)
                .foregroundColor(Color.footnoteRed)
                
            }.padding(3)
        }
        
        
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        return formatter.string(from: date)
    }
}


struct QuoteItemView_Previews: PreviewProvider {

    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newQuote = Quote.init(context: context)
        newQuote.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum et urna vitae nunc ullamcorper auctor id a justo. Ut rutrum sapien metus, at congue arcu imperdiet sed. Sed tristique quam ullamcorper magna lobortis dapibus."
        newQuote.author = "author"
        newQuote.title = "title"
        newQuote.dateCreated = Date()
        return VStack {
            Divider()
            QuoteItemView(quote: newQuote)
            Divider()
        }.padding()
    }
}
