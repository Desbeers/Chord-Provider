//
//  Widgets+Columns.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita
import CAdw

extension Widgets {

    /// The `AdwaitaWidget` for wrapping the song in columns
    public struct Columns<Element>: AdwaitaWidget where Element: Identifiable {

        /// Additional update functions for type extensions.
        var updateFunctions: [(ViewStorage, WidgetData, Bool) -> Void] = []
        /// Additional appear functions for type extensions.
        var appearFunctions: [(ViewStorage, WidgetData) -> Void] = []
        /// The dynamic widget elements.
        var elements: [Element]
        /// The dynamic widget content.
        var content: (Element) -> Body

        /// Initialize `WrapBox`.
        public init(_ elements: [Element], @ViewBuilder content: @escaping (Element) -> Body) {
            self.elements = elements
            self.content = content
        }

        /// The view storage.
        /// - Parameters:
        ///     - modifiers: Modify views before being updated.
        ///     - type: The view render data type.
        /// - Returns: The view storage.
        public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
            let storage = ViewStorage(adw_wrap_box_new()?.opaque())
            gtk_orientable_set_orientation(storage.opaquePointer, GTK_ORIENTATION_VERTICAL)
            adw_wrap_box_set_line_spacing(storage.opaquePointer, 20)
            for function in appearFunctions {
                function(storage, data)
            }
            update(storage, data: data, updateProperties: true, type: type)

            return storage
        }

        /// Update the stored content.
        /// - Parameters:
        ///     - storage: The storage to update.
        ///     - modifiers: Modify views before being updated
        ///     - updateProperties: Whether to update the view's properties.
        ///     - type: The view render data type.
        public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) where Data: ViewRenderData {
            storage.modify { widget in
                var contentStorage: [ViewStorage] = storage.content[.mainContent] ?? []
                let old = storage.fields["element"] as? [Element] ?? []
                old.identifiableTransform(
                    to: elements,
                    functions: .init { index in
                        let item = contentStorage[index].opaquePointer
                        adw_wrap_box_remove(widget, item?.cast())
                        contentStorage.remove(at: index)
                    } insert: { index, element in
                        /// The optional previous element
                        let previous = contentStorage[safe: index - 1]
                        /// The child to insert
                        let child = content(element).storage(data: data, type: type)
                        adw_wrap_box_insert_child_after(
                            widget,
                            child.opaquePointer?.cast(),
                            previous?.opaquePointer?.cast()
                        )
                        contentStorage.insert(child, at: index)
                    }
                )
                storage.fields["element"] = elements
                storage.content[.mainContent] = contentStorage
                for (index, element) in elements.enumerated() {
                    content(element).updateStorage(contentStorage[index], data: data, updateProperties: updateProperties, type: type)
                }
            }
            for function in updateFunctions {
                function(storage, data, updateProperties)
            }
            if updateProperties {
                storage.previousState = self
            }
        }
    }
}
