#if os(iOS)
    import UIKit
    public typealias Image = UIImage
#elseif os(OSX)
    import AppKit
    public typealias Image = NSImage
    
    /// Adds a convenience initializer that allows
    /// an NSImage to be created with implicit size.
    extension Image {
        convenience init(cgImage: CGImage) {
            self.init(cgImage: cgImage, size: NSSize.zero)
        }
    }
    
#endif

extension Image {

    // Attempts to create an Image from an array of RGBA bytes.
    @nonobjc class func fromByteArrayRGBA(_ bytes: [UInt8], width: Int, height: Int) -> Image? {
        var image: Image?
        bytes.withUnsafeBytes { ptr in
            if let context = CGContext(
                data: UnsafeMutableRawPointer(mutating: ptr.baseAddress!),
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
                let cgImage = context.makeImage() {
                image = Image(cgImage: cgImage)
            }
        }
        return image
    }
    
}
