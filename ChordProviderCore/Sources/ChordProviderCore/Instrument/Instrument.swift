//
//  Instrument.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// A **Chord Provider** instrument
public struct Instrument: Codable, Sendable, Hashable, Identifiable, CustomStringConvertible, Comparable {

    /// Init a **Chord Provider** instrument
    /// - Parameters:
    ///   - id: The ID of the instrument
    ///   - kind: The kind of instrument
    ///   - label: The label of the instrument
    ///   - tuning: The tuning of the instrument
    ///   - bundle: The optional path to the build-in bundle
    ///   - fileURL: The optional URL to the custom definition
    ///   - modified: Bool if the database is modified
    public init(
        kind: Kind,
        label: String,
        tuning: [String],
        bundle: String? = nil,
        fileURL: URL? = nil,
        modified: Bool = false
    ) {
        self.kind = kind
        self.label = label
        self.tuning = tuning.compactMap(Instrument.Tuning.init)
        self.bundle = bundle
        self.fileURL = fileURL
        self.modified = modified
    }

    /// Identifiable protocol
    public var id: String {
        bundle ?? fileURL?.path ?? "new"
    }

    /// CustomStringConvertible protocol
    public var description: String {
        var result = [kind.description, label]
        if modified {
            result.append("modified")
        }
        return result.joined(separator: " · ")
    }

    /// The status of the instrument
    public var status: String {
        var result: [String] = [bundle == nil ? fileURL?.lastPathComponent ?? "New" : "Build-in"]
        if modified {
            result.append("modified")
        }
        return result.joined(separator: " · ")
    }

    /// Comparable protocol
    /// - Note: Used for sorting the instruments
    public static func < (lhs: Instrument, rhs: Instrument) -> Bool {
        (lhs.kind, lhs.fileURL?.path ?? "")
        <
        (rhs.kind, rhs.fileURL?.path ?? "")
    }

    /// The kind of instrument
    public var kind: Kind
    /// The label of the instrument
    public var label: String
    /// The tuning of the instrument
    public var tuning: [Tuning]
    /// The optional path to the build-in bundle
    public var bundle: String?
    /// The optional URL to the custom definition
    public var fileURL: URL?
    /// Bool if the database is modified
    public var modified: Bool = false
}

extension Instrument {

    /// String numbers based on the tuning
    public var strings: [Int] {
        Array(self.tuning.indices)
    }

    /// String offsets based on the midi values
    public var offsets: [Int] {
        tuning.map { $0.midi - 41 }
    }
}

extension Instrument {

    /// Get a build-in instrument
    /// - Parameter kind: The kind of instrument
    /// - Returns: A build-in instrument
    public static subscript(kind: Kind) -> Instrument {
        guard let instrument = buildIn.first(where: { $0.kind == kind }) else {
            preconditionFailure("Missing built-in instrument for kind: \(kind)")
        }
        return instrument
    }
}

extension Instrument {

    /// Build-in instruments
    public static let buildIn: [Instrument] = [
        Instrument(
            kind: .guitar,
            label: "Standard Tuning",
            tuning: ["E2", "A2", "D3", "G3", "B3", "E4"],
            bundle: "ChordDefinitions/GuitarStandardETuning"
            ),
        Instrument(
            kind: .guitalele,
            label: "Standard Tuning",
            tuning: ["A2", "D3", "G3", "C4", "E4", "A4"],
            bundle: "ChordDefinitions/GuitaleleStandardATuning"
            ),
        Instrument(
            kind: .ukulele,
            label: "Standard Tuning",
            tuning: ["G4", "C4", "E4", "A4"],
            bundle: "ChordDefinitions/UkuleleStandardGTuning"
            )
    ]
}
