//
//  Aliasses.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

#if os(macOS)
/// Alias for NSImage
typealias SWIFTImage = NSImage
/// Alias for NSTextView
typealias SWIFTTextView = NSTextView
#else
/// Alias for UIImage
typealias SWIFTImage = UIImage
/// Alias for UITextView
typealias SWIFTTextView = UITextView
#endif

extension Image {

    /// Init an Image with an SWIFTImage alias
    /// - Parameter swiftImage: The NSImage or UIImage
    init(swiftImage: SWIFTImage) {
        #if os(macOS)
        self.init(nsImage: swiftImage)
        #endif
        #if os(iOS)
        self.init(uiImage: swiftImage)
        #endif
    }
}
