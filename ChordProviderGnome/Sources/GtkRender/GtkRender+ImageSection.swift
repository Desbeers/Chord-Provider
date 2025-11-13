//
//  GtkRender+ImageSection.swift
//  ChordProviderGnome
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
        init(section: Song.Section, settings: AppSettings) {
            self.section = section
            self.settings = settings
            self.halign = Utils.getAlign(section.arguments)
            let fileURL = settings.core.fileURL == nil ? settings.core.templateURL : settings.core.fileURL
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
        /// The current section of the song
        let section: Song.Section
        /// The settings of the application
        let settings: AppSettings
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
