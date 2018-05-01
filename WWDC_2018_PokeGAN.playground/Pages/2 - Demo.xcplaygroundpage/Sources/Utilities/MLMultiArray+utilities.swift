import Foundation
import CoreML

/// - Warning: This extension assumes that the array is backed by doubles.
/// If this is not the case, behavior is undefined.
public extension MLMultiArray {
    
    private var pointer: UnsafeMutablePointer<Double> {
        return UnsafeMutablePointer<Double>(OpaquePointer(dataPointer))
    }
    
    private var intStrides: [Int] {
        return strides as! [Int]
    }
    
    private var intShape: [Int] {
        return shape as! [Int]
    }
    
    private subscript(x: Int, y: Int, z: Int) -> Double {
        get {
            return pointer[x * intStrides[0] + y * intStrides[1] + z * intStrides[2]]
        }
    }
    
    /// Converts the array to an Image.
    /// The `offset` and `scale` parameters are used to de-process the values
    /// in case they have been processed to fit within some range.
    public func image(offset: Double, scale: Double) -> Image? {
        guard shape.count == 3, let (b, w, h) = toRawBytesRGBA(offset: offset, scale: scale) else {
            fatalError("Error converting MLMultiArray to Image.")
        }
        return Image.fromByteArrayRGBA(b, width: w, height: h)
    }
    
    /// Converts the array to an array of pixels.
    private func toRawBytesRGBA(offset: Double, scale: Double) -> (bytes: [UInt8], width: Int, height: Int)? {
        
        guard shape.count == 3, shape[0] == 3 else {
            print("Array must have shaped (3, height, width). Images with any other number of channels than 3 are not supported.")
            return nil
        }
        
        let height = intShape[1]
        let width = intShape[2]
        var bytes = [UInt8](repeating: 0, count: height * width * 4)

        // Build pixel array
        for h in 0..<height {
            for w in 0..<width {
                let r = (self[0, h, w] + offset) * scale
                let g = (self[1, h, w] + offset) * scale
                let b = (self[2, h, w] + offset) * scale
                let offset = h * width * 4 + w * 4
                bytes[offset + 0] = UInt8(clamp(r, min: 0, max: 255))
                bytes[offset + 1] = UInt8(clamp(g, min: 0, max: 255))
                bytes[offset + 2] = UInt8(clamp(b, min: 0, max: 255))
                bytes[offset + 3] = 255
            }
        }
        
        return (bytes, width, height)

    }
    
}
