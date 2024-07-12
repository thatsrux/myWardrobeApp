//
//  Classifier.swift
//  TemplateCoreMLSwiftUI
//
//  Created by Ignazio Finizio on 27/06/24.
//

import CoreML
import Vision
import CoreImage

struct Classifier {
    
    private(set) var results: String?
    private(set) var confidence: Float?
    
    mutating func detect(ciImage: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: ClothesClassifierDEMO(configuration: MLModelConfiguration()).model)
        else {
            return
        }

        let request = VNCoreMLRequest(model: model)
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        try? handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        } 
        
        if let firstResult = results.first {
            self.results = firstResult.identifier
            self.confidence = firstResult.confidence
        }
        
    }
    
}


