//
//  Markup.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import CChordProvider
import CAdw

/// Markup of the application
enum Markup {
    // Just a placeholder
}

extension Markup {
    
    /// Init the css style
    /// - Parameter appState: The state of the application
    static func initStyle(appState: AppState) {
        appState.styleState.pointee.editor_font_size = Int32(appState.settings.editor.fontSize.rawValue)
        appState.styleState.pointee.zoom = appState.settings.app.zoom
        set_style(appState.styleState)
    }
    
    /// Update the css style
    /// - Parameters:
    ///   - zoom: Zoom factor
    ///   - dark: Bool if in dark mode
    ///   - editorFontSize: The font-size for the editor
    static func updateStyle(zoom: Double, dark: Bool, editorFontSize: Int) {
        let css = Markup.css(
            zoom: zoom,
            dark: dark,
            editorFontSize: editorFontSize
        )
        css.withCString { cString in
            add_css_from_string(cString)
        }
    }
}

/// Update the css style after a change from light to dark or visa versa
@_cdecl("update_style")
public func update_style(
    _ settings: UnsafeMutablePointer<GObject>?,
    _ pspec: UnsafeMutablePointer<GParamSpec>?,
    _ userData: UnsafeMutableRawPointer?
) {
    guard let userData
    else { return }

    let state = userData.bindMemory(
        to: stylestate.self,
        capacity: 1
    )
    Markup.updateStyle(
        zoom: state.pointee.zoom,
        dark: app_prefers_dark_theme() == 1 ? true : false,
        editorFontSize: Int(state.pointee.editor_font_size)
    )
}
