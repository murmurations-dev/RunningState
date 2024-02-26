//
//  ExplorationLiveActivity.swift
//  Exploration
//
//  Created by Etienne Vautherin on 26/02/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ExplorationAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
        var runningState: Running.State
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ExplorationLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ExplorationAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ExplorationAttributes {
    fileprivate static var preview: ExplorationAttributes {
        ExplorationAttributes(name: "World")
    }
}

extension ExplorationAttributes.ContentState {
    fileprivate static var smiley: ExplorationAttributes.ContentState {
        ExplorationAttributes.ContentState(emoji: "😀", runningState: .stopped)
     }
     
     fileprivate static var starEyes: ExplorationAttributes.ContentState {
         ExplorationAttributes.ContentState(emoji: "🤩", runningState: .stopped)
     }
}

#Preview("Notification", as: .content, using: ExplorationAttributes.preview) {
   ExplorationLiveActivity()
} contentStates: {
    ExplorationAttributes.ContentState.smiley
    ExplorationAttributes.ContentState.starEyes
}
