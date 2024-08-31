import SwiftUI

class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
     var typeClass: String {
        var res = ""
        if classifier.typeConfidence != nil {
                res = classifier.type!
        }
        return res
    }
    
    var typeConfidence: Float {
        var ret: Float = 0
        if let conf = classifier.typeConfidence {
                ret = conf
        }
        return ret
    }
    
    var styleClass: String {
       var res = ""
       if classifier.styleConfidence != nil {
               res = classifier.style!
       }
       return res
   }
   
   var styleConfidence: Float {
       var ret: Float = 0
       if let conf = classifier.styleConfidence {
               ret = conf
       }
       return ret
   }
        
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
    }
        
}
