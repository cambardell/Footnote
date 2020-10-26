//
//  ContentView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  @Environment(\.managedObjectContext) var managedObjectContext

  //Controls translation of AddQuoteView
  @State private var offset: CGSize = .zero

    @ObservedObject var searchBar: SearchBar = SearchBar()

  @State var showAddQuoteView = false
  @State var showSettingsView = false
  //@State var showView: ContentViewModals = .addQuoteView

  // Onboarding via Sheet
  @State private var showOnboarding = false

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
      VStack {
        if !self.searchBar.text.isEmpty {
            FilteredList(filter: self.searchBar.text)
                .environment(\.managedObjectContext, self.managedObjectContext)
        } else {
            FilteredList()
              .environment(\.managedObjectContext, self.managedObjectContext)
                .add(self.searchBar)
    .listStyle(PlainListStyle())
    .sheet(isPresented: $showOnboarding) {
                    OnboardingView()
                }
    .accentColor(Color.footnoteRed)
    .onAppear(perform: checkForFirstTimeDownload)
    .navigationBarTitle("Footnote", displayMode: .inline)
    .navigationBarItems(leading:
                          Button(action: {
                            //self.showView = .settingsView
                            self.showSettingsView.toggle()
                          }, label: {
                            Image(systemName: "gear")
                                .accessibility(label: Text("Settings"))
                          })
        .sheet(isPresented: $showSettingsView) {
            SettingsView(showModal: $showSettingsView)
        },

                        trailing:
                          Button(action: {
                            //self.showView = .addQuoteView
                            self.showAddQuoteView.toggle()
                          }, label: {
                            Image(systemName: "plus")
                                .accessibility(label: Text("Add Quote"))
                          })
                            .sheet(isPresented: $showAddQuoteView) {
                                AddQuoteUIKit(showModal: $showAddQuoteView)
                                    .environment(\.managedObjectContext, self.managedObjectContext)
                            }
                        )
    

  }
      }
    }
  }

    // MARK: One-time onboarding on first time downloading

    /// Checks if the app is a first time download.
    func checkForFirstTimeDownload() {
        let launchKey = "didLaunchBefore"
        if !UserDefaults.standard.bool(forKey: launchKey) {
            UserDefaults.standard.set(true, forKey: launchKey)
            showOnboarding.toggle()
        } else {
            // For Debug Purposes Only
            print("App has launched more than one time")
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
    
    func widgetSync(){
        let quotesJSON = self.quotes.map({
            WidgetContent(date: $0.dateCreated ?? Date(), text: $0.text ?? "Default Text", title: $0.title ?? "Default Title", author: $0.author ?? "Default Author")
        })
        
        print("Syncing")
        
        guard let encodedData = try? JSONEncoder().encode(quotesJSON) else {
            print("Couldnt encode")
            return }
        
        print("encoded to UDs")
        print(encodedData)
        
        print(type(of: quotesJSON))
        UserDefaults(suiteName: AppGroup.appGroup.rawValue)!.set(encodedData, forKey: "WidgetContent")
    }
}

/// contentView modals
enum ContentViewModals {
  case addQuoteView
  case settingsView
}

// To preview with CoreData
#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    // swiftlint:disable:next force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    return Group {
      ContentView()
        .environment(\.managedObjectContext, context)
        .environment(\.colorScheme, .light)

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
    
    init() {
      fetchRequest = FetchRequest<Quote>(entity: Quote.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
      ])
    }
  
  var body: some View {
      List {
        ForEach(fetchRequest.wrappedValue, id: \.self) { quote in
          // Issue #17: Pass Media type to the detail view
          NavigationLink(destination: QuoteDetailView(text: quote.text ?? "",
                                                      title: quote.title ?? "",
                                                      author: quote.author ?? "",
                                                      mediaType: MediaType(rawValue: Int(quote.mediaType))
                                                        ?? MediaType.book,
                                                      quote: quote)) {
            QuoteItemView(quote: quote)
          }
        }.onDelete(perform: self.removeQuote)
      }
      .listStyle(PlainListStyle())
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
//
//  ContentView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  @Environment(\.managedObjectContext) var managedObjectContext

  //Controls translation of AddQuoteView
  @State private var offset: CGSize = .zero

    @ObservedObject var searchBar: SearchBar = SearchBar()

  @State var showAddQuoteView = false
  @State var showSettingsView = false
  //@State var showView: ContentViewModals = .addQuoteView

  // Onboarding via Sheet
  @State private var showOnboarding = false

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
      VStack {
        if !self.searchBar.text.isEmpty {
            FilteredList(filter: self.searchBar.text)
                .environment(\.managedObjectContext, self.managedObjectContext)
        } else {
            FilteredList()
              .environment(\.managedObjectContext, self.managedObjectContext)
                .add(self.searchBar)
    .listStyle(PlainListStyle())
    .sheet(isPresented: $showOnboarding) {
                    OnboardingView()
                }
    .accentColor(Color.footnoteRed)
    .onAppear(perform: checkForFirstTimeDownload)
    .navigationBarTitle("Footnote", displayMode: .inline)
    .navigationBarItems(leading:
                          Button(action: {
                            //self.showView = .settingsView
                            self.showSettingsView.toggle()
                          }, label: {
                            Image(systemName: "gear")
                                .accessibility(label: Text("Settings"))
                          })
        .sheet(isPresented: $showSettingsView) {
            SettingsView(showModal: $showSettingsView)
        },

                        trailing:
                          Button(action: {
                            //self.showView = .addQuoteView
                            self.showAddQuoteView.toggle()
                          }, label: {
                            Image(systemName: "plus")
                                .accessibility(label: Text("Add Quote"))
                          })
                            .sheet(isPresented: $showAddQuoteView) {
                                AddQuoteUIKit(showModal: $showAddQuoteView)
                                    .environment(\.managedObjectContext, self.managedObjectContext)
                            }
                        )
    

  }
      }
    }
  }

    // MARK: One-time onboarding on first time downloading

    /// Checks if the app is a first time download.
    func checkForFirstTimeDownload() {
        let launchKey = "didLaunchBefore"
        if !UserDefaults.standard.bool(forKey: launchKey) {
            UserDefaults.standard.set(true, forKey: launchKey)
            showOnboarding.toggle()
        } else {
            // For Debug Purposes Only
            print("App has launched more than one time")
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
    
    func widgetSync(){
        let quotesJSON = self.quotes.map({
            WidgetContent(date: $0.dateCreated ?? Date(), text: $0.text ?? "Default Text", title: $0.title ?? "Default Title", author: $0.author ?? "Default Author")
        })
        
        print("Syncing")
        
        guard let encodedData = try? JSONEncoder().encode(quotesJSON) else {
            print("Couldnt encode")
            return }
        
        print("encoded to UDs")
        print(encodedData)
        
        print(type(of: quotesJSON))
        UserDefaults(suiteName: AppGroup.appGroup.rawValue)!.set(encodedData, forKey: "WidgetContent")
    }
}

/// contentView modals
enum ContentViewModals {
  case addQuoteView
  case settingsView
}

// To preview with CoreData
#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    // swiftlint:disable:next force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    return Group {
      ContentView()
        .environment(\.managedObjectContext, context)
        .environment(\.colorScheme, .light)

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
    
    init() {
      fetchRequest = FetchRequest<Quote>(entity: Quote.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Quote.dateCreated, ascending: false)
      ])
    }
  
  var body: some View {
      List {
        ForEach(fetchRequest.wrappedValue, id: \.self) { quote in
          // Issue #17: Pass Media type to the detail view
          NavigationLink(destination: QuoteDetailView(text: quote.text ?? "",
                                                      title: quote.title ?? "",
                                                      author: quote.author ?? "",
                                                      mediaType: MediaType(rawValue: Int(quote.mediaType))
                                                        ?? MediaType.book,
                                                      quote: quote)) {
            QuoteItemView(quote: quote)
          }
        }.onDelete(perform: self.removeQuote)
      }
      .listStyle(PlainListStyle())
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
