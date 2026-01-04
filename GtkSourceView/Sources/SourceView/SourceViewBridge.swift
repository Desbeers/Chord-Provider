//
//  SourceViewBridge.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//


public struct SourceViewBridge: Equatable {
    /// Confirm to `Equatable`
    public static func ==(lhs: SourceViewBridge, rhs: SourceViewBridge) -> Bool {
        lhs.currentLine == rhs.currentLine && lhs.source == rhs.source
    }
    /// The source of the editor
    public var source: String = ""

    /// One-shot command for the editor
    public var command: SourceViewCommand?

    /// 1-based current cursor line
    public var currentLine: Int

    public init(
        command: SourceViewCommand? = nil,
        currentLine: Int = 1
    ) {
        self.command = command
        self.currentLine = currentLine
    }
}
