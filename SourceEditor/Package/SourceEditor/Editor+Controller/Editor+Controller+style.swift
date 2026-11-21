//

//  Editor+Controller+style.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView

extension Editor.Controller {

    /// Init the editor style.
    func initStyle(resources: URL?) {
        let manager = gtk_source_style_scheme_manager_get_default()
        gtk_source_style_scheme_manager_append_search_path(manager, Self.resourcesURL.path)
        if let resources {
            gtk_source_style_scheme_manager_append_search_path(manager, resources.path)
        }
    }

    /// Update the editor style.
    func updateStyle() {
        let gtkStyleManager = gtk_source_style_scheme_manager_get_default()
        let style = gtk_source_style_scheme_manager_get_scheme(gtkStyleManager, scheme.wrappedValue.id)
        gtk_source_buffer_set_style_scheme(buffer.sourceBufferPointer, style)
        setMarksStyle()
        bridge.styleInfo.wrappedValue = allStyleInfo(scheme: nil)
        onSchemeChanged?()
    }

    /// The scheme IDs that fit the current appearance.
    /// - Parameter customOnly: Only return schemes loaded from the custom directory.
    /// - Returns: The scheme IDs.
    func schemeIDs(customOnly: Bool) -> [String] {
        let dark = Self.darkMode
        // The directory with the custom schemes
        let customPath = resources?.path
        let manager = gtk_source_style_scheme_manager_get_default()
        var result: [String] = []
        guard let ids = gtk_source_style_scheme_manager_get_scheme_ids(manager) else {
            return result
        }
        var index = 0
        while let id = ids[index] {
            let name = String(cString: id)
            index += 1
            guard let styleScheme = gtk_source_style_scheme_manager_get_scheme(manager, name) else { continue }
            // Optionally keep only schemes loaded from the custom directory.
            if customOnly, let customPath {
                guard let file = gtk_source_style_scheme_get_filename(styleScheme),
                      String(cString: file).hasPrefix(customPath)
                else { continue }
            }
            let variant = gtk_source_style_scheme_get_metadata(styleScheme, "variant").map { String(cString: $0) }
            if (variant == "dark") == dark {
                result.append(name)
            }
        }
        return result
    }

    /// The ID of the scheme that is actually applied to the buffer.
    func activeSchemeID() -> String? {
        gtk_source_buffer_get_style_scheme(buffer.sourceBufferPointer)
            .flatMap { gtk_source_style_scheme_get_id($0) }
            .map { String(cString: $0) }
    }

    /// The scheme ID that fits the current appearance mode.
    /// - Returns: The partner ID for the mode, or `id` itself if it has none.
    var modeSchemeID: Editor.Scheme {
        let id = scheme.wrappedValue.id
        let manager = gtk_source_style_scheme_manager_get_default()
        guard let styleScheme = gtk_source_style_scheme_manager_get_scheme(manager, id) else {
            return .init(id)
        }
        let key = Self.darkMode ? "dark-variant" : "light-variant"
        guard let partner = gtk_source_style_scheme_get_metadata(styleScheme, key).map({ String(cString: $0) }),
              gtk_source_style_scheme_manager_get_scheme(manager, partner) != nil
        else { return .init(id) }
        return .init(partner)
    }

    /// Bool if the current style is dark.
    static var darkMode: Bool {
        adw_style_manager_get_dark(adw_style_manager_get_default()) != 0
    }
}

extension Editor.Controller {

    /// Get all the attributes of a style ID.
    /// - Parameters:
    ///   - styleID: The style ID, for example `chordpro:chord-render`.
    ///   - scheme: The scheme ID; optional, defaults to the current scheme.
    ///   - fallbackID: The style ID to look up instead; used internally when `styleID` is not defined.
    /// - Returns: The style info, or nil if the style is not found.
    func styleInfo(
        styleID: Editor.StyleID,
        scheme: Editor.Scheme?,
        fallbackID: Editor.StyleID?
    ) -> Editor.StyleInfo? {
        let schemeID = scheme?.id ?? self.scheme.wrappedValue.id
        let manager = gtk_source_style_scheme_manager_get_default()
        let id = fallbackID ?? styleID
        guard let schemePointer = gtk_source_style_scheme_manager_get_scheme(manager, schemeID),
              let style = gtk_source_style_scheme_get_style(schemePointer, id.rawValue)
        else {
            if let fallback = styleColorFallback(id) {
                return styleInfo(styleID: styleID, scheme: scheme, fallbackID: fallback)
            }
            return nil
        }
        let object = UnsafeMutableRawPointer(style).assumingMemoryBound(to: GObject.self)

        /// A string property, only if its `-set` flag is true.
        func string(_ name: String) -> String? {
            boolProperty(object, "\(name)-set") ? stringProperty(object, name) : nil
        }
        /// A bool property, only if its `-set` flag is true.
        func bool(_ name: String) -> Bool {
            boolProperty(object, "\(name)-set") ? boolProperty(object, name) : false
        }

        return Editor.StyleInfo(
            id: styleID,
            fallback: fallbackID,
            foreground: Color(hex: string("foreground"))?.gdkRGBA ?? Color(.foreground).gdkRGBA,
            background: Color(hex: string("background"))?.gdkRGBA ?? GdkRGBA(),
            lineBackground: string("line-background") ?? "transparent",
            underlineColor: string("underline-color"),
            bold: bool("bold"),
            italic: bool("italic"),
            strikethrough: bool("strikethrough"),
            scale: string("scale")
        )
    }

    /// Get an optional fallback Style ID if the original was not found.
    /// - Parameter styleID: The original Style ID.
    /// - Returns: A fallback, if found. Else nil.
    private func styleColorFallback(_ styleID: Editor.StyleID) -> Editor.StyleID? {
        guard
            let language = gtk_source_buffer_get_language(buffer.sourceBufferPointer) ?? defaultLanguage(),
            let fallback = gtk_source_language_get_style_fallback(language, styleID.rawValue),
            let id = Editor.StyleID(rawValue: String(cString: fallback))
        else {
            return nil
        }
        return id
    }

    /// All styles of a scheme that are listed in `StyleID`.
    /// - Parameter scheme: The scheme; optional, defaults to the current scheme.
    /// - Returns: The style IDs with their info. Styles that the scheme does not define are skipped.
    func allStyleInfo(scheme: Editor.Scheme?) -> [Editor.StyleInfo] {
        Editor.StyleID.allCases.compactMap { styleID in
            styleInfo(styleID: styleID, scheme: scheme, fallbackID: nil)
        }
    }
}

extension Editor.Controller {

    /// Get the display name of a style scheme.
    /// - Parameter id: The scheme ID.
    /// - Returns: The scheme name, or `nil` if the ID is unknown.
    func schemeName(for id: String) -> String? {
        let manager = gtk_source_style_scheme_manager_get_default()
        guard let scheme = gtk_source_style_scheme_manager_get_scheme(manager, id),
              let cName = gtk_source_style_scheme_get_name(scheme) else {
            return nil
        }
        let name = String(cString: cName)
        let base = name.replacing(/[\s\-_]*(light|dark)$/.ignoresCase(), with: "")
        return base.isEmpty ? name : base
    }
}
