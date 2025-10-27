//
//  ImageUtils.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Utilities to deal with images
/// - Note: Experimental code
public enum ImageUtils {
    // Just a placeholder
}

public extension ImageUtils {
    
    /// Get the format of an image from its data
    /// - Parameter data: The data of the image
    /// - Returns: The format of the image
    public static func getImageFormat(data: Data) -> Format {
        var format: Format = .unknown
        /// Evaluate the format of the image
        var length = UInt16(0)
        (data as NSData).getBytes(&length, range: NSRange(location: 0, length: 2))
        switch CFSwapInt16(length) {
        case 0xFFD8:
            format = .jpeg
        case 0x8950:
            format = .png
        case 0x4749:
            format = .gif
        default:        break
        }
        return format
    }
}

public extension ImageUtils {
    
    /// Image format
    public enum Format {
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
    public static func getImageSizeFromArguments(size: CGSize, arguments: ChordProParser.DirectiveArguments?) -> CGSize {
        var size = size
        var scale: Double = 1
        if let scaleArgument = arguments?[.scale], let value = Double(scaleArgument.replacingOccurrences(of: "%", with: "")) {
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
    public static func getImageSize(data: Data) -> CGSize? {

        let format = getImageFormat(data: data)

        switch format {

        case .png:
            var w: UInt32 = 0; var h: UInt32 = 0;
            (data as NSData).getBytes(&w, range: NSRange(location: 16, length: 4))
            (data as NSData).getBytes(&h, range: NSRange(location: 20, length: 4))

            return CGSize(width: Double(Int(CFSwapInt32(w))), height: Double(Int(CFSwapInt32(h))))

        case .gif:
            var w: UInt16 = 0; var h: UInt16 = 0
            (data as NSData).getBytes(&w, range: NSRange(location: 6, length: 2))
            (data as NSData).getBytes(&h, range: NSRange(location: 8, length: 2))

            return CGSize(width: Double(Int(w)), height: Double(Int(h)))

        case .jpeg:
            var i: Int = 0
            var block_length: UInt16 = UInt16(data[i]) * 256 + UInt16(data[i+1])
            repeat {
                i += Int(block_length) //Increase the file index to get to the next block
                if i >= data.count { // Check to protect against segmentation faults
                    return nil
                }
                if data[i] != 0xFF { //Check that we are truly at the start of another block
                    return nil
                }
                if data[i+1] >= 0xC0 && data[i+1] <= 0xC3 { // if marker type is SOF0, SOF1, SOF2
                    // "Start of frame" marker which contains the file size
                    var w: UInt16 = 0; var h: UInt16 = 0;
                    (data as NSData).getBytes(&h, range: NSMakeRange(i + 5, 2))
                    (data as NSData).getBytes(&w, range: NSMakeRange(i + 7, 2))

                    let size = CGSize(width: Double(Int(CFSwapInt16(w))), height: Double(Int(CFSwapInt16(h))) );
                    return size
                } else {
                    // Skip the block marker
                    i+=2;
                    block_length = UInt16(data[i]) * 256 + UInt16(data[i+1]);   // Go to the next block
                }
            } while (i < data.count)
            return nil

        default:
            return nil
        }
    }
}
