
/// Targets conforming to this protocol can be used to generate images
/// for the game.
public protocol ImageGenerator {
    func generateImage() -> Image
}
