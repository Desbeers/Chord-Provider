//
//  Views+Tags.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita

extension Views {

    /// The `View` for showing the tags of a song

    struct Tags: View {

        /// Init the `View`
        init(tags: [String.ElementWrapper]) {
            self.tags = tags
            self.orientation = tags.count > 2 ? .vertical : .horizontal
        }
        /// The tags
        let tags: [String.ElementWrapper]
        /// Orientation of the view
        let orientation: Orientation
        /// Bool to show the popup
        @State private var showPopover: Bool = false
        /// The body of the `View`
        var view: Body {
            switch orientation {
            case .horizontal:
                tagLabels()
            case .vertical:
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
        private func tagLabels() -> AnyView {
            ForEach(tags) { tag in
                Text(Utils.convertSimpleLinks(tag.content))
                    .useMarkup()
                    .style(orientation == .horizontal ? .tagLabel : .noStyle)
                    .padding(5)
            }
            .orientation(orientation)
        }
    }
}
