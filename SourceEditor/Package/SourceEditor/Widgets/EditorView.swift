//
//  EditorView.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import CGtkSourceView
import CLibSpelling

/// A source editor widget.
public struct EditorView: AdwaitaWidget {

    /// Additional update functions for type extensions.
    public var updateFunctions: [(ViewStorage, WidgetData, Bool) -> Void] = []
    /// Additional appear functions for type extensions.
    public var appearFunctions: [(ViewStorage, WidgetData) -> Void] = []

    /// The editor controller.
    let controller: Editor.Controller

    /// Bool to show the line numbers.
    @Property(
        set: { pointer, lineNumbers in
            gtk_source_view_set_show_line_numbers(
                pointer.cast(), lineNumbers.cBool
            )
        },
        pointer: OpaquePointer.self
    )
    var lineNumbers = false

    /// Bool to enable spelling
    @BindingProperty(
        observe: { _, spelling, storage in
            Editor.Controller.spelling(storage: storage, spelling: spelling)
        },
        set: { _, spelling, storage in
            Editor.Controller.spelling(storage: storage, spelling: spelling)
        },
        pointer: OpaquePointer.self
    )
    var spelling: Binding<Bool> = .constant(false)

    /// The text wrapmode.
    @Property(
        set: { pointer, wrapMode in
            gtk_text_view_set_wrap_mode(
                pointer.cast(),
                wrapMode.gtkValue
            )
        },
        pointer: OpaquePointer.self
    )
    var wrapMode: WrapMode = .none

    /// Bool to highlight the current line.
    @Property(
        set: { pointer, highlightCurrentLine in
            gtk_source_view_set_highlight_current_line(
                pointer.cast(),
                highlightCurrentLine.cBool
            )
        },
        pointer: OpaquePointer.self
    )
    var highlightCurrentLine: Bool = true

    /// Bool if the text is editable.
    @Property(
        set: { pointer, editable in
            gtk_text_view_set_editable(
                pointer.cast(),
                editable.cBool
            )
        },
        pointer: OpaquePointer.self
    )
    var editable: Bool = true

    /// The language.
    @BindingProperty(
        observe: { _, language, storage in
            if let buffer = storage.content["buffer"]?.first {
                buffer.notify(name: "language") {
                    language.wrappedValue = Editor.Controller.language(buffer: buffer)
                }
            }
        },
        set: { _, language, storage in
            if let buffer = storage.content["buffer"]?.first {
                Editor.Controller.language(
                    buffer: buffer,
                    language: language
                )
            }
        },
        pointer: OpaquePointer.self
    )
    var language: Binding<Editor.Language> = .constant(.def)

    /// The padding between the border and the content.
    @Property(
        set: { pointer, padding in
            padding.set(pointer)
        },
        pointer: OpaquePointer.self
    )
    var padding: InnerPadding?

    /// The inner padding of a text view.
    struct InnerPadding {

        /// The padding.
        var padding: Int
        /// The affected edges.
        var paddingEdges: Set<Edge>

        /// Set the inner padding on a text view.
        /// - Parameter pointer: The text view.
        func set(_ pointer: OpaquePointer) {
            if paddingEdges.contains(.top) {
                gtk_text_view_set_top_margin(pointer.cast(), padding.cInt)
            }
            if paddingEdges.contains(.bottom) {
                gtk_text_view_set_bottom_margin(pointer.cast(), padding.cInt)
            }
            if paddingEdges.contains(.leading) {
                gtk_text_view_set_left_margin(pointer.cast(), padding.cInt)
            }
            if paddingEdges.contains(.trailing) {
                gtk_text_view_set_right_margin(pointer.cast(), padding.cInt)
            }
        }
    }

    /// Init the editor.
    /// - Parameter controller: The editor controller.
    public init(
        controller: Editor.Controller
    ) {
        self.controller = controller
    }

