//
//  ContentView.swift
//  Footnote
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    //Controls translation of AddQuoteView
    @State private var offset: CGSize = .zero
    @State var search = ""
    @State var showModal = false
    @State var showView: ContentViewModals = .addQuoteView

    @State private var refreshing = false
    private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    
    @FetchRequest(
        entity: Quote.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
        ]
    ) var quotes: FetchedResults<Quote>
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack {
                    TextField("Search", text: self.$search)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing, .top])
                    
                    
                    if self.search != "" {
                        FilteredList(filter: self.search).environment(\.managedObjectContext, self.managedObjectContext)
                    } else {
                        
                        List {
                            ForEach(self.quotes, id: \.self) { quote in
                                
                                NavigationLink(destination: QuoteDetailView(text: quote.text ?? "", title: quote.title ?? "", author: quote.author ?? "", quote: quote).environment(\.managedObjectContext, self.managedObjectContext)) {
                                    QuoteItemView(quote: quote)
                                }
                                .onReceive(self.didSave) { _ in
                                    self.refreshing.toggle()
                                    print("refresh")
                                }
                                
                            }.onDelete(perform: self.removeQuote)
                            
                        }.navigationBarTitle("Footnote", displayMode: .inline)
                            .navigationBarItems(leading: HStack {
                                Button(action: {
                                    self.showView = .contributorView
                                    self.showModal.toggle()
                                } ) {
                                    Image(systemName: "info")
                                }
                                },trailing: Button(action: {
                                    self.showView = .addQuoteView
                                self.showModal.toggle()
                            } ) {
                                Image(systemName: "plus")
                            } )
                    }
                }
            }
        }.accentColor(Color.footnoteRed)
            .sheet(isPresented: $showModal) {
                if self.showView == .addQuoteView {
                    AddQuoteUIKit().environment(\.managedObjectContext, self.managedObjectContext)
                } else {
                    ContributorsView()
                }
                
        }
    }
    
    func removeQuote(at offsets: IndexSet) {
        for index in offsets {
            let quote = quotes[index]
            managedObjectContext.delete(quote)
        }
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
}

enum ContentViewModals {
    case addQuoteView
    case contributorView
}

// To preview with CoreData
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            ContentView().environment(\.managedObjectContext, context).environment(\.colorScheme, .light)
            
        }
        
    }
}
#endif

struct FilteredList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showImageCreator = false
    var fetchRequest: FetchRequest<Quote>
    
    
    init(filter: String) {
        fetchRequest = FetchRequest<Quote>(entity: Quote.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
            ], predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: [
                    // [cd] = case and diacritic insensitive
                    NSPredicate(format: "text CONTAINS[cd] %@", filter),
                    NSPredicate(format: "author CONTAINS[cd] %@", filter),
                    NSPredicate(format: "title CONTAINS[cd] %@", filter)
                ]
        ))
    }
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(fetchRequest.wrappedValue, id: \.self) { quote in
                    NavigationLink(destination: QuoteDetailView(text: quote.text ?? "", title: quote.title ?? "", author: quote.author ?? "", quote: quote)) {
                        QuoteItemView(quote: quote)
                    }
                }.onDelete(perform: self.removeQuote)
            }
        }.navigationBarTitle("")
            .navigationBarHidden(true)
    }
    
    func removeQuote(at offsets: IndexSet) {
        for index in offsets {
            let quote = fetchRequest.wrappedValue[index]
            managedObjectContext.delete(quote)
        }
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
}
