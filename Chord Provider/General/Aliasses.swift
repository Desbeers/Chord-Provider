//
//  Aliasses.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

#if os(macOS)
typealias SWIFTImage = NSImage
typealias SWIFTTextView = NSTextView
#else
typealias SWIFTImage = UIImage
typealias SWIFTTextView = UITextView
#endif

extension Image {

    init(swiftImage: SWIFTImage) {
        #if os(macOS)
        self.init(nsImage: swiftImage)
        #endif
        #if os(iOS)
        self.init(uiImage: swiftImage)
        #endif
    }
}
