//
//  ImageUtils.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//
// Thanks to https://medium.com/ios-os-x-development/prefetching-images-size-without-downloading-them-entirely-in-swift-5c2f8a6f82e9
//

import Foundation

/// Utilities to deal with images
/// - Note: Experimental code
public enum ImageUtils {
    // Just a placeholder
}

public extension ImageUtils {
    
    /// Get the URL of a SVG file in the bundle
    /// - Parameter name: The name of the file
    /// - Returns: An optional URL
    static func getImageFromBundle(_ name: String) -> URL? {
        if let url = Bundle.module.url(forResource: name, withExtension: "svg") {
            return url
        }
        return nil
    }
}

public extension ImageUtils {

    /// Get the format of an image from its data
    /// - Parameter data: The data of the image
    /// - Returns: The format of the image
    static func getImageFormat(data: Data) -> Format {
        var format: Format = .unknown
        /// Evaluate the format of the image
        var length = UInt16(0)
        (data as NSData).getBytes(&length, range: NSRange(location: 0, length: 2))
        switch length.byteSwapped {
        case 0xFFD8:
            format = .jpeg
        case 0x8950:
            format = .png
        case 0x4749:
            format = .gif
        default:
            break
        }
        return format
    }
}

public extension ImageUtils {

    /// Image format
    enum Format {
        /// jpeg image
        case jpeg
        /// png image
        case png
        /// gif image
        case gif
        /// unknown image
        case unknown
    }
}

public extension ImageUtils {

    /// Get the size of an image based on the image arguments
    /// - Parameters:
    ///   - size: The true size of the image
    ///   - arguments: The arguments of the image in the song
    /// - Returns: The `CGSize` of the image
    static func getImageSizeFromArguments(size: CGSize, arguments: ChordProParser.DirectiveArguments?) -> CGSize {
        var size = size
        var scale: Double = 1
        if let scaleArgument = arguments?[.scale], let value = Double(scaleArgument.replacing("%", with: "")) {
            /// - Note: Never let is be zero or else it will disappear from the SwiftUI View
            scale = max(value / 100, 0.1)
        }
        if let widthArgument = arguments?[.width], let value = Double(widthArgument) {
            /// Keep aspect ratio
            size.height *= (value / size.width)
            size.width = value
        }
        if let heightArgument = arguments?[.height], let value = Double(heightArgument) {
            /// Keep aspect ratio
            size.width *= (value / size.height)
            size.height = value
        }
        let scaled = CGSize(width: size.width * scale, height: size.height * scale)
        return scaled
    }
}

public extension ImageUtils {


    /// Get the size of an image based on its data
    /// - Parameter data: The data of the image
    /// - Returns: The size of the image, if found
    static func getImageSize(data: Data) -> CGSize? {

        let format = getImageFormat(data: data)

        switch format {

        case .png:
            var width: UInt32 = 0
            var height: UInt32 = 0
            (data as NSData).getBytes(&width, range: NSRange(location: 16, length: 4))
            (data as NSData).getBytes(&height, range: NSRange(location: 20, length: 4))

            return CGSize(width: Double(width.byteSwapped), height: Double(height.byteSwapped))

        case .gif:
            var width: UInt16 = 0
            var height: UInt16 = 0
            (data as NSData).getBytes(&width, range: NSRange(location: 6, length: 2))
            (data as NSData).getBytes(&height, range: NSRange(location: 8, length: 2))

            return CGSize(width: Double(width), height: Double(height))

        case .jpeg:
            var i: Int = 4
            var blockLength: UInt16 = UInt16(data[i]) * 256 + UInt16(data[i+1])
            repeat {
                /// Increase the file index to get to the next block
                i += Int(blockLength)
                /// Check to protect against segmentation faults
                if i >= data.count {
                    return nil
                }
                /// Check that we are truly at the start of another block
                if data[i] != 0xFF {
                    return nil
                }
                /// if marker type is SOF0, SOF1, SOF2
                if data[i+1] >= 0xC0 && data[i+1] <= 0xC3 {
                    /// "Start of frame" marker which contains the file size
                    var width: UInt16 = 0
                    var height: UInt16 = 0
                    (data as NSData).getBytes(&height, range: NSMakeRange(i + 5, 2))
                    (data as NSData).getBytes(&width, range: NSMakeRange(i + 7, 2))

                    let size = CGSize(width: Double(width.byteSwapped), height: Double(height.byteSwapped) )
                    return size
                } else {
                    /// Skip the block marker
                    i += 2
                    /// Go to the next block
                    blockLength = UInt16(data[i]) * 256 + UInt16(data[i+1])
                }
            } while (i < data.count)
            return nil

        default:
            return nil
        }
    }
}
