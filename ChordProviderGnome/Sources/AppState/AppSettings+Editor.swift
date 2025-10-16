//
//  AppSettings+Editor.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings for the editor
    struct Editor: Codable {
        /// Bool if the editor is shown
        var showEditor: Bool = false
        /// Bool if the editor is showing line numbers
        var showLineNumbers: Bool = true
        /// Bool if the editor should wrap lines
        var wrapLines: Bool = true
        /// The font size of the editor
        var fontSize: Font = .standard
        /// The position of the splitter``
        var splitter: Int = 0 {
            willSet {
                if newValue > 100 {
                    restoreSplitter = newValue
                }
            }
            didSet {
                if splitter < 100 {
                    showEditor = false
                    splitter = 0
                }
            }
        }
        /// Remember the splitter position when hiding the editor
        var restoreSplitter: Int = 400
    }
}

extension AppSettings.Editor {
    
    /// The font size of the ediot
    enum Font: Int, Codable, CaseIterable, CustomStringConvertible, Identifiable {
        case smaller = 10
        case small = 11
        case standard = 12
        case large = 13
        case larger = 14

        var description: String {
            switch self {
            case .smaller: "Smaller"
            case .small: "Small"
            case .standard: "Standard"
            case .large: "Large"
            case .larger: "Larger"
            }
        }
        var id: Self { self }
    }
}
