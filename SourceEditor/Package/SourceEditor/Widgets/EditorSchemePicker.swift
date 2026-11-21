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
    @State var schemes: [Editor.Scheme]
    /// The controller.
    let controller: Editor.Controller
    /// Only custom schemes.
    let customOnly: Bool

    /// Init the `View`.
    /// - Parameters:
    ///   - controller: The controller of the editor.
    ///   - customOnly: Only show the schemes from the custom directory.
    public init(controller: Editor.Controller, customOnly: Bool) {
        self._schemes = State(wrappedValue: Self.schemes(controller: controller, customOnly: customOnly))
        self.controller = controller
        self.customOnly = customOnly
    }

    /// The main `View`.
    public var view: Body {
        WrapBox(schemes) { scheme in
            VStack {
                Text(scheme.display)
                    .caption()
                    .dimLabel()
                    .padding(.top)
                EditorSchemePreview(
                    scheme: scheme,
                    selected: scheme == controller.scheme.wrappedValue
                )
            }
            .onClick {
                controller.scheme.wrappedValue = scheme
                // Apply directly.
                controller.updateStyle()
            }
        }
        .inspectOnAppear { storage in
            storage.notify(name: "dark", pointer: adw_style_manager_get_default()) {
                schemes = Self.schemes(controller: controller, customOnly: customOnly)
            }
        }
    }

    /// The schemes that fit the current appearance.
    /// - Parameters:
    ///   - controller: The controller of the editor.
    ///   - customOnly: Only return the schemes from the custom directory.
    /// - Returns: The schemes, wrapped to be `Identifiable`.
    private static func schemes(controller: Editor.Controller, customOnly: Bool) -> [Editor.Scheme] {
        controller.schemeIDs(customOnly: customOnly).map { item in
            .init(item)
        }
    }
}
