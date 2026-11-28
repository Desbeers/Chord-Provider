//
//  MainLoop.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import CAdw

/// Run closures on the GTK main loop from any thread
public enum MainLoop {

    /// A reference type holding a closure
    private final class ClosureBox: Sendable {

        /// The closure to run
        let closure: @MainActor @Sendable () -> Void
        /// Init the box
        init(closure: @escaping @MainActor @Sendable () -> Void) {
            self.closure = closure
        }
    }

    /// Run a closure on the GTK main loop from any thread
    /// - Parameter closure: The closure to run
    nonisolated static public func run(_ closure: @escaping @MainActor @Sendable () -> Void) {
        let context = Unmanaged.passRetained(ClosureBox(closure: closure)).toOpaque()
        g_idle_add_full(
            200,
            { pointer in
            if let pointer {
                let box = Unmanaged<ClosureBox>.fromOpaque(pointer).takeRetainedValue()
                MainActor.assumeIsolated { box.closure() }
            }
            return G_SOURCE_REMOVE
            },
            context,
            nil
        )
    }
}
