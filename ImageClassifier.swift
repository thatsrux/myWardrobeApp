//
//  ImageClassifier.swift
//  TemplateCoreMLSwiftUI
//
//  Created by Ignazio Finizio on 27/06/24.
//

import SwiftUI

class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
     var imageClass: String {
        var res = ""
        if classifier.confidence != nil {
                res = classifier.results!
        }
        return res
    }
    
    var imageConfidence: Float {
        var ret: Float = 0
        if let conf = classifier.confidence {
                ret = conf
        }
        return ret
    }
        
    // MARK: Intent(s)
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
    }
        
}
