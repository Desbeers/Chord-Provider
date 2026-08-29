//
//  Image+extensions.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

extension Image {

    /// Init the image with a file from the bundle.
    /// - Parameter resource: The resource name.
    public init(bundle: String) {
        guard let url = Bundle.module.url(forResource: bundle, withExtension: "svg") else {
            self.init()
            return
        }
        self.init(url: url)
    }

    /// Init the image with a file from the Core bundle.
    /// - Parameter resource: The resource name.
    public init(core: String) {
        guard let url = ImageUtils.getImageFromBundle(core) else {
            self.init()
            return
        }
        self.init(url: url)
    }
}