    /// The view storage.
    /// - Parameters:
    ///   - data: The widget data.
    ///   - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        for function in appearFunctions {
            function(controller.view, data)
        }
        initProperties(controller.view, data: data, type: type)
        update(controller.view, data: data, updateProperties: true, type: type)
        // Return the GTKSourceView
        return controller.view
    }

    /// Update the stored content.
    /// - Parameters:
    ///   - storage: The storage to update.
    ///   - data: Modify views before being updated.
    ///   - updateProperties: Whether to update the view's properties.
    ///   - type: The view render data type.
    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        self.updateProperties(storage, data: data, updateProperties: updateProperties, type: type)
        if updateProperties {
            for function in updateFunctions {
                function(storage, data, updateProperties)
            }
            storage.previousState = self
        }
    }

    // MARK: View modifiers

    /// The language for the editor.
    /// - Parameter language: The ``Editor.Language``.
    /// - Returns: Self.
    public func language(_ language: Binding<Editor.Language>) -> Self {
        modify { sourceEditor in
            sourceEditor.language = language
        }
    }

    /// The closure when the text has changed.
    /// - Parameter closure: The closure to run.
    /// - Returns: Self.
    public func onTextChanged(_ closure: @escaping (String) -> [SourceMark]) -> Self {
        modify { sourceEditor in
            sourceEditor.controller.onTextChanged = closure
        }
    }

    /// The closure when the line has changed.
    /// - Parameter closure: The closure to run.
    /// - Returns: Self.
    public func onLineChanged(_ closure: @escaping () -> Void) -> Self {
        modify { sourceEditor in
            sourceEditor.controller.onLineChanged = closure
        }
    }

    /// The closure when a line is triple clicked.
    /// - Parameter closure: The closure to run.
    /// - Returns: Self.
    public func onTripleClick(_ closure: @escaping () -> Void) -> Self {
        modify { sourceEditor in
            sourceEditor.controller.onTripleClick = closure
        }
    }

    /// Set the inner padding of the editor.
    /// - Parameters:
    ///   - padding: The padding.
    ///   - edges: The edges for the padding.
    /// - Returns: Self.
    public func innerPadding(_ padding: Int = 10, edges: Set<Edge> = .all) -> Self {
        modify { sourceEditor in
            sourceEditor.padding = .init(padding: padding, paddingEdges: edges)
        }
    }

    /// Show the line numbers in the editor.
    /// - Parameter lineNumbers: Bool to show the line numbers.
    /// - Returns: Self.
    public func lineNumbers(_ lineNumbers: Bool = true) -> Self {
        modify { sourceEditor in
            sourceEditor.lineNumbers = lineNumbers
        }
    }

    /// Set the text as editable.
    /// - Parameter editable: Bool to make the text editable.
    /// - Returns: Self.
    public func editable(_ editable: Bool = true) -> Self {
        modify { sourceEditor in
            sourceEditor.editable = editable
        }
    }

    /// Highlight the current line.
    /// - Parameter highlightCurrentLine: Bool to highlight the current line.
    /// - Returns: Self.
    public func highlightCurrentLine(_ highlightCurrentLine: Bool = true) -> Self {
        modify { sourceEditor in
            sourceEditor.highlightCurrentLine = highlightCurrentLine
        }
    }

    /// Set the wrap mode.
    /// - Parameter wrapMode: The wrap mode of the text.
    /// - Returns: Self.
    public func wrapMode(_ wrapMode: WrapMode) -> Self {
        modify { sourceEditor in
            sourceEditor.wrapMode = wrapMode
        }
    }

    /// Enable or disable spelling.
    /// - Parameter spelling: Binding to the spelling bool.
    /// - Returns: Self.
    public func spelling(_ spelling: Binding<Bool>) -> Self {
        modify { sourceEditor in
            sourceEditor.spelling = spelling
        }
    }

    /// The style scheme for the editor.
    /// - Parameter scheme: Binding to the scheme.
    /// - Returns: Self.
    public func scheme(_ scheme: Binding<Editor.Scheme>) -> Self {
        modify { sourceEditor in
            sourceEditor.controller.scheme = scheme
        }
    }
}
