//
//  EditorSearch.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Adwaita

/// The `View` with search.
public struct EditorSearch: View {

    /// The editor controller.
    let controller: Editor.Controller
    /// The editor bridge.
    @Binding var bridge: Editor.Bridge
    /// Bool to show the options.
    @State private var showOptions: Bool = false

    /// Init the `View`.
    /// - Parameter controller: The editor controller.
    public init(controller: Editor.Controller) {
        self.controller = controller
        self._bridge = controller.bridge
    }

    /// The body of the `View`.
    public var view: Body {
        Box {
            // Just as attachment point
        }
        .topToolbar(visible: bridge.showSearchBar) {
            search
        }
    }

    /// The search `View`.
    public var search: AnyView {
        VStack {
            HStack(spacing: 5) {
                Symbol(icon: .default(icon: .systemSearch))
                Entry("Search", text: $bridge.search.search)
                    .focus($bridge.focusSearch)
                    .warning(bridge.search.noMatches)
                HStack {
                    Button(icon: .default(icon: .goUp)) {
                        controller.command(.search(.previous))
                    }
                    .keyboardShortcut("g".shift().ctrl(), active: bridge.showSearchBar)
                    .tooltip("Previous")
                    Button(icon: .default(icon: .goDown)) {
                        controller.command(.search(.next))
                    }
                    .keyboardShortcut("g".ctrl(), active: bridge.showSearchBar)
                    .tooltip("Next")
                }
                .linked()
                .insensitive(bridge.search.noMatches)
                // Below should be a toggle but I can't attach
                // keyboard shortcuts to them
                Button(icon: .default(icon: .editFindReplace)) {
                    bridge.search.showReplaceOptions.toggle()
                    if bridge.search.showReplaceOptions {
                        bridge.focusReplace.signal()
                    } else {
                        bridge.focusSearch.signal()
                    }
                }
                .keyboardShortcut("h".ctrl(), active: bridge.showSearchBar)
                .flat(!bridge.search.showReplaceOptions)
                Text(bridge.search.countDisplay)
                Text("")
                    .hexpand()
                options
                Button(icon: .default(icon: .windowClose)) {
                    bridge.showSearchBar = false
                }
                .flat()
                .circular()
                .tooltip("Close")
            }
            if bridge.search.showReplaceOptions {
                replace
                    .padding(5, .top)
                    .transition(.crossfade)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .style("caption")
        .hexpand()
    }

    /// The replace `View`.
    var replace: AnyView {
        HStack(spacing: 5) {
            Symbol(icon: .default(icon: .editFindReplace))
            Entry("Replace", text: $bridge.search.replace)
                .focus($bridge.focusReplace)
            HStack {
                Button("Replace") {
                    controller.command(
                        .replaceSearchMatch(
                            with: bridge.search.replace
                        )
                    )
                }
                .insensitive(bridge.search.replace.isEmpty || !bridge.search.hasMatch)
                Button("Replace All") {
                    controller.command(.replaceAllSearchMatches(with: bridge.search.replace))
                }
                .insensitive(bridge.search.replace.isEmpty || !bridge.search.haveMatches)
            }
            .linked()
            .insensitive(bridge.search.search == bridge.search.replace)
        }
    }

    /// The options `View`.
    var options: AnyView {
        Toggle(icon: .default(icon: .applicationsSystem), isOn: $showOptions)
            .flat()
            .popover(visible: $showOptions) {
                VStack {
                    Toggle("Match Whole Word Only", isOn: $bridge.search.matchWholeWordOnly.onSet { state in
                        controller.command(.matchWholeWordOnly(state))
                    })
                    .checkButton()
                    Toggle("Case Sensitive", isOn: $bridge.search.caseSensitive.onSet { state in
                        controller.command(.caseSensitive(state))
                    })
                    .checkButton()
                    Toggle("Regular Expressions", isOn: $bridge.search.regularExpressions.onSet { state in
                        controller.command(.regularExpressions(state))
                    })
                    .checkButton()
                }
            }
            .tooltip("Options")
    }
}
