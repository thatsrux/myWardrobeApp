import ColorKit
import SwiftUI
import UIImageColors
import BackgroundRemoval

class Cloth: Identifiable, Codable {
    var id = UUID()
    
    var image: String?
    
    var mainColor: ColorData
    var secondColor: ColorData
    var thirdColor: ColorData
    
    var categoria: String = ""
    var nome: String = ""
    var taglia: String = ""
    var data:Date
    
    init(id:UUID, image:String,mainColor:ColorData,secondColor:ColorData,thirdColor:ColorData,categoria:String,nome:String,taglia:String,data:Data){
        self.id = id
        self.image = image
        self.mainColor = mainColor
        self.secondColor = secondColor
        self.thirdColor = thirdColor
        self.categoria = categoria
        self.nome = nome
        self.taglia = taglia
        self.data = Date.now
    }
    
    init(image: UIImage){
        self.image = image.toPngString()
        self.mainColor = ColorData(uiColor: .black)
        self.secondColor = ColorData(uiColor: .black)
        self.thirdColor = ColorData(uiColor: .black)
        self.data = Date.now
    }
    
    init(nome: String, categoria: String) {

        self.image = UIImage(imageLiteralResourceName: "juve1").toPngString()!
        self.mainColor = ColorData(uiColor: .white)
        self.secondColor = ColorData(uiColor: .white)
        self.thirdColor = ColorData(uiColor: .white)
        self.categoria = categoria
        self.nome = nome
        self.taglia = ""
        self.data = Date.now
    }
    
}
