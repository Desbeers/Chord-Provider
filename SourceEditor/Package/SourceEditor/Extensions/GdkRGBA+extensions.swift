//
//  GdkRGBA+Extensions.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import CAdw

extension GdkRGBA {

    /// The `GdkRGBA` as an `Editor.Color`.
    var color: Editor.Color {
        Editor.Color(self)
    }
}
