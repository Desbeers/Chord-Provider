//
//  ToggleGroup.swift
//  Adwaita
//
//  Created by auto-generation on 04.11.25.
//

import Adwaita
import CAdw
import LevenshteinTransformations

/// A group of exclusive toggles.
/// 
/// 
/// 
/// `AdwToggleGroup` presents a set of exclusive toggles, represented as
/// `Toggle` objects. Each toggle can display an icon, a label, an icon
/// and a label, or a custom child.
/// 
/// Toggles are indexed by their position, with the first toggle being equivalent
/// to 0, and so on. Use the ``active(_:)`` to get that position.
/// 
/// Toggles can also have optional names, set via the ``name(_:)``
/// property. The name of the active toggle can be accessed via the
/// ``activeName(_:)`` property.
/// 
/// `AdwToggle` objects can be retrieved via their index or name, using
/// `ToggleGroup.get_toggle` or `ToggleGroup.get_toggle_by_name`
/// respectively. `AdwToggleGroup` also provides a `Gtk.SelectionModel` of
/// its toggles via the ``toggles(_:)`` property.
/// 
/// `AdwToggleGroup` is orientable, and the toggles can be displayed horizontally
/// or vertically. This is mostly useful for icon-only toggles.
/// 
/// Use the ``homogeneous(_:)`` property to make the toggles take
/// the same size, and the ``canShrink(_:)`` to control whether
/// the toggles can ellipsize.
/// 
/// Example of an `AdwToggleGroup` UI definition:
/// 
/// ```xml
/// <object class="AdwToggleGroup"><property name="active-name">picture</property><child><object class="AdwToggle"><property name="icon-name">camera-photo-symbolic</property><property name="tooltip" translatable="yes">Picture Mode</property><property name="name">picture</property></object></child><child><object class="AdwToggle"><property name="icon-name">camera-video-symbolic</property><property name="tooltip" translatable="yes">Recording Mode</property><property name="name">recording</property></object></child></object>
/// ```
/// 
/// See also: `InlineViewSwitcher`.
/// 
/// 
public struct MyToggleGroup: AdwaitaWidget {

    /// Additional update functions for type extensions.
    var updateFunctions: [(ViewStorage, WidgetData, Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    var appearFunctions: [(ViewStorage, WidgetData) -> Void] = []

    /// The index of the active toggle.
    /// 
    /// Setting the index to a larger value than the number of toggles in the group
    /// unsets the current active toggle.
    /// 
    /// If no toggle is active, the property will be set to
    /// `Gtk.INVALID_LIST_POSITION`.
    var active: Binding<UInt>?
    /// The name of the active toggle.
    /// 
    /// The name can be set via ``name(_:)``. If the currently active
    /// toggle doesn't have a name, the property will be set to `NULL`.
    /// 
    /// Set it to `NULL` to unset the current active toggle.
    var activeName: Binding<String>?
    /// Whether the toggles can be smaller than the natural size of their contents.
    /// 
    /// If set to `true`, the toggle labels will ellipsize.
    /// 
    /// See ``canShrink(_:)``.
    var canShrink: Bool?
    /// Whether all toggles take the same size.
    var homogeneous: Bool?
    /// The number of toggles within the group.
    var nToggles: Binding<UInt>?

    /// Initialize `ToggleGroup`.
    init() {
    }

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
        let storage = ViewStorage(adw_toggle_group_new()?.opaque())
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

        storage.notify(name: "active") {
            let newValue = UInt(adw_toggle_group_get_active(storage.opaquePointer))
if let active, newValue != active.wrappedValue {
    active.wrappedValue = newValue
}
        }
        storage.notify(name: "active-name") {
            let newValue = String(cString: adw_toggle_group_get_active_name(storage.opaquePointer))
if let activeName, newValue != activeName.wrappedValue {
    activeName.wrappedValue = newValue
}
        }
        storage.notify(name: "n-toggles") {
            let newValue = UInt(adw_toggle_group_get_n_toggles(storage.opaquePointer))
if let nToggles, newValue != nToggles.wrappedValue {
    nToggles.wrappedValue = newValue
}
        }
            if let active, updateProperties, (UInt(adw_toggle_group_get_active(storage.opaquePointer))) != active.wrappedValue {
                adw_toggle_group_set_active(storage.opaquePointer, active.wrappedValue.cInt)
            }
            if let activeName, updateProperties, (String(cString: adw_toggle_group_get_active_name(storage.opaquePointer))) != activeName.wrappedValue {
                adw_toggle_group_set_active_name(storage.opaquePointer, activeName.wrappedValue)
            }
            if let canShrink, updateProperties, (storage.previousState as? Self)?.canShrink != canShrink {
                adw_toggle_group_set_can_shrink(widget, canShrink.cBool)
            }
            if let homogeneous, updateProperties, (storage.previousState as? Self)?.homogeneous != homogeneous {
                adw_toggle_group_set_homogeneous(widget, homogeneous.cBool)
            }



        }
        for function in updateFunctions {
            function(storage, data, updateProperties)
        }
        if updateProperties {
            storage.previousState = self
        }
    }

    /// The index of the active toggle.
    /// 
    /// Setting the index to a larger value than the number of toggles in the group
    /// unsets the current active toggle.
    /// 
    /// If no toggle is active, the property will be set to
    /// `Gtk.INVALID_LIST_POSITION`.
    public func active(_ active: Binding<UInt>?) -> Self {
        modify { $0.active = active }
    }

    /// The name of the active toggle.
    /// 
    /// The name can be set via ``name(_:)``. If the currently active
    /// toggle doesn't have a name, the property will be set to `NULL`.
    /// 
    /// Set it to `NULL` to unset the current active toggle.
    public func activeName(_ activeName: Binding<String>?) -> Self {
        modify { $0.activeName = activeName }
    }

    /// Whether the toggles can be smaller than the natural size of their contents.
    /// 
    /// If set to `true`, the toggle labels will ellipsize.
    /// 
    /// See ``canShrink(_:)``.
    public func canShrink(_ canShrink: Bool? = true) -> Self {
        modify { $0.canShrink = canShrink }
    }

    /// Whether all toggles take the same size.
    public func homogeneous(_ homogeneous: Bool? = true) -> Self {
        modify { $0.homogeneous = homogeneous }
    }

    /// The number of toggles within the group.
    public func nToggles(_ nToggles: Binding<UInt>?) -> Self {
        modify { $0.nToggles = nToggles }
    }

}
