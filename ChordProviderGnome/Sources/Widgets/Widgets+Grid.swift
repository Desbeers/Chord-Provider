//
//  Widgets+Grid.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita
import CAdw
import LevenshteinTransformations

extension Widgets {
    /// A dynamic list but without a list design in the user interface.
    public struct Grid<Element>: AdwaitaWidget where Element: Identifiable {

        /// The dynamic widget elements.
        var elements: [Element]
        /// The dynamic widget content.
        var content: (Element) -> Body
        /// Whether the list is horizontal.
        var horizontal: Bool
        /// Whether the children should all be the same size.
        var homogeneous: Bool?

        /// Initialize `ForEach`.
        public init(_ elements: [Element], horizontal: Bool = false, @ViewBuilder content: @escaping (Element) -> Body) {
            self.elements = elements
            self.content = content
            self.horizontal = horizontal
        }

        /// The view storage.
        /// - Parameters:
        ///     - modifiers: Modify views before being updated.
        ///     - type: The view render data type.
        /// - Returns: The view storage.
        public func container<Data>(
            data: WidgetData,
            type: Data.Type
        ) -> ViewStorage where Data: ViewRenderData {
            let storage = ViewStorage(
                gtk_box_new(horizontal ? GTK_ORIENTATION_HORIZONTAL : GTK_ORIENTATION_VERTICAL, 0)?.opaque()
            )
            update(storage, data: data, updateProperties: true, type: type)
            return storage
        }

        /// Update the stored content.
        /// - Parameters:
        ///     - storage: The storage to update.
        ///     - modifiers: Modify views before being updated
        ///     - updateProperties: Whether to update the view's properties.
        ///     - type: The view render data type.
        public func update<Data>(
            _ storage: ViewStorage,
            data: WidgetData,
            updateProperties: Bool,
            type: Data.Type
        ) where Data: ViewRenderData {
            var contentStorage: [ViewStorage] = storage.content[.mainContent] ?? []
            let old = storage.fields["element"] as? [Element] ?? []
            let widget: UnsafeMutablePointer<GtkBox>? = storage.opaquePointer?.cast()
            if let homogeneous, updateProperties, (storage.previousState as? Self)?.homogeneous != homogeneous {
                gtk_box_set_homogeneous(widget?.cast(), homogeneous.cBool)
            }
            old.identifiableTransform(
                to: elements,
                functions: .init { index in
                    let child = contentStorage[safe: index]?.opaquePointer
                    gtk_box_remove(widget, child?.cast())
                    contentStorage.remove(at: index)
                } insert: { index, element in
                    let child = content(element).storage(data: data, type: type)
                    gtk_box_insert_child_after(
                        widget,
                        child.opaquePointer?.cast(),
                        contentStorage[safe: index - 1]?.opaquePointer?.cast()
                    )
                    contentStorage.insert(child, at: index)
                }
            )
            if updateProperties {
                gtk_orientable_set_orientation(
                    widget?.opaque(),
                    horizontal ? GTK_ORIENTATION_HORIZONTAL : GTK_ORIENTATION_VERTICAL
                )
            }
            storage.fields["element"] = elements
            storage.content[.mainContent] = contentStorage
            for (index, element) in elements.enumerated() {
                content(element)
                    .updateStorage(
                        contentStorage[index],
                        data: data,
                        updateProperties: updateProperties,
                        type: type
                    )
            }
        }

        /// Whether the children should all be the same size.
        public func homogeneous(_ homogeneous: Bool? = true) -> Self {
            modify { $0.homogeneous = homogeneous }
        }
    }
}
