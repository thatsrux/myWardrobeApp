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
    
    private(set) var type: String?
    private(set) var typeConfidence: Float?
    
    private(set) var style: String?
    private(set) var styleConfidence: Float?
    
    mutating func detect(ciImage: CIImage) {
        
        guard let typeModel = try? VNCoreMLModel(for: ClothesClassifierDEMO(configuration: MLModelConfiguration()).model)
        else {
            return
        }

        let typeRequest = VNCoreMLRequest(model: typeModel)
        
        let typeHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        try? typeHandler.perform([typeRequest])
        
        guard let typeResults = typeRequest.results as? [VNClassificationObservation] else {
            return
        }
        
        if let firstResult = typeResults.first {
            self.type = firstResult.identifier
            self.typeConfidence = firstResult.confidence
        }
        
        guard let styleModel = try? VNCoreMLModel(for: StyleClassificatorTEST_4(configuration: MLModelConfiguration()).model)
        else {
            return
        }

        let styleRequest = VNCoreMLRequest(model: styleModel)
        
        let styleHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        try? styleHandler.perform([styleRequest])
        
        guard let styleResults = styleRequest.results as? [VNClassificationObservation] else {
            return
        }
        
        if let firstResult = styleResults.first {
            self.style = firstResult.identifier
            self.styleConfidence = firstResult.confidence
        }
        
    }
    
}


