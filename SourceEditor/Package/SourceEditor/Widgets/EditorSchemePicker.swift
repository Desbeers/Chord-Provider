//
//  EditorSchemePicker.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Adwaita
import CAdw

/// A picker with editor schemes.
public struct EditorSchemePicker: View {

    /// All the schemes.
    @State var schemeIDs: [SchemeWrapper]
    /// The controller.
    let controller: Editor.Controller
    /// Only custom schemes.
    let customOnly: Bool

    /// Init the `View`.
    /// - Parameters:
    ///   - controller: The controller of the editor.
    ///   - customOnly: Only show the schemes from the custom directory.
    public init(controller: Editor.Controller, customOnly: Bool) {
        self._schemeIDs = State(wrappedValue: Self.schemes(controller: controller, customOnly: customOnly))
        self.controller = controller
        self.customOnly = customOnly
    }

    /// The main `View`.
    public var view: Body {
        WrapBox(schemeIDs) { item in
            VStack {
                Text(controller.schemeName(for: item.id) ?? "ERROR")
                    .dimLabel()
                    .padding(.vertical)
                EditorSchemePreview(
                    id: item.scheme,
                    selected: item.scheme == controller.scheme.wrappedValue
                )
            }
            .onClick {
                controller.scheme.wrappedValue = item.scheme
                // Apply directly: the picker must also work without a `SourceView`,
                // so there is no `update` to do it.
                controller.updateStyle()
            }
        }
        .inspectOnAppear { storage in
            storage.notify(name: "dark", pointer: adw_style_manager_get_default()) {
                schemeIDs = Self.schemes(controller: controller, customOnly: customOnly)
            }
        }
    }

    private func schemeName(_ name: String) -> String {
        let base = name.replacing(/[\s\-_]*(light|dark)$/.ignoresCase(), with: "")
        return base.isEmpty ? name : base
    }

    /// The schemes that fit the current appearance.
    /// - Parameters:
    ///   - controller: The controller of the editor.
    ///   - customOnly: Only return the schemes from the custom directory.
    /// - Returns: The schemes, wrapped to be `Identifiable`.
    private static func schemes(controller: Editor.Controller, customOnly: Bool) -> [SchemeWrapper] {
        controller.schemeIDs(customOnly: customOnly).map { item in
            SchemeWrapper(scheme: item)
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
