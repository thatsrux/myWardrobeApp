import ColorKit
import SwiftUI
import UIImageColors
import BackgroundRemoval

class Cloth: Identifiable, Codable, Hashable{
    
    var id = UUID()

    var image: String?
    
    var mainColor: ColorData
    var secondColor: ColorData
    var thirdColor: ColorData
    
    var colorsNum: Int
    
    var categoria: String = ""
    var nome: String = ""
    var taglia: String = ""
    var stile: String = ""
    
    var data:Date
    
    enum stile {
        case casual, formale, sportivo
    }
    
    enum categoria {
        case camicia, canotta, cappello, giacca, giubbino, felpa, maglione, pantaloncini, pantalone, scarpe, tshirt
    }
    
    enum colore {
        case rosso, rossoscuro, rosa, arancione, oro, giallo, crema, lime, verde, verdefoglia, verdescuro, oliva, celeste, celestescuro, blu,
             blumarino, bluscuro, viola, magenta, fucsia, beige, marrone, marronescuro, grigio, nero, bianco
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Cloth, rhs: Cloth) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    init(id:UUID, image:String,mainColor:ColorData,secondColor:ColorData,thirdColor:ColorData,colorsNum:Int, categoria:String,nome:String,taglia:String,stile:String,data:Data){
        self.id = id
        self.image = image
        self.mainColor = mainColor
        self.secondColor = secondColor
        self.thirdColor = thirdColor
        self.colorsNum = colorsNum
        self.categoria = categoria
        self.nome = nome
        self.taglia = taglia
        self.stile = stile
        self.data = Date.now
    }
    
    init(image: UIImage){
        self.image = image.toPngString()
        self.mainColor = ColorData(uiColor: .black)
        self.secondColor = ColorData(uiColor: .black)
        self.thirdColor = ColorData(uiColor: .black)
        self.colorsNum = 3
        self.data = Date.now
    }
    
    init(nome: String, categoria: String) {

        self.image = UIImage(imageLiteralResourceName: "juve1").toPngString()!
        self.mainColor = ColorData(uiColor: .white)
        self.secondColor = ColorData(uiColor: .white)
        self.thirdColor = ColorData(uiColor: .white)
        self.colorsNum = 3
        self.categoria = categoria
        self.nome = nome
        self.taglia = ""
        self.data = Date.now
    }
    
}
