//
//  AddQuoteUIKit.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-03-06.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import UIKit

struct AddQuoteUIKit: View {

    @Environment(\.managedObjectContext) var managedObjectContext

    // Issue #17: Indicates the media type of the quote being added
    @State private var mediaType = MediaType.book

    @State var text: String = ""
    @State var author: String = ""
    @State var title: String = ""

    // Textfield Validation
    @State private var showEmptyTextFieldAlert = false
    private var textFieldsAreNonEmpty: Bool {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        return !trimmedText.isEmpty && !trimmedAuthor.isEmpty && !trimmedTitle.isEmpty
    }

    // For the height of the text field.
    @State var textHeight: CGFloat = 0
    @State var authorHeight: CGFloat = 0
    @State var titleHeight: CGFloat = 0

    @Binding var showModal: Bool

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
            // Issue #17: Provides the user a choice of media types to use with their quote.
            // It is displayed in a segmented picker control
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
                .foregroundColor(.white)
                .frame(height: textFieldHeight)
                .shadow(radius: 5)
                .overlay(
                    ZStack {
                        DynamicHeightTextField(text: $text, height: $textHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(height: textFieldHeight)
                            .colorScheme(.light)
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
                            .colorScheme(.light)
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
                            .colorScheme(.light)
                        if author.isEmpty {
                            HStack {
                                // Issue #17: Changed Author to Content Creator to align with different media type
                                // options provided to the user
                                Text("Content Creator")
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
                if textFieldsAreNonEmpty {
                    self.addQuote()
                    self.showModal.toggle()
                } else {
                    self.showEmptyTextFieldAlert = true
                }
            }, label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .overlay(
                        Text("Save changes")
                            .foregroundColor(.black)
                )
            })
            .alert(isPresented: $showEmptyTextFieldAlert, content: {
                Alert(title: Text("Error Saving Quote"),
                      message: Text("Please ensure that all text fields are filled before saving."),
                      dismissButton: .default(Text("Ok")))
            })
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

        // Issue #17: Save the media type along with the quote in coredata
        quote.mediaType = self.mediaType.rawCoreDataValue()

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
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            AddQuoteUIKit(showModal: .constant(true))
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .light)
        }
    }
}
#endif
