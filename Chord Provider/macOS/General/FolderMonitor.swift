//
//  FolderMonitor.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

/// A Class to monitor folders  for changes
public class FolderMonitor {
    private let kqueueId: Int32
    private var watchedPaths = [URL: Int32]()
    private var keepWatcherThreadRunning = false
    private let folderChangeDebouncer = DebounceTask(duration: 2)
    /// The method when a folder did change
    public var folderDidChange: (() -> Void)?

    public init() {
        kqueueId = kqueue()
    }

    deinit {
        keepWatcherThreadRunning = false
        removeAllURLs()
        close(kqueueId)
    }

    /// Add a folder and all its subfolders
    /// - Parameter url: URL of the folder
    public func addRecursiveURL(_ url: URL) {
        removeAllURLs()
        addURL(url)
        if let items = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) {
            while let item = items.nextObject() as? URL {
                if item.hasDirectoryPath {
                    addURL(item)
                }
            }
        }
    }

    public func addURL(_ url: URL) {
        var fileDescriptor: Int32! = watchedPaths[url]
        if fileDescriptor == nil {
            fileDescriptor = open(FileManager.default.fileSystemRepresentation(withPath: url.path), O_EVTONLY)
            guard fileDescriptor >= 0 else {
                return
            }
            watchedPaths[url] = fileDescriptor
        }

        var edit = kevent(
            ident: UInt(fileDescriptor),
            filter: Int16(EVFILT_VNODE),
            flags: UInt16(EV_ADD | EV_CLEAR),
            fflags: UInt32(NOTE_WRITE),
            data: 0,
            udata: nil
        )
        kevent(kqueueId, &edit, 1, nil, 0, nil)

        if !keepWatcherThreadRunning {
            keepWatcherThreadRunning = true
            Task {
                watcherThread()
            }
        }
    }

    private func watcherThread() {
        var event = kevent()
        var timeout = timespec(tv_sec: 1, tv_nsec: 0)
        while keepWatcherThreadRunning {
            if kevent(kqueueId, nil, 0, &event, 1, &timeout) > 0 && event.filter == EVFILT_VNODE && event.fflags > 0 {
                if watchedPaths.first(where: { $1 == event.ident }) != nil {
                    Task {
                        await folderChangeDebouncer.submit {
                            self.folderDidChange?()
                        }
                    }
                } else {
                    continue
                }

            }
        }
    }

    public func isURLWatched(_ url: URL) -> Bool {
        return watchedPaths[url] != nil
    }

    public func removeURL(_ url: URL) {
        if let fileDescriptor = watchedPaths.removeValue(forKey: url) {
            close(fileDescriptor)
        }
    }

    public func removeAllURLs() {
        watchedPaths.keys.forEach(removeURL)
    }

    public func numberOfWatchedPaths() -> Int {
        return watchedPaths.count
    }

    public func fileDescriptorForURL(_ url: URL) -> Int32 {
        if let fileDescriptor = watchedPaths[url] {
            return fcntl(fileDescriptor, F_DUPFD)
        }
        return -1
    }
}

private extension FolderMonitor {

    /// Debounce a task
    actor DebounceTask {
        /// The duration of the debounce
        private let duration: TimeInterval
        /// The `Task` to debounce
        private var task: Task<Void, Error>?

        /// Init the DebounceTask
        /// - Parameter duration: Time duration to debounce
        init(duration: TimeInterval) {
            self.duration = duration
        }

        /// Submit a debounce `Task`
        /// - Parameter operation: The `Task`
        func submit(operation: @escaping () async -> Void) {
            task?.cancel()
            task = Task {
                try await sleep()
                await operation()
                task = nil
            }
        }

        /// Let a `Task` sleep
        func sleep() async throws {
            try await Task.sleep(nanoseconds: UInt64(duration * TimeInterval(NSEC_PER_SEC)))
        }
    }
}
