import ColorKit
import SwiftUI
import UIImageColors
import BackgroundRemoval

class Cloth: Identifiable, Codable {
    var id = UUID()
    
    let image: Data
    let imageNoBackground: Data
    
    var mainColor: ColorData
    var secondColor: ColorData
    var thirdColor: ColorData
    
    var categoria: String
    var nome: String
    var taglia: String
    
    init(id: UUID = UUID(), image: UIImage, imageNoBackground: UIImage, mainColor: ColorData, secondColor: ColorData, thirdColor: ColorData, categoria: String, nome: String, taglia: String) {
        self.id = id
        self.image = image.pngData()!
        self.imageNoBackground = imageNoBackground.pngData()!
        self.mainColor = mainColor
        self.secondColor = secondColor
        self.thirdColor = thirdColor
        self.categoria = categoria
        self.nome = nome
        self.taglia = taglia
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
}

