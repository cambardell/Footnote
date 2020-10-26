//
//  SuggestionsView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2020-08-29.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct SuggestionsView: View {

    @ObservedObject var fetcher: BookFetcher

    init(searchString: String) {
        fetcher = BookFetcher(searchString: searchString)
    }

    var body: some View {
        VStack {
            HStack {
                Text("See Me")
                    .colorScheme(.light)
                VStack {
                    ForEach(fetcher.books, id: \.self) { book in
                        Text(book.title)
                            .colorScheme(.light)
                    }
                }
            }
        }.background(Color.white)
    }
}

struct SuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsView(searchString: "The Golem and the Jinni")
    }
}

public class BookFetcher: ObservableObject {

    @Published var books = [Book]()

    init(searchString: String) {
        load(searchString: searchString)
    }

    func load(searchString: String) {
        let queryItems = [URLQueryItem(name: "q", value: searchString), URLQueryItem(name: "page", value: "1")]
        var urlComps = URLComponents(string: "https://openlibrary.org/search.json")!
        urlComps.queryItems = queryItems
        let result = urlComps.url!

        URLSession.shared.dataTask(with: result) {(data, _, _) in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Books.self, from: data) {
                    DispatchQueue.main.async {
                        print(decodedResponse.allBooks)
                        self.books = decodedResponse.allBooks
                    }
                    return
                }
            }

        }.resume()

    }
}

struct Book: Decodable, Hashable {

    let title: String
    let authorNames: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case authorNames = "author_name"
    }
}

struct Books: Decodable {
    let numFound: Int
    let allBooks: [Book]

    enum CodingKeys: String, CodingKey {
        case numFound
        case allBooks = "docs"
    }
}
