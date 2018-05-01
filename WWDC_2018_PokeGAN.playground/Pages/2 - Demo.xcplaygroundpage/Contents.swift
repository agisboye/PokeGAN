/*:
 [Previous](@previous)
 
 # Demo
 ## PokeGAN
 
 Thanks to the power of CoreML, we can run a GAN directly on our Apple device.
 
 This model has been trained on pictures of all 802 Pokémon figures. After several training sessions and meticulous adjustments, the generator is able to generate entirely new figures that the discriminator can no longer discern whether are real or fake.
 
 * Experiment:
 You'll be the discriminator (detective). Of the nine images, one is a real Pokémon while the remaining eight are generated by the GAN. Your job is to click the one you think is real. Are you unfamiliar with how the real figures look? No worries - so is the GAN.
 
*/

// The following snippet shows how an image is generated.
import PlaygroundSupport

struct PokeGenerator: ImageGenerator {
    
    /// Model class created by CoreML based on the model
    /// exported from the deep learning environment.
    let generator = Generator()
    
    func generateImage() -> Image {
        
        // Generate random noise to feed to the generator.
        let input = generateInputNoise(size: 100)

        // Ask the generator to create an image based on the noise.
        let result = try! generator.prediction(input1: input)
        
        // Convert the output to an image.
        let image = result.output1.image(offset: 1.0, scale: 255 / 2)
        
        return image!
        
    }
    
}

let generator = PokeGenerator()
let view = GameView(generator: generator)

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 
 ## Robot uprising?
 As you'll see, the resoluation of the generated images is not that great. If you squint your eyes and take a few steps back it'll look more convincing. However, take a moment to appreciate that these are images generated out of random noise, and the whole procedure is taught to the machine by itself. There is no drawing code creating these images.
 
 * Callout(Caveats):
 GANs are notoriously difficult to train properly and break very easily. There are a lot of knobs to turn and special care must taken to ensure a level playing field between the generator and the discriminator so one does not dominate the other. A lot of research is being put into improving the stability of GANs. I made an attempt to increase the image resolution from 32x32 pixels but couldn't find a set of parameters that would result in meaningful output.
 
 [The End](3%20-%20Acknowledgements)
 
 */