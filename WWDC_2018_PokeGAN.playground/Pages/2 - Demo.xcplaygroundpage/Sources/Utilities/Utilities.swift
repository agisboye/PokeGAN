import Foundation
import CoreML

public func clamp<T: Comparable>(_ x: T, min: T, max: T) -> T {
    if x < min { return min }
    if x > max { return max }
    return x
}

/// Generates random real numbers between -1.0 and 1.0
/// from a uniform distribution.
public func generateInputNoise(size: Int) -> MLMultiArray {
    
    guard size > 0 else { fatalError("Size must be positive integer") }
    
    let input = try! MLMultiArray(shape: [NSNumber(value: size)], dataType: .double)

    for i in (0..<size) {
        input[i] = NSNumber(floatLiteral: randomGaussian().0)
    }

    return input
    
}

/// Generates a pair of random numbers with a standard normal distribution
/// using the Box-Muller transform.
func randomGaussian() -> (Double, Double) {
    
    let u1 = (0...1).uniformRandom()
    let u2 = (0...1).uniformRandom()
    
    let r1 = sqrt(-2 * log(u1))
    let r2 = 2 * .pi * u2
    
    let z0 = r1 * cos(r2)
    let z1 = r1 * sin(r2)
    
    return (z0, z1)
    
}
