//
//  Tests.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Testing
import Foundation
import Adwaita
import CGtkSourceView
@testable import SourceEditor

/// Static definitions
@MainActor
enum Static {
    static let gtkReady: Bool = {
        let ok = gtk_init_check() != 0
        gtk_source_init()
        return ok
    }()
    static let invertTest: Bool = ProcessInfo.processInfo.environment["INVERT_TESTS"] != nil
    static let newText = "New Text"
    static let alteredText = "Altered Text"
}


/// Run a controller action and pump the GLib main loop until its completion fires.
@MainActor
func waitForCompletion(
    timeout: TimeInterval = 5,
    _ action: (@escaping (Result<Void, Error>) -> Void) -> Void
) -> Result<Void, Error>? {
    var result: Result<Void, Error>?
    action { result = $0 }
    let deadline = Date().addingTimeInterval(timeout)
    while result == nil, Date() < deadline {
        _ = g_main_context_iteration(nil, 0)
    }
    return result
}

@MainActor
final class Box<Value> {
    var value: Value
    init(_ value: Value) { self.value = value }
}

@MainActor
final class TestEditor {

    let controller: Editor.Controller
    private let box = Box(Editor.Bridge())

    /// The bridge value, as the UI would see it.
    var bridge: Editor.Bridge { box.value }

    init() {
        let box = box   // local copy, so the closures capture the box and not `self`
        controller = Editor.Controller()
        controller.bridge = Binding(
            get: { box.value },
            set: { box.value = $0 }
        )
    }
}

/// Print a line of test feedback.
func note(_ message: String) {
    print("  ↳ \(message)")
}

/// The look of a line of test feedback.
enum NoteStyle {
    /// Something that is as expected.
    case pass
    /// Something that is wrong.
    case fail
    /// Neutral information.
    case info
    /// Header.
    case header
    /// Test details
    case details

    /// The symbol in front of the message.
    var symbol: String {
        switch self {
        case .pass: "  ✔"
        case .fail: "✘"
        case .info: "↳"
        case .header: " "
        case .details: " "
        }
    }

    /// The ANSI code: bold, plus a color.
    var color: String {
        switch self {
        case .pass: "32"   // bold green
        case .fail: "1;31"   // bold red
        case .info: "2"      // dim, no bold
        case .header: "1;34"   // bold blue
        case .details:   "94"   // bright blue
        }
    }
}

/// Print a line of test feedback.
/// - Parameters:
///   - message: The message.
///   - style: The style; green for `.pass` by default.
func note(_ message: String, _ style: NoteStyle = .pass) {
    let line = "\(style.symbol) \(message)"
        print("\u{1B}[\(style.color)m\(line)\u{1B}[0m")
}

/// Record a test failure and print it in red.
func fail(_ message: String) {
    note(message, .fail)
    Issue.record(Comment(rawValue: message))
}


/// Record a message.
/// - Parameters:
///   - message: The message.
///   - success: Bool if the test did pass.
@MainActor
func record(_ message: String, _ success: Bool) {
    let passed = Static.invertTest ? !success : success
    if passed {
        note(message, .pass)
    } else {
        Issue.record("\(Comment(rawValue: message)) Not passed.")
    }
}

/// Header of a test
func header(_ test: TestCase) {
    note(test.rawValue, .header)
    if let details = test.details?.components(separatedBy: .newlines) {
        for detail in details {
            note(detail, .details)
        }
    }
}

extension Result {

    /// Bool if the result is a success.
    var success: Bool {
        if case .success = self { true } else { false }
    }
    /// Bool if the result is a failure.
    /// - Note: I don't like *negative* checks.
    ///         So, check for *succues* or *failure*, but not for *!success* in my code.
    var failed: Bool {
        !success
    }
}
