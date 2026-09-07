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
    /// - Parameter bundle: The resource name in the bundle.
    public init(bundle: String) {
        guard let url = Bundle.module.url(forResource: bundle, withExtension: "svg") else {
            self.init()
            return
        }
        self.init(url: url)
    }

    /// Init the image with a file from the Core bundle.
    /// - Parameter core: The resource name in the core bundle.
    public init(core: String) {
        guard let url = ImageUtils.getImageFromBundle(core) else {
            self.init()
            return
        }
        self.init(url: url)
    }
}
