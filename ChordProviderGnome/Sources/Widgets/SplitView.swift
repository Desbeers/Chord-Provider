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

    public init(@ViewBuilder start: @escaping () -> Body, @ViewBuilder end: @escaping () -> Body) {
        self.start = start()
        self.end = end()
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
        gtk_paned_set_start_child(.init(panedView), startStorage.opaquePointer?.cast())
        content[startID] = [startStorage]

        let endStorage = end.storage(data: data, type: type)
        let endPage = gtk_frame_new("Right")
        gtk_paned_set_end_child(.init(panedView), endStorage.opaquePointer?.cast())
        content[endID] = [endStorage]

        let storage = ViewStorage(panedView?.opaque(), content: content)
        update(storage, data: data, updateProperties: true, type: type)

        storage.fields[startID] = startPage?.opaque()
        storage.fields[endID] = endPage?.opaque()

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

//            if updateProperties, let mainPage = storage.fields["main-page"] as? OpaquePointer {
//                adw_navigation_page_set_title(mainPage.cast(), cStorage.fields[.navigationLabel] as? String ?? "")
//            }
        }
        if let endStorage = storage.content[endID]?[safe: 0] {
            end
                .updateStorage(endStorage, data: data, updateProperties: updateProperties, type: type)
//            if updateProperties, let sidebarPage = storage.fields["sidebar-page"] as? OpaquePointer {
//                adw_navigation_page_set_title(sidebarPage.cast(), sStorage.fields[.navigationLabel] as? String ?? "")
//            }
        }
//        guard updateProperties else {
//            return
//        }
//        let collapsed = adw_navigation_split_view_get_collapsed(storage.opaquePointer) != 0
//        if collapsed != self.collapsed {
//            adw_navigation_split_view_set_collapsed(storage.opaquePointer, self.collapsed.cBool)
//        }
//        let showContent = adw_navigation_split_view_get_show_content(storage.opaquePointer) != 0
//        if let binding = self.showContent, showContent != binding.wrappedValue {
//            adw_navigation_split_view_set_show_content(storage.opaquePointer, binding.wrappedValue.cBool)
//        }
    }
}
