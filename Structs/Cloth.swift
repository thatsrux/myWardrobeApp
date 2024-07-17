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

struct ColorData: Codable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    
    init(_ color: ColorData){
        self.red = color.red
        self.green = color.green
        self.blue = color.blue
        self.alpha = color.alpha
    }
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(uiColor: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    var uiColor: UIColor { UIColor(red: red, green: green, blue: blue, alpha: alpha) }
    
    var toString:String{
        return String(format: "#%02x%02x%02x", Int(red * 255), Int(green * 255),Int(blue * 255),Int(alpha * 255))
    }

}
