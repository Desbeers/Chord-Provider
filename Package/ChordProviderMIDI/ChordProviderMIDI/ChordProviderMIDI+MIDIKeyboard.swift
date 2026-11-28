//
//  ChordProviderMIDI+MIDIKeyboard.swift
//  ChordProviderMIDI
//
//  © 2026 Nick Berendsen
//

import Foundation
import CFluidSynth

extension ChordProviderMIDI {

    /// Listens to MIDI keyboards, plays the notes on the synth and reports them to Swift.
    final class MIDIKeyboard {

        /// Everything the C callback needs.
        private final class Relay {

            /// The synth
            let synth: OpaquePointer
            /// The MIDI events
            let continuation: AsyncStream<MIDINoteEvent>.Continuation
            /// Note-on events before this time are old events from the system
            let ignoreNotesUntil: DispatchTime = .now() + .milliseconds(150)
            /// Init
            init(synth: OpaquePointer, continuation: AsyncStream<MIDINoteEvent>.Continuation) {
                self.synth = synth
                self.continuation = continuation
            }
        }
        /// The C callback
        private let relay: Relay
        /// The MIDI dfriver
        private var driver: OpaquePointer?
        /// Init
        init(settings: OpaquePointer, synth: OpaquePointer, continuation: AsyncStream<MIDINoteEvent>.Continuation) {
            relay = Relay(synth: synth, continuation: continuation)
            /// Runs on FluidSynth's MIDI thread, so no UI work here.
            let handler: handle_midi_event_func_t = { data, event in
                guard let data, let event else {
                    return -1
                }
                // Set the MIDI keyboard channel.
                fluid_midi_event_set_channel(event, 15)
                let callback = Unmanaged<Relay>.fromOpaque(data).takeUnretainedValue()
                /// Old events from before the start: don't play them and don't report them
                if fluid_midi_event_get_type(event) == 0x90, DispatchTime.now() < callback.ignoreNotesUntil {
                    return 0
                }
                let note = Int(fluid_midi_event_get_key(event))
                let velocity = Int(fluid_midi_event_get_velocity(event))
                switch fluid_midi_event_get_type(event) {
                case 0x90: // Note on (velocity 0 means note off).
                    callback.continuation.yield(velocity > 0 ? .on(note: note, velocity: velocity) : .off(note: note))
                case 0x80: // Note off.
                    callback.continuation.yield(.off(note: note))
                default:
                    break
                }
                // Pass everything on (notes, pedal, pitch bend) so the synth plays it.
                return fluid_synth_handle_midi_event(UnsafeMutablePointer(callback.synth), event)
            }
            driver = new_fluid_midi_driver(settings, handler, Unmanaged.passUnretained(relay).toOpaque())
        }

        deinit {
            // Delete the driver before the synth is deleted.
            if let driver { delete_fluid_midi_driver(driver) }
            /// Silence the notes that are still sounding
            fluid_synth_all_sounds_off(relay.synth, 15)
            relay.continuation.finish()
        }
    }
}
