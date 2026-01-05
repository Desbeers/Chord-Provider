//
//  Debouncer.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

final class Debouncer {
    private let queue: DispatchQueue
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?

    init(delay: TimeInterval, queue: DispatchQueue = .global(qos: .utility)) {
        self.delay = delay
        self.queue = queue
    }

    func schedule(_ action: @escaping () -> Void) {
        /// Cancel any pending work
        workItem?.cancel()

        let item = DispatchWorkItem(block: action)
        workItem = item

        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }

    func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}
