//
//  SourceViewSchemePicker.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView

/// A picker with editor schemes.
public struct SourceViewSchemePicker: View {

    /// All the schemes.
    @State var schemeIDs: [SchemeWrapper]
    /// The controller
    let controller: SourceViewController
    /// Init the `View`
    public init(controller: SourceViewController) {
        let schemes = SourceViewController.schemeIDs.map {item in
            SchemeWrapper(scheme: item)
        }
        self._schemeIDs = State(wrappedValue: schemes)
        self.controller = controller
    }
    /// The main `View`
    public var view: Body {
        WrapBox(schemeIDs) { item in
            SourceViewSchemePreview(
                id: item.scheme,
                selected: item.scheme == controller.scheme.wrappedValue
            )
            .onClick {
                controller.scheme.wrappedValue = item.scheme
            }
        }
        .inspectOnAppear { storage in
            storage.notify(name: "dark", pointer: adw_style_manager_get_default()) {
                schemeIDs = SourceViewController.schemeIDs.map {item in
                    SchemeWrapper(scheme: item)
                }
            }
        }
    }

    /// Make a String Identifiable.
    struct SchemeWrapper: Identifiable {

        /// Identifiable protocol.
        var id: String { scheme }
        /// The name of the scheme.
        var scheme: String
    }
}
