//
//  File.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Editor.Edit {

    enum AlignmentStyle: String, Codable, CaseIterable, CustomStringConvertible {
        /// Make it identifiable
        var id: Self { self }
        var description: String {
            self.rawValue.capitalized
        }
        var result: String {
            switch self {
            case .default:
                ""
            default:
                self.rawValue
            }
        }
        case `default`, left, center, right
    }

    /// The structure of the form items
    struct FormState: Equatable {

        /// Init with known values
        init(line: Song.Section.Line) {
            self.plain = line.plain ?? ""
            /// The plain text can be a numeric value
            self.numeric = Int(line.plain ?? "0") ?? 0
            /// Check the arguments
            if let arguments = line.arguments {
                self.label = arguments[.label] ?? ""
                self.align = arguments[.align] ?? ""
                self.flush = arguments[.flush] ?? ""
                self.width = Int(arguments[.width] ?? "0") ?? 0
                self.height = Int(arguments[.height] ?? "0") ?? 0
                self.src = arguments[.src] ?? ""
                self.tuplet = Int(arguments[.tuplet] ?? "0") ?? 0
                self.numeric = Int(arguments[.plain] ?? "") ?? 0
                if let scaleArgument = arguments[.scale], let value = Int(scaleArgument.replacingOccurrences(of: "%", with: "")) {
                    self.scale = value
                }
            }
        }

        /// Plain text
        var plain: String = ""
        /// A label
        var label: String = ""
        /// Alignment of item
        var align: String = ""
        /// Flush of item
        var flush: String = ""
        /// Width of item
        var width: Int = 0
        /// Height of item
        var height: Int = 0
        /// Source of an image
        var src: String = ""
        /// The tuplet for a strum
        var tuplet: Int = 0
        /// Plain numeric text
        var numeric: Int = 0
        /// The scale of an item
        var scale: Int = 0
    }

    // MARK: Views

    struct FieldLabel: View {
        /// The label of the text field
        let label: String
        /// The body of the `View`
        var view: Body {
            Text("\(label):")
                .style(.bold)
                .halign(.end)
                .padding(.trailing)
                .hexpand()
                .frame(maxWidth: 100)
        }
    }

    /// SwiftUI `View` for a plain text field
    struct PlainField: View {
        /// The label of the text field
        let label: String
        /// The prompt of the text field
        let prompt: String
        /// The value of the text field
        @Binding var value: String
        /// The body of the `View`
        var view: Body {
            HStack {
                FieldLabel(label: label)
                Entry(prompt, text: $value)
                    .frame(minWidth: 300)
            }
            .halign(.center)
        }
    }

    /// SwiftUI `View` slider to select a number
    struct NumberSpinner: View {
        /// The label for the slider
        let label: String
        /// Start
        let start: Int
        /// End
        let end: Int
        /// The suffix for the displayed value
        let suffix: String
        /// The selected value
        @Binding var value: Int
        /// The optional help
        var help: String? = nil
        /// The body of the `View`
        var view: Body {
            HStack {
                FieldLabel(label: label)
                VStack {
                    SpinRow("", value: $value, min: start, max: end)
                        .suffix { Text(suffix) }
                    //.subtitle(help ?? "")
                    //.subtitle("A value of 0 will not scale")
                    if let help {
                        Text(help)
                            .caption()
                            .halign(.end)
                    }
                }
                .valign(.start)
            }
            .halign(.center)
        }
    }

    struct KeyPicker: View {
        init(label: String, value: Binding<String>) {
            self.label = label
            self._value = value

            let key = ChordUtils.findChordElements(chord: value.wrappedValue)

            self._root = State(wrappedValue: key.root ?? .c)
            self._quality = State(wrappedValue: key.quality ?? .major)
        }
        
        /// The label of the text field
        let label: String
        /// The value of the text field
        @Binding var value: String

        @State private var root: Chord.Root

        @State private var quality: Chord.Quality

        /// The body of the `View`
        var view: Body {
            HStack {
                FieldLabel(label: label)
                Box {
                    DropDown(
                        selection: $root.onSet { root in value = "\(root.rawValue)\(quality.rawValue)" },
                        values: Array(Chord.Root.allCases.dropFirst().dropLast())
                    )
                    DropDown(
                        selection: $quality.onSet { quality in value = "\(root.rawValue)\(quality.rawValue)" },
                        values: [Chord.Quality.major, Chord.Quality.minor]
                    )
                }
                .linked()
                .horizontal()
            }
            .halign(.center)
        }
    }

    struct AlignPicker: View {
        init(label: String, value: Binding<String>) {
            self.label = label
            self._value = value
            self._selection = State(wrappedValue: Views.Editor.Edit.AlignmentStyle(rawValue: value.wrappedValue) ?? .default)
        }

        /// The label of the text field
        let label: String
        /// The value of the text field
        @Binding var value: String

        @State private var selection: Views.Editor.Edit.AlignmentStyle

        /// The body of the `View`
        var view: Body {
            HStack {
                FieldLabel(label: label)
                ToggleGroup(
                    selection: $selection.onSet { setting in value = setting.result },
                    values: Views.Editor.Edit.AlignmentStyle.allCases,
                    id: \.self,
                    label: \.description
                )
            }
            .halign(.center)
        }
    }
}
