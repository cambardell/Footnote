//
//  QuoteDetailView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-01-23.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import CoreData

struct QuoteDetailView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @State var text: String
    @State var title: String
    @State var author: String

    // Issue #17: Provide the user an option to change the media type
    @State var mediaType: MediaType

    // Textfield Validation
    @State private var showEmptyTextFieldAlert = false
    private var textFieldsAreNonEmpty: Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        return !trimmedText.isEmpty && !trimmedAuthor.isEmpty && !trimmedTitle.isEmpty
    }

    @State var showImageCreator = false
    var quote: Quote

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

    var body: some View {

        VStack(spacing: 20) {
            Spacer()
                .frame(height: 5)

            // Issue #17: Show the user the media type of their quote
            Picker("Media Type", selection: $mediaType) {
                ForEach(MediaType.allCases, id: \.rawValue) {type in
                    Text(type.stringValue).font(.largeTitle)
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .accentColor(.blue)

            Divider()

            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.footnoteRed, lineWidth: 0.5)
                .frame(height: textFieldHeight)
                .shadow(radius: 5)
                .overlay(
                    DynamicHeightTextField(text: $text, height: $textHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(height: textFieldHeight)
            ).padding(.horizontal)

            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.footnoteRed, lineWidth: 0.5)
                .frame(height: authorFieldHeight)
                .shadow(radius: 5)
                .overlay(
                    DynamicHeightTextField(text: $title, height: $titleHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(height: titleFieldHeight)

            ).padding(.horizontal)

            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.footnoteRed, lineWidth: 0.5)
                .frame(height: authorFieldHeight)
                .shadow(radius: 5)
                .overlay(
                    DynamicHeightTextField(text: $author, height: $authorHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .frame(height: authorFieldHeight)

            ).padding(.horizontal)

            Button(action: {
                if textFieldsAreNonEmpty {
                    self.updateQuote()
                } else {
                    self.showEmptyTextFieldAlert = true
                }
            }, label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.footnoteRed)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .overlay(
                        Text("Save changes")
                            .foregroundColor(.white)

                )
            })
            .alert(isPresented: $showEmptyTextFieldAlert, content: {
                    Alert(title: Text("Error Updating Quote"),
                          message: Text("Please ensure that all text fields are filled before updating."),
                          dismissButton: .default(Text("Ok")))
            })

            Button(action: {
                self.showImageCreator = true
            }, label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.footnoteRed)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .overlay(
                        Text("Share quote")
                            .foregroundColor(.white)

                )
                    .sheet(isPresented: self.$showImageCreator) {
                        ImageCreator(text: self.quote.text ?? "", source: self.quote.title ?? "")
                }
            })
            Spacer()
        }

    }

    func updateQuote() {
        print("update")

        quote.text = self.text
        quote.title = self.title
        quote.author = self.author

        // Issue #17: Persist media type in core data
        quote.mediaType = self.mediaType.rawCoreDataValue()

        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }

    }
}

//struct QuoteDetailView_Preview: PreviewProvider {
//    
//    static var previews: some View {
//        let refresh = false
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        
//        let text = """
//Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum et urna vitae nunc ullamcorper auctor id a
// justo. Utrutrum sapien metus, at congue arcu imperdiet sed. Sed tristique quam ullamcorper magna lobortis dapibus.
//"""
//        let author = "author"
//        let title = "title"
//        
//        let newQuote = Quote.init(context: context)
//        newQuote.text = text
//        newQuote.title = title
//        newQuote.author = author
//        newQuote.dateCreated = Date()
//        return QuoteDetailView(text: text, title: title, author: author, quote: newQuote, refresh: false).padding()
//        
//    }
//}

struct QuoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
