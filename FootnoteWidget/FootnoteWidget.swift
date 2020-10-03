//
//  FootnoteWidget.swift
//  FootnoteWidget
//
//  Created by Japneet Singh on /410/20.
//  Copyright © 2020 Cameron Bardell. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct FootnoteWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        if widgetFamily == .systemSmall {
                    SmallWidgetView()
        } else if widgetFamily == .systemMedium {
            MediumWidgetView()
        }
        else{
            LargeWidgetView()
        }
    }
}

@main
struct FootnoteWidget: Widget {
    let kind: String = "FootnoteWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FootnoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quote")
        .description("Add your favourite quotes directly to the homescreen.")
    }
}

struct FootnoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        FootnoteWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        FootnoteWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        FootnoteWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct SmallWidgetView: View {
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("Weight")
                    .font(.body)
                    .foregroundColor(.purple)
                    .bold()
                Spacer()
                Text("Weight Check")
                    .font(.title)
                    .foregroundColor(.purple)
                    .bold()
                    .minimumScaleFactor(0.5)
                    }
                    Spacer()
                }
                .padding(.all, 8)
                .background(ContainerRelativeShape().fill(Color(.cyan)))
    }
}

struct MediumWidgetView: View {
    var body: some View {
        Text("This is a medium or large widget")
    }
}

struct LargeWidgetView: View {
    var body: some View {
        Text("This is a large widget!")
    }
}
