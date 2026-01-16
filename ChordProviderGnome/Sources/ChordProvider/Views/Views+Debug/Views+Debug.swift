//
//  Views+Debug+log.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceView

extension Views {

    /// The `View` for showing debug messages
    struct Debug: View {
        /// The state of the application
        @Binding var appState: AppState
        /// The `Body` of the `View`
        var view: Body {
            VStack {
                ToggleGroup(selection: $appState.scene.selectedDebugTab, values: Tab.allCases)
                    .padding()
                Text(appState.scene.selectedDebugTab.help)
                    .style(.title)
                    .padding(5, .bottom)
                Separator()
                switch appState.scene.selectedDebugTab {
                case .json:
                    json
                case .log:
                    log
                case .source:
                    source
                }
            }
            .vexpand()
            .hexpand()
            .card()
            .padding()
            Button("Back to your song") {
                appState.scene.showDebugDialog = false
            }
            .halign(.center)
            .suggested()
            .padding(5, .bottom)
        }

        /// Show text in a `GtkSourceView`
        /// - Parameters:
        ///   - text: The text to show
        ///   - language: The language of the text
        /// - Returns: An `AnyView`
        func sourceView(_ text: String?, language: Language = .json) -> AnyView {
            SimpleSourceView(text: text ?? "", language: language)
        }

        /// The tabs of the *Debug* View
        enum Tab: String, ToggleGroupItem, CaseIterable, CustomStringConvertible {
            /// Make it identifiable
            var id: Self { self }
            /// The description of the tab
            var description: String { rawValue }
            /// The help text of the tab
            var help: String {
                switch self {
                case .log:
                    "The logging messages generated during the song parsing"
                case .source:
                    "The generated source for your song"
                case .json:
                    "The JSON representation of the song"
                }
            }
            /// The icon of the tab
            var icon: Icon? {
                .default(icon: {
                    switch self {
                    case .log:
                            .dialogInformation
                    case .source:
                            .formatJustifyLeft
                    case .json:
                            .viewListBullet
                    }
                }())
            }
            /// Show the label
            var showLabel: Bool { true }
            /// Log messages
            case log = "Log output"
            /// Song source messages
            case source = "Generated Source"
            /// Generated JSON messages
            case json = "JSON output"
        }
        
        /// The pages of the *JSON* View
        enum JSONPage: String, Identifiable, CaseIterable, Codable, CustomStringConvertible {
            /// Make it identifiable
            var id: Self {
                self
            }
            /// The description of the oage
            var description: String {
               rawValue
            }
            /// Metadata of the song
            case metadata = "Metadata"
            /// The sections of the song
            case sections = "Sections"
            /// All the chords in the song
            case chords = "Chords"
            /// The *core* settings of the song
            case settings = "Settings"
        }
    }
}
