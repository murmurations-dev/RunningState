//
//  ExplorationLiveActivity.swift
//  Exploration
//
//  Created by Etienne Vautherin on 26/02/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ExplorationLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ExplorationActivity.self) { context in
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

extension ExplorationActivity {
    fileprivate static var preview: ExplorationActivity {
        ExplorationActivity(name: "World")
    }
}

extension ExplorationActivity.ContentState {
    fileprivate static var smiley: ExplorationActivity.ContentState {
        ExplorationActivity.ContentState(emoji: "😀", runningState: .stopped)
     }
     
     fileprivate static var starEyes: ExplorationActivity.ContentState {
         ExplorationActivity.ContentState(emoji: "🤩", runningState: .stopped)
     }
}

#Preview("Notification", as: .content, using: ExplorationActivity.preview) {
   ExplorationLiveActivity()
} contentStates: {
    ExplorationActivity.ContentState.smiley
    ExplorationActivity.ContentState.starEyes
}
