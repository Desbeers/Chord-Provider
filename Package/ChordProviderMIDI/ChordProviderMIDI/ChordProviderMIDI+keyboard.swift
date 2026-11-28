//
//  ChordProviderMIDI+perform.swift
//  ChordProviderMIDI
//
//  © 2026 Nick Berendsen
//

import Foundation
import CFluidSynth

extension ChordProviderMIDI {

    /// Set the callback for a keyboard event
    public func midiCallback(_ handler: @escaping @Sendable (KeyboardSnapshot) -> Void) {
        keyboardHandler = handler
    }

    /// Start following the MIDI keyboard, safe to call more than once
    public func startKeyboard() {
        guard playbackTasks.keyboard == nil else {
            return
        }
        guard let settings, let synth else {
            return
        }
        let (stream, continuation) = AsyncStream.makeStream(of: MIDINoteEvent.self)
        keyboardEvents = stream
        keyboard = MIDIKeyboard(settings: settings, synth: synth, continuation: continuation)
        playbackTasks.keyboard = Task {
            await listenToKeyboard()
        }
    }

    /// Stop following the MIDI keyboard, safe to call more than once
    public func stopKeyboard() {
        playbackTasks.keyboard?.cancel()
        playbackTasks.publish?.cancel()
        playbackTasks.clearNotes?.cancel()
        playbackTasks.keyboard = nil
        playbackTasks.publish = nil
        playbackTasks.clearNotes = nil
        /// Tell the handler that no notes are held anymore, then let it go
        keyboardSnapshot = KeyboardSnapshot()
        publishKeyboard()
        keyboard = nil
    }

    /// Follow the notes from the MIDI keyboard
    func listenToKeyboard() async {
        guard let keyboardEvents else {
            return
        }
        for await event in keyboardEvents {
            switch event {
            case .on(let note, _):
                if !keyboardSnapshot.heldNotes.contains(note) {
                    keyboardSnapshot.heldNotes.append(note)
                    keyboardSnapshot.heldNotes.sort()
                }
            case .off(let note):
                keyboardSnapshot.heldNotes.removeAll { $0 == note }
            }
            schedulePublish()
        }
    }

    /// Update the delayed notes and publish after a short pause
    func schedulePublish() {
        let publishDelay: Duration = .milliseconds(100)
        playbackTasks.publish?.cancel()
        playbackTasks.publish = Task {
            try? await Task.sleep(for: publishDelay)
            guard !Task.isCancelled else {
                return
            }
            updateDelayedNotes()
            publishKeyboard()
        }
    }

    /// Update the notes that linger after the keys are released
    private func updateDelayedNotes() {
        let held = keyboardSnapshot.heldNotes
        let delayed = keyboardSnapshot.delayedNotes

        if held.isEmpty {
            /// All keys are up: keep the delayed notes for a moment, then clear
            scheduleDelayedUpdate(after: .milliseconds(200))
        } else if held.count >= delayed.count || !delayed.containsAll(held) {
            /// Notes were added or changed: this is a new chord
            playbackTasks.clearNotes?.cancel()
            keyboardSnapshot.delayedNotes = held
        } else if held != delayed {
            /// Keys are being released: wait to see if this is a chord lifting or a new, smaller chord
            scheduleDelayedUpdate(after: .milliseconds(300))
        }
    }

    /// After the delay, make the delayed notes follow the notes that are held at that moment
    ///
    /// - Note: A new key press, or a new release, cancels and replaces a pending update
    private func scheduleDelayedUpdate(after delay: Duration) {
        playbackTasks.clearNotes?.cancel()
        playbackTasks.clearNotes = Task {
            try? await Task.sleep(for: delay)
            guard !Task.isCancelled else {
                return
            }
            keyboardSnapshot.delayedNotes = keyboardSnapshot.heldNotes
            publishKeyboard()
        }
    }

    /// Send the current state to the handler
    private func publishKeyboard() {
        keyboardHandler?(keyboardSnapshot)
    }

    /// The notes from the MIDI keyboard
    public struct KeyboardSnapshot: Sendable {

        /// Init
        public init(heldNotes: [Int] = [], delayedNotes: [Int] = []) {
            self.heldNotes = heldNotes
            self.delayedNotes = delayedNotes
        }
        /// The notes that are held, sorted from low to high
        public var heldNotes: [Int] = []
        /// Delayed notes; it stays a moment after the keys are released
        public var delayedNotes: [Int] = []
    }

    /// A note event from a MIDI keyboard.
    public enum MIDINoteEvent: Sendable {
        /// A key was pressed.
        case on(note: Int, velocity: Int)
        /// A key was released.
        case off(note: Int)
    }
}
