//
//  AddQuoteUIKit.swift
//  Footnote
//
//  Created by Cameron Bardell on 2020-03-06.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import UIKit

struct AddQuoteUIKit: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var text: String = ""
    @State var author: String = ""
    @State var title: String = ""
    
    // For the height of the text field.
    @State var textHeight: CGFloat = 0
    @State var authorHeight: CGFloat = 0
    @State var titleHeight: CGFloat = 0
    
    var textFieldHeight: CGFloat {
        let minHeight: CGFloat = 40
        let maxHeight: CGFloat = 100
        
        if textHeight < minHeight {
            return minHeight
        }
        
        if textHeight > maxHeight {
            return maxHeight
        }
        
        return textHeight
    }
    var titleFieldHeight: CGFloat {
        let minHeight: CGFloat = 40
        let maxHeight: CGFloat = 70
        
        if titleHeight < minHeight {
            return minHeight
        }
        
        if titleHeight > maxHeight {
            return maxHeight
        }
        
        return titleHeight
    }
    var authorFieldHeight: CGFloat {
        let minHeight: CGFloat = 40
        let maxHeight: CGFloat = 70
        
        if authorHeight < minHeight {
            return minHeight
        }
        
        if authorHeight > maxHeight {
            return maxHeight
        }
        
        return authorHeight
    }
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(.white)
                .frame(height: textFieldHeight)
                .shadow(radius: 5)
                .overlay(
                    ZStack {
                        DynamicHeightTextField(text: $text, height: $textHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(height: textFieldHeight)
                        if text.isEmpty {
                            HStack {
                                Text("Text")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                    }
                    
            ).padding(.horizontal)
                .padding(.top)
            
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(.white)
                .frame(height: authorFieldHeight)
                .shadow(radius: 5)
                .overlay(
                    ZStack {
                        DynamicHeightTextField(text: $title, height: $titleHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(height: titleFieldHeight)
                        if title.isEmpty {
                            HStack {
                                Text("Title").padding(.horizontal)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            
                        }
                    }
                    
                    
            ).padding(.horizontal)
            
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(.white)
                .frame(height: authorFieldHeight)
                .shadow(radius: 5)
                .overlay(
                    ZStack {
                        DynamicHeightTextField(text: $author, height: $authorHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(height: authorFieldHeight)
                        if author.isEmpty {
                            HStack {
                                Text("Author")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                    }
                    
            ).padding(.horizontal)
            Divider()
            SuggestionsView(searchString: self.title)
                .background(Color.white)
            
            Button(action: {
                self.addQuote()
            }) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .overlay (
                        Text("Save changes")
                            .foregroundColor(.black)
                )
            }
            Spacer()
            
        }.padding(.top)
            .background(Color.footnoteRed)
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
    func addQuote() {
        // Add a new quote
        let quote = Quote(context: self.managedObjectContext)
        quote.title = self.title
        quote.text = self.text
        quote.author = self.author
        quote.dateCreated = Date()
        
        //        let authorItem = Author(context: self.managedObjectContext)
        //        authorItem.text = self.author
        //        authorItem.count += 1
        //
        //        let titleItem = Title(context: self.managedObjectContext)
        //        titleItem.text = self.title
        //        titleItem.count += 1
        
        if inputImage != nil {
            quote.coverImage = inputImage!.pngData() as Data?
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
            print("Failed to save new item. Error = \(error)")
            managedObjectContext.delete(quote)  
        }
        
        title = ""
        text = ""
        author = ""
    }
    
    
}

// To preview with CoreData
#if DEBUG
struct AddQuoteUIKit_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            AddQuoteUIKit().environment(\.managedObjectContext, context).environment(\.colorScheme, .light)
        }
        
    }
}
#endif


