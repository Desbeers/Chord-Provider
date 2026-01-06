//
//  Widgets+ChordDiagram+Context.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import CChordProvider

extension Widgets.Diagram {

    public final class Context {

        // MARK: Storage

        private let raw: UnsafeMutablePointer<cchord>

        // MARK: Lifecycle

        public init(strings: Int = 6) {
            self.raw = cchord_new(Int32(strings))
        }

        deinit {
            cchord_free(raw)
        }

        // MARK: Internal access (for C / GTK)

        var pointer: UnsafeMutablePointer<cchord> {
            raw
        }

        // MARK: Properties

        public var strings: Int {
            get { Int(cchord_get_strings(raw)) }
            set { cchord_set_strings(raw, Int32(newValue)) }
        }

        public var baseFret: Int {
            get { Int(cchord_get_base_fret(raw)) }
            set { cchord_set_base_fret(raw, Int32(newValue)) }
        }

        public var showNotes: Bool {
            get { cchord_get_show_notes(raw) }
            set { cchord_set_show_notes(raw, newValue) }
        }

        // MARK: Frets & fingers

        public func setFret(_ fret: Int, on string: Int) {
            cchord_set_fret(raw, Int32(string), Int32(fret))
        }

        public subscript(fret index: Int) -> Int {
            get {
                precondition(index >= 0 && index < 6)
                return Int(cchord_get_fret(raw, Int32(index)))
            }
            set {
                precondition(index >= 0 && index < 6)
                cchord_set_fret(raw, Int32(index), Int32(newValue))
            }
        }

        public func setFinger(_ finger: Int, on string: Int) {
            cchord_set_finger(raw, Int32(string), Int32(finger))
        }

        public subscript(finger index: Int) -> Int {
            get {
                precondition(index >= 0 && index < 6)
                return Int(cchord_get_finger(raw, Int32(index)))
            }
            set {
                precondition(index >= 0 && index < 6)
                cchord_set_finger(raw, Int32(index), Int32(newValue))
            }
        }

        // MARK: Notes

        public func setNote(_ note: String?, on string: Int) {
            if let note {
                cchord_set_note(raw, Int32(string), note)
            } else {
                cchord_set_note(raw, Int32(string), nil)
            }
        }

        public func note(on string: Int) -> String? {
            guard let cStr = cchord_get_note(raw, Int32(string)) else {
                return nil
            }
            return String(cString: cStr)
        }

        // MARK: Barres

        public func setBarre(
            at index: Int,
            barre: Chord.Barre
        ) {
            cchord_set_barre(
                raw,
                Int32(index),
                Int32(barre.finger),
                Int32(barre.fret),
                Int32(barre.startIndex),
                Int32(barre.endIndex)
            )
        }

        public func barre(atFret fret: Int) -> Chord.Barre? {
            precondition(fret >= 0, "Fret must be positive")

            for index in 0..<5 {
                let barreFret = cchord_get_barre(raw, Int32(index))

                if barreFret.fret == fret {
                    return Chord.Barre(
                        finger: Int(barreFret.finger),
                        fret: Int(barreFret.fret),
                        startIndex: Int(barreFret.start),
                        endIndex: Int(barreFret.end)
                    )
                }
            }

            return nil
        }
    }
}
