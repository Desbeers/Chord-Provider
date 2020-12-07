//
//  TestFile.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 06/12/2020.
//

import Foundation
import UIKit
import SwiftUI

struct TestView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIImageView {
        
        let imageView = UIImageView()
        
        let chordPosition = GuitarChords.all.matching(key: .a).matching(suffix: .seven).first!
        let frame = CGRect(x: 0, y: 0, width: 100, height: 150)
        let layer = chordPosition.layer(rect: frame, showFingers: true, showChordName: true, forScreen: true)
        imageView.image = layer.imageFromLayer()
        
        //imageView.image = self.originalImage

        return imageView;
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
    }
}

extension CALayer {

    func imageFromLayer() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, 0)

        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else {
          return nil
        }

        self.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}
