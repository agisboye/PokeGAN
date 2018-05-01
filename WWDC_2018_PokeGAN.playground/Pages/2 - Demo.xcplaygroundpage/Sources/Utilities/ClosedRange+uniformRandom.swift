import Foundation

public extension ClosedRange where Bound: FloatingPoint {
    /// Returns a random number from a uniform distribution.
    public func uniformRandom() -> Bound {
        let max = UInt32.max
        return Bound(arc4random_uniform(max)) / Bound(max) * (upperBound - lowerBound) + lowerBound
    }
}
