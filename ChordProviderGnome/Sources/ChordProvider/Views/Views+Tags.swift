//
//  Views+Tags.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

extension Views {

    /// The `View` for showing the tags of a song
    struct Tags: View {
        /// Init the `View`
        init(tags: [String.ElementWrapper]) {
            self.tags = tags
            self.horizontal = tags.count > 2 ? false : true
        }
        /// The tags
        let tags: [String.ElementWrapper]
        /// Horizontal view
        let horizontal: Bool
        /// Bool to show the popup
        @State private var showPopover: Bool = false
        /// The body of the `View`
        var view: Body {
            switch horizontal {
                case true:
                tagLabels()
            case false :
                Text("Tags…")
                    .style(.tagButton)
                    .padding(5)
                    .onClick {
                        showPopover.toggle()
                    }
                    .popover(visible: $showPopover) {
                       tagLabels()
                    }
            }
        }
        /// Show a list of tags
        @ViewBuilder private func tagLabels() -> Body {
            ForEach(tags, horizontal: horizontal) { tag in
                Text(tag.content)
                    .useMarkup()
                    .style(horizontal ? .tagLabel : .none)
                    .padding(5)
            }
        }
    }
}
