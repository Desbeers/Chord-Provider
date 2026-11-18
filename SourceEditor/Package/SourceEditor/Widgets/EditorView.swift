//
//  EditorView.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
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
    /// Padding of the editor.
    var padding = 0
    /// The padding edges.
    var paddingEdges: Set<Edge> = []
    /// Bool to show the line numbers.
    var lineNumbers = false
    /// The text wrapmode.
    var wrapMode: WrapMode = .none
    /// Bool to highlight the current line.
    var highlightCurrentLine: Bool = true
    /// Bool if the text is editable.
    var editable: Bool = true

    /// The language.
    var language: Editor.Language = .unknown


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
    ) -> ViewStorage {
        for function in appearFunctions {
            function(controller.view, data)
        }

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
    ) {
        if updateProperties {
            if (storage.previousState as? Self)?.language != language {
                Editor.Controller.initLanguage(
                    buffer: controller.buffer.sourceBufferPointer,
                    language: language
                )
                Idle {
                    controller.bridge.language.wrappedValue = controller.languageName
                    controller.bridge.styleInfo.wrappedValue = controller.allStyleInfo()
                }
            }
            // if (storage.previousState as? Self)?.snippets != snippets, let snippets {
            //     controller.addSnippetsPath(snippets.path())
            // }
            if (storage.previousState as? Self)?.padding != padding {
                if paddingEdges.contains(.top) {
                    gtk_text_view_set_top_margin(storage.textViewPointer, padding.cInt)
                }
                if paddingEdges.contains(.bottom) {
                    gtk_text_view_set_bottom_margin(storage.textViewPointer, padding.cInt)
                }
                if paddingEdges.contains(.leading) {
                    gtk_text_view_set_left_margin(storage.textViewPointer, padding.cInt)
                }
                if paddingEdges.contains(.trailing) {
                    gtk_text_view_set_right_margin(storage.textViewPointer, padding.cInt)
                }
            }
            if (storage.previousState as? Self)?.editable != editable {
                gtk_text_view_set_editable(storage.textViewPointer, editable.cBool)
            }
            if (storage.previousState as? Self)?.lineNumbers != lineNumbers {
                gtk_source_view_set_show_line_numbers(storage.sourceEditorPointer, lineNumbers.cBool)
            }
            if (storage.previousState as? Self)?.wrapMode != wrapMode {
                gtk_text_view_set_wrap_mode(storage.textViewPointer, wrapMode.gtkValue)
            }
            if (storage.previousState as? Self)?.highlightCurrentLine != highlightCurrentLine {
                gtk_source_view_set_highlight_current_line(storage.sourceEditorPointer, highlightCurrentLine.cBool)
            }
            Idle {
                if let spelling = controller.spellingAdaptor {
                    spelling_text_buffer_adapter_set_enabled(
                        spelling,
                        controller.spelling.wrappedValue ? 1 : 0
                    )
                }
                if controller.scheme.wrappedValue != controller.activeSchemeID() {
                    controller.updateStyle()
                }
                if controller.currentSearchText != controller.bridge.search.search.wrappedValue {
                    controller.setSearchText(controller.bridge.search.search.wrappedValue)
                }
                // Handle command
                // - Note: Don't use a mutating method through the binding here;
                //         it writes back on every update and causes an endless loop.
                if let command = controller.bridge.wrappedValue.command {
                    controller.bridge.wrappedValue.command = nil
                    controller.handle(command)
                }
                gtk_source_search_context_set_highlight(
                    controller.searchContext.opaquePointer,
                    controller.bridge.showSearchBar.wrappedValue.cBool
                )
            }
            for function in updateFunctions {
                function(storage, data, updateProperties)
            }
            storage.previousState = self
        }
    }

    // MARK: View modifiers

    /// Set the language for the editor.
    /// - Parameter language: The ``Editor.Language``.
    /// - Returns: Self.
    public func language(_ language: Editor.Language) -> Self {
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
            sourceEditor.padding = padding
            sourceEditor.paddingEdges = edges
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
            sourceEditor.controller.spelling = spelling
        }
    }

    /// The style scheme for the editor.
    /// - Parameter scheme: Binding to the scheme setting.
    /// - Returns: Self.
    public func scheme(_ scheme: Binding<String>) -> Self {
        modify { sourceEditor in
            sourceEditor.controller.scheme = scheme
        }
    }
}
