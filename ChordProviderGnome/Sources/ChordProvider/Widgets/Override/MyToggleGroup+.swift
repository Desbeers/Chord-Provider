//
//  ToggleGroup+.swift
//  Adwaita
//
//  Created by david-swift on 03.11.25.
//

import Adwaita
import CAdw
import LevenshteinTransformations

extension Widgets.MyToggleGroup {

    /// The identifier for the values.
    static var values: String { "values" }
    /// The identifier for the toggles.
    static var toggle: String { "Toggle::" }

    /// Initialize a toggle group.
    /// - Parameters:
    ///     - selection: The selected value.
    ///     - values: The available values.
    public init<Element>(
        selection: Binding<Element.ID>,
        values: [Element]
    ) where Element: ToggleGroupItem, Element: CustomStringConvertible {
        self.init()
        appearFunctions.append { storage, _ in
            storage.notify(name: "active-name", id: "init") {
                if let name = adw_toggle_group_get_active_name(storage.opaquePointer),
                let values = storage.fields[Self.values] as? [Element],
                let value = values.first(where: { $0.id.description == String(cString: name) }) {
                    selection.wrappedValue = value.id
                }
            }
            Self.updateContent(
                storage: storage,
                selection: selection.wrappedValue,
                values: values,
                updateProperties: true
            )
        }
        updateFunctions.append { storage, _, updateProperties in
            Self.updateContent(
                storage: storage,
                selection: selection.wrappedValue,
                values: values,
                updateProperties: updateProperties
            )
        }
    }

    /// Update the combo row's content.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - values: The elements.
    ///     - updateProperties: Whether to update the properties.
    static func updateContent<Element>(
        storage: ViewStorage,
        selection: Element.ID,
        values: [Element],
        updateProperties: Bool
    ) where Element: ToggleGroupItem, Element: CustomStringConvertible {
        guard updateProperties else {
            return
        }
        let old = storage.fields[Self.values] as? [Element] ?? []
        old.identifiableTransform(
            to: values,
            functions: .init { index in
                if let id = old[safe: index]?.id.description,
                let toggle = storage.fields[Self.toggle + id] as? OpaquePointer {
                    adw_toggle_group_remove(storage.opaquePointer, toggle)
                }
            } insert: { _, element in
                let toggle = adw_toggle_new()
                adw_toggle_set_name(toggle, element.id.description)
                if element.showLabel, element.icon == nil {
                    adw_toggle_set_label(toggle, element.description)
                }
                adw_toggle_set_tooltip(toggle, element.description)
                if let icon = element.icon {
                    adw_toggle_set_icon_name(toggle, icon.string)
                }
                storage.fields[Self.toggle + element.id.description] = toggle
                adw_toggle_group_add(storage.opaquePointer, toggle)
            }
        )
        storage.fields[Self.values] = values
        adw_toggle_group_set_active_name(storage.opaquePointer, selection.description)
    }
}
