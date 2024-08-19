import SwiftUI

class Cloth: Identifiable, Codable, Hashable{
    
    var id = UUID()

    var image: String?
    
    var mainColor: ColorData
    var secondColor: ColorData
    var thirdColor: ColorData
    
    var colorsNum: Int
    
    var categoria: Categoria = Categoria.NA
    var nome: String = ""
    var taglia: Taglia = Taglia.NA
    var stile: Stile = Stile.NA
    
    var data:Date
    
    var favourite:Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Cloth, rhs: Cloth) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id:UUID, image:String,mainColor:ColorData,secondColor:ColorData,thirdColor:ColorData,colorsNum:Int, categoria:Categoria,nome:String,taglia:Taglia,stile:Stile,data:Data,favourite:Bool){
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
        self.favourite = favourite
    }
    
    init(image: UIImage){
        self.image = image.toPngString()
        self.mainColor = ColorData(uiColor: .black)
        self.secondColor = ColorData(uiColor: .black)
        self.thirdColor = ColorData(uiColor: .black)
        self.colorsNum = 3
        self.data = Date.now
    }
    
}
