//
//  Image+Extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension Image {

    /// Init an Image with an SWIFTImage alias (NSImage or UIImage)
    /// - Parameter swiftImage: The NSImage or UIImage
    init(swiftImage: SWIFTImage) {
#if os(macOS)
        self.init(nsImage: swiftImage)
#else
        self.init(uiImage: swiftImage)
#endif
    }
}
