//
//  File.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 02/09/2025.
//

import Foundation
import Adwaita
import CAdw


public struct SplitView: AdwaitaWidget {

    var start: Body
    var end: Body

    /// The start content's id.
    let startID = "start"
    /// The end content's id.
    let endID = "end"
    /// The splitter ID
    let splitterID = "splitter"

    /// Position of the splitter
    @Binding var splitter: Int

    public init(
        splitter: Binding<Int>,
        @ViewBuilder start: @escaping () -> Body,
        @ViewBuilder end: @escaping () -> Body
    ) {
        self.start = start()
        self.end = end()
        self._splitter = splitter
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
        let panedView = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)
        var content: [String: [ViewStorage]] = [:]

        let startStorage = start.storage(data: data, type: type)
        let startPage = gtk_frame_new("Left")
        gtk_paned_set_position(.init(panedView), 0)
        gtk_paned_set_start_child(.init(panedView), startStorage.opaquePointer?.cast())
        content[startID] = [startStorage]

        let endStorage = end.storage(data: data, type: type)
        let endPage = gtk_frame_new("Right")
        gtk_paned_set_end_child(.init(panedView), endStorage.opaquePointer?.cast())
        content[endID] = [endStorage]

        let storage = ViewStorage(panedView?.opaque(), content: content)

        storage.fields[startID] = startPage?.opaque()
        storage.fields[endID] = endPage?.opaque()

        update(storage, data: data, updateProperties: true, type: type)

        storage.notify(name: "position") {
            splitter = Int(gtk_paned_get_position(storage.opaquePointer))
        }

        return storage
    }

    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        if let startStorage = storage.content[startID]?[safe: 0] {
            start
                .updateStorage(startStorage, data: data, updateProperties: updateProperties, type: type)
        }
        if let endStorage = storage.content[endID]?[safe: 0] {
            end
                .updateStorage(endStorage, data: data, updateProperties: updateProperties, type: type)
        }
        guard updateProperties else {
            return
        }
        let position = Int(gtk_paned_get_position(storage.opaquePointer))
        if splitter != position {
            gtk_paned_set_position(storage.opaquePointer, Int32(splitter))
        }
        storage.previousState = self
    }
}
