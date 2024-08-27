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
    
    init(hex: String) {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)

            let r, g, b, a: CGFloat
            switch hex.count {
            case 6:
                (r, g, b, a) = (
                    CGFloat((int >> 16) & 0xff) / 255.0,
                    CGFloat((int >> 8) & 0xff) / 255.0,
                    CGFloat(int & 0xff) / 255.0,
                    1.0
                )
            case 8:
                (r, g, b, a) = (
                    CGFloat((int >> 16) & 0xff) / 255.0,
                    CGFloat((int >> 8) & 0xff) / 255.0,
                    CGFloat(int & 0xff) / 255.0,
                    CGFloat((int >> 24) & 0xff) / 255.0
                )
            default:
                (r, g, b, a) = (1, 1, 1, 1)
            }

            self.red = r
            self.green = g
            self.blue = b
            self.alpha = a
        }

    
    func rgbaToHex() -> String {
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)
        
        if alpha < 1.0 {
            // Include alpha se è meno di 1.0 (parzialmente trasparente)
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            // Se alpha è 1.0 (pieno), si omette
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }

    var uiColor: UIColor { UIColor(red: red, green: green, blue: blue, alpha: alpha) }
    
    func toColor() -> Color {
        return Color(red: self.red, green: self.green, blue: self.blue)
    }
    
    var toString:String{
        return String(format: "#%02x%02x%02x", Int(red * 255), Int(green * 255),Int(blue * 255),Int(alpha * 255))
    }

}
