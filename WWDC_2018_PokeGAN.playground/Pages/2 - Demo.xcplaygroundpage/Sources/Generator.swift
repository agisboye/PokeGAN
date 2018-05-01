//
// Generator.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class GeneratorInput : MLFeatureProvider {

    /// input1 as 100 element vector of doubles
    public var input1: MLMultiArray
    
    public var featureNames: Set<String> {
        get {
            return ["input1"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input1") {
            return MLFeatureValue(multiArray: input1)
        }
        return nil
    }
    
    public init(input1: MLMultiArray) {
        self.input1 = input1
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class GeneratorOutput : MLFeatureProvider {

    /// output1 as 3 x 32 x 32 3-dimensional array of doubles
    public let output1: MLMultiArray
    
    public var featureNames: Set<String> {
        get {
            return ["output1"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "output1") {
            return MLFeatureValue(multiArray: output1)
        }
        return nil
    }
    
    public init(output1: MLMultiArray) {
        self.output1 = output1
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class Generator {
    public var model: MLModel

    /**
        Construct a model with explicit path to mlmodel file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        let bundle = Bundle(for: Generator.self)
        let assetPath = bundle.url(forResource: "Generator", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as GeneratorInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as GeneratorOutput
    */
    public func prediction(input: GeneratorInput) throws -> GeneratorOutput {
        let outFeatures = try model.prediction(from: input)
        let result = GeneratorOutput(output1: outFeatures.featureValue(for: "output1")!.multiArrayValue!)
        return result
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - input1 as 100 element vector of doubles
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as GeneratorOutput
    */
    public func prediction(input1: MLMultiArray) throws -> GeneratorOutput {
        let input_ = GeneratorInput(input1: input1)
        return try self.prediction(input: input_)
    }
}
