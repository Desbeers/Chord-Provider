//
//  Extensions.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita
import CAdw
import CGtkSourceView

extension LogUtils.Level {

    var style: (color: String, icon: String) {
        switch self {            
        case .info:
            ("#ffffff", "dialog-information-symbolic")
        case .notice:
            ("#1a5fb4", "view-reveal-symbolic")
        case .warning:
            ("#e5a50a", "dialog-warning-symbolic")
        case .error:
            ("#e01b24", "dialog-error-symbolic")
        }
    }
}

extension ViewStorage {

    /// The pointer to the text buffer
    var textBufferPointer: UnsafeMutablePointer<GtkTextBuffer>? {
        opaquePointer?.cast()
    }

    /// The pointer to the text view
    var textViewPointer: UnsafeMutablePointer<GtkTextView>? {
        opaquePointer?.cast()
    }

    /// The pointer to the source buffer
    var sourceBufferPointer: UnsafeMutablePointer<GtkSourceBuffer>? {
        opaquePointer?.cast()
    }

    /// The pointer to the source view
    var sourceViewPointer: UnsafeMutablePointer<GtkSourceView>? {
        opaquePointer?.cast()
    }

    /// The pointer to the widget
    var widgetPointer: UnsafeMutablePointer<GtkWidget>? {
        opaquePointer?.cast()
    }

    /// The pointer to the search settings
    var searchSettingsPointer: UnsafeMutablePointer<GtkSourceSearchSettings>? {
        opaquePointer?.cast()
    }
}

extension GtkTextIter: @unchecked @retroactive Sendable {}
