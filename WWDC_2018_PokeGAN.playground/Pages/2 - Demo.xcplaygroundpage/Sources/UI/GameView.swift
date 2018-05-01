import AppKit

public class GameView: NSView {
    
    let generator: ImageGenerator
    
    /// Number of sprites of real Pokémon that are included
    /// in this playground. Adding all 802 makes the playground
    /// unbearably slow, so we limit it to a subset.
    let realSpriteCount: UInt32 = 20
    
    /// The index that points to the real image.
    var currentRealImageIndex = 0
    
    var discriminatorScore = 0 {
        didSet {
            discriminatorScoreLabel.stringValue = "🕵🏼‍♀️ \(discriminatorScore)"
        }
    }
    var generatorScore = 0 {
        didSet {
            generatorScoreLabel.stringValue = "\(generatorScore) 🤖"
        }
    }
    
    lazy var discriminatorScoreLabel: NSTextField = {
        let label = NSTextField()
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        label.font = NSFont.systemFont(ofSize: 32.0)
        label.alignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var generatorScoreLabel: NSTextField = {
        let label = NSTextField()
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        label.font = NSFont.systemFont(ofSize: 32.0)
        label.alignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageButtons = (0..<9).map { i -> NSButton in
        let button = NSButton()
        button.tag = i
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.backgroundColor = NSColor.white.cgColor
        button.layer?.borderColor = NSColor.lightGray.cgColor
        button.layer?.borderWidth = 1.0

        button.imageScaling = .scaleAxesIndependently
        button.target = self
        button.action = #selector(imageTapped(sender:))
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64.0),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64.0)
            ])
        
        return button
    }
    
    lazy var updateButton: NSButton = {
        let button = NSButton()
        button.frame = CGRect(x: 0, y: 0, width: 160, height: 40)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "Generate new Pokémon"
        button.wantsLayer = true
        button.layer?.cornerRadius = 6.0
        button.target = self
        button.action = #selector(updateGallery)
        return button
    }()
    
    public init(generator: ImageGenerator) {
        self.generator = generator
        super.init(frame: NSRect(x: 0, y: 0, width: 380, height: 420))
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        layer?.borderColor = NSColor(red: 53/255, green: 100/255, blue: 174/255, alpha: 1.0).cgColor
        layer?.borderWidth = 7.0
        
        createView()
        updateGallery()
        
        discriminatorScore = 0
        generatorScore += 1
        
    }
    
    public required init?(coder decoder: NSCoder) {
        fatalError()
        super.init(coder: decoder)
    }
    
    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        discriminatorScore = 0
        generatorScore = 0
    }
    
    /// Creates the necessary view components
    /// and sets up constraints.
    func createView() {
        let horizontalStack1 = NSStackView(views: Array(imageButtons[0...2]))
        let horizontalStack2 = NSStackView(views: Array(imageButtons[3...5]))
        let horizontalStack3 = NSStackView(views: Array(imageButtons[6...8]))
        
        let verticalStack = NSStackView(views: [horizontalStack1, horizontalStack2, horizontalStack3])
        verticalStack.frame = NSRect(x: 0, y: 0, width: 480, height: 640)
        verticalStack.orientation = .vertical
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(discriminatorScoreLabel)
        addSubview(generatorScoreLabel)
        addSubview(verticalStack)
        addSubview(updateButton)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: discriminatorScoreLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 25),
            NSLayoutConstraint(item: discriminatorScoreLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 25),
            
            NSLayoutConstraint(item: generatorScoreLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 25),
            NSLayoutConstraint(item: generatorScoreLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -25),
            
            NSLayoutConstraint(item: verticalStack, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: verticalStack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: updateButton, attribute: .centerX, relatedBy: .equal, toItem: verticalStack, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: updateButton, attribute: .top, relatedBy: .equal, toItem: verticalStack, attribute: .bottom, multiplier: 1, constant: 25),
            ])
    }
    
    /// Updates the gallery with newly generated images.
    @objc func updateGallery() {
        
        // Place the real figure
        let realImageName = arc4random_uniform(realSpriteCount)
        let realImagePath = Bundle.main.path(forResource: "\(realImageName)", ofType: "png", inDirectory: "Sprites")
        let realImage = Image(contentsOfFile: realImagePath!)
        let realImagePosition = Int(arc4random_uniform(9))
        
        imageButtons[realImagePosition].image = realImage
        currentRealImageIndex = realImagePosition
        
        // Place the generated figures
        for i in 0..<9 where i != realImagePosition {
            imageButtons[i].image = generator.generateImage()
        }
        
    }
    
    /// Handles when the user taps on one of the images.
    @objc func imageTapped(sender: NSButton) {
        
        if sender.tag == currentRealImageIndex {
            // Correct
            discriminatorScore += 1
        } else {
            // Incorrect
            generatorScore += 1
        }
        
        updateGallery()
        
    }
    
}
