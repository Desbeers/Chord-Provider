//
//  GtkRender+ImageSection.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension GtkRender {

    /// The `View` for an image section
    struct ImageSection: View {
        /// Init the `View`
        /// - Parameters:
        ///   - section: The image section
        ///   - settings: The core settings
        init(section: Song.Section, settings: ChordProviderSettings) {
            self.halign = Utils.getTextAlignment(section.arguments)
            let fileURL = settings.fileURL == nil ? settings.templateURL : settings.fileURL
            if
                let url = ChordProParser.getImageURL(
                    section.arguments?[.src] ?? "",
                    fileURL: fileURL
                ),
                let data = try? Data(contentsOf: url) {
                self.data = data
                if let size = ImageUtils.getImageSize(data: data) {
                    self.size = ImageUtils.getImageSizeFromArguments(size: size, arguments: section.arguments)
                }
            }
        }
        /// The optional data of the image
        var data: Data?
        /// The optional size of the image
        var size: CGSize?
        /// The horizontal alignment of the image
        let halign: Alignment
        /// The body of the `View`
        var view: Body {
            VStack {
                if let data, let size {
                    Picture()
                        .data(data)
                        .card()
                        .frame(minHeight: Int(size.height))
                        .frame(maxHeight: Int(size.height))
                        .frame(minWidth: Int(size.width))
                        .frame(maxWidth: Int(size.width))
                        .halign(halign)
                } else {
                    Text("Image not loaded")
                }
            }
            .padding(10)
        }
    }
}
