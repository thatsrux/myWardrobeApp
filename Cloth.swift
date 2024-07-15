import ColorKit
import SwiftUI
import UIImageColors
import BackgroundRemoval

class Cloth {
    let image: UIImage
    let imageNoBackground: UIImage
    
    var mainColor: Color
    var secondColor: Color?
    var thirdColor: Color?
    
    var categoria: String
    var nome:String
    var taglia:String
    
    let backgroundRemoval = BackgroundRemoval()
    
    init(image: UIImage) {
        self.image = image
        do {
            self.imageNoBackground = try backgroundRemoval.removeBackground(image: image)
        }catch {
            fatalError(error.localizedDescription)
        }
        let colors = imageNoBackground.getColors()
        mainColor = Color((colors?.background)!)
        if let second = colors?.primary {
            secondColor = Color(second)
        }
        if let third = colors?.secondary {
            thirdColor = Color(third)
        }
        self.categoria = ""
        self.nome = ""
        self.taglia = ""
    }
    
    init(nome:String,categoria:String){
        self.nome = nome
        self.categoria = categoria
        self.taglia = ""
        
        self.mainColor = Color(.white)
        self.secondColor = Color(.white)
        self.thirdColor = Color(.white)
        
        self.image = UIImage()
        self.imageNoBackground = UIImage()
    }
}
