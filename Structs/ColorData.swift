import SwiftUI

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
    
    func toColor() -> Color {
        return Color(red: self.red, green: self.green, blue: self.blue)
    }
    
    var toString:String{
        return String(format: "#%02x%02x%02x", Int(red * 255), Int(green * 255),Int(blue * 255),Int(alpha * 255))
    }

}
