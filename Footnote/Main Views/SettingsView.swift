//
//  SettingsView.swift
//  Footnote
//
//  Created by Cameron Bardell on 2020-10-03.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI
import UIKit
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var showModal: Bool
    @State var jsonData: String = ""
    @FetchRequest(
      entity: Quote.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
      ]
    )
    var quotes: FetchedResults<Quote>
    struct Packet: Codable {
      var author: String
      var text: String
      var title: String
    }

    func jsonRender() {
        // Initialize State
        var packets = [Packet]()
        var jsonStringRender: String = ""
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Quote", in: managedObjectContext )
        // Create Context
        fetchRequest.entity = entityDescription
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest)
            let items = result
            for item in items {
                guard let author = (item as AnyObject).value(forKey: "author") as? String else { return }
                guard let text = (item as AnyObject).value(forKey: "text") as? String else { return }
                guard let title = (item as AnyObject).value(forKey: "title") as? String else { return }
                let packet = Packet(author: author, text: text, title: title )
                packets.append(packet)
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted // if necessary
                let data = try encoder.encode(packets)
                let jsonString = String(data: data, encoding: .utf8)!
                jsonStringRender = jsonString
            }
            self.jsonData = jsonStringRender
            //print("packets: \(self.jsonData)")
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    var body: some View {
      HStack(alignment: .center) {
        Image(systemName: "gear")
            .renderingMode(.original)
            .resizable()
            .cornerRadius(20)
            .frame(width: 60, height: 60)
            .clipped()
            .aspectRatio(contentMode: .fit)

        VStack(alignment: .leading, spacing: nil/*@END_MENU_TOKEN@*/, content: {
            Text("Footnote - IOS SwiftUI Open-Source Application developed during Hacktoberfest 2020.")
                .font(.system(size: 18))
                .lineLimit(nil)
            Button("Export Quotes as JSON") {
                let _: () = self.jsonRender()
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            Text("\(jsonData)" as String)
        })
      }.padding()
    }
}

// To preview with CoreData
#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            SettingsView(showModal: .constant(true))
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .light)
        }

    }
}
#endif
