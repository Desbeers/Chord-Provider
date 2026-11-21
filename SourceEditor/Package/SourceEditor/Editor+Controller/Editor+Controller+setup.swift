//
//  Editor+Controller+setup.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView

extension Editor.Controller {

    /// Setup the controller.
    /// - Parameters:
    ///   - bridge: The bridge binding.
    ///   - scheme: The scheme to use.
    ///   - storage: The View Storage
    ///   - onNew: The callback when a new file is created.
    ///   - onOpen: The callback when a file is opened.
    ///   - onSave: The callback when a file is saved.
    ///   - onSchemeChanged: The callback when the scheme has changed.
    ///
    /// Use this function if the first `View` of the application does not
    /// contain the editor and you already want the scheme available.
    public func setup(
        bridge: Binding<Editor.Bridge>,
        scheme: Binding<Editor.Scheme>,
        storage: ViewStorage,
        onNew: (() -> Void)? = nil,
        onOpen: ((Result<URL, Error>) -> Void)? = nil,
        onSave: ((Result<URL, Error>) -> Void)? = nil,
        onSchemeChanged: (() -> Void)? = nil
    ) {
        self.scheme = scheme
        self.bridge = bridge.onSet { [self] bridge in
            if currentSearchText != bridge.search.search {
                setSearchText(bridge.search.search)
            }
            gtk_source_search_context_set_highlight(
                searchContext.opaquePointer,
                bridge.showSearchBar.cBool
            )
        }
        self.bridge.styleInfo.wrappedValue = allStyleInfo(scheme: nil)
        self.onNew = onNew
        self.onOpen = onOpen
        self.onSave = onSave
        self.onSchemeChanged = onSchemeChanged
        storage.notify(name: "dark", pointer: adw_style_manager_get_default()) { [self] in
            scheme.wrappedValue = modeSchemeID
            updateStyle()
        }
        storage.notify(name: "accent-color", pointer: adw_style_manager_get_default()) { [self] in
            updateStyle()
        }
        buffer.notify(name: "style-scheme") { [self] in
            scheme.wrappedValue = modeSchemeID
            updateStyle()
        }
        // Make sure the scheme is ready.
        updateStyle()
    }
}
