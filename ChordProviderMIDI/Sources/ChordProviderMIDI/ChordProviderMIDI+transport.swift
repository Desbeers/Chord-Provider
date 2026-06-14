//
//  ChordProviderMIDI+transport.swift
//  ChordProviderMIDI
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension ChordProviderMIDI {

    public func startTransport() {
        guard playbackTasks.transport == nil else { return }
        transport = TransportState()
        playbackTasks.transport = Task {
            await runTransport()
        }
    }

    public func stopTransport() {
        guard playbackTasks.metronome == nil && playbackTasks.tab == nil && playbackTasks.grid == nil else {
            return
        }
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

            transport.tempo =
                60.0 /
                (Double(snapshot.tempo ?? 128) *
                metronome.timeSignature.quarterNoteMultiplier)

            transport.nextTransportTime += .seconds(transport.tempo / Double(metronome.timeSignature.ticksPerBar))

            if transport.subdivision % 4 == 0 {
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
