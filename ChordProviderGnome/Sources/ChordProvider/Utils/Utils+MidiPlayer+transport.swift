//
//  Utils+MidiPlayer+transport.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension Utils.MidiPlayer {

    func startTransport() {
        guard playbackTasks.transport == nil else { return }
        transport = TransportState()
        playbackTasks.transport = Task {
            await runTransport()
        }
    }

    func stopTransport() {
        guard playbackTasks.metronome == nil && playbackTasks.tab == nil && playbackTasks.grid == nil else {
            print("Something else is playing")
            return
        }
        print("Stop transport")
        playbackTasks.transport?.cancel()
        playbackTasks.transport = nil
    }

    private func runTransport() async {

        while !Task.isCancelled {
            transport.isAccent =
                metronome.timeSignature.accentIndices.contains(
                    transport.tick
                )

            try? await Task.sleep(until: transport.nextTransportTime)

            let tempo =
                60.0 /
                (Double(metronome.bpm) *
                metronome.timeSignature.quarterNoteMultiplier)

            transport.nextTransportTime += .seconds(tempo / 2)

            if transport.subdivision % 2 == 0 {
                transport.tick =
                    (transport.tick + 1)
                    % metronome.timeSignature.ticksPerBar
            }

            transport.subdivision =
                (transport.subdivision + 1)
                % (metronome.timeSignature.ticksPerBar * 2)

        }
    }
}
