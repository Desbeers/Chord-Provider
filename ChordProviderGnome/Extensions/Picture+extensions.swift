//
//  Picture+extensions.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension Picture {

    /// Init the picture with a file from the Core bundle.
    /// - Parameter resource: The resource name.
    public init(core: String) {
        guard let url = ImageUtils.getImageFromBundle(core) else {
            self.init()
            return
        }
        self.init(url: url)
    }
}
