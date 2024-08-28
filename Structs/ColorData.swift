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
        let cgColor = CGColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return cgColor.toHex() ?? ""
    }
    
    var uiColor: UIColor { UIColor(red: red, green: green, blue: blue, alpha: alpha) }
    
    func toColor() -> Color {
        return Color(red: self.red, green: self.green, blue: self.blue)
    }
    
    var toString:String{
        return String(format: "#%02x%02x%02x", Int(red * 255), Int(green * 255),Int(blue * 255),Int(alpha * 255))
    }

}


extension CGColor {
    func toHex() -> String? {
        guard let components = components else { return nil }
        
        if components.count == 2 {
            let value = components[0]
            let alpha = components[1]
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(alpha*255)), lroundf(Float(value*255)), lroundf(Float(value*255)), lroundf(Float(value*255)))
        }
        
        guard components.count == 4 else { return nil }
        
        let red   = components[0]
        let green = components[1]
        let blue  = components[2]
        let alpa  = components[3]
        
        let hexString = String(format: "#%02lX%02lX%02lX%02lX",lroundf(Float(alpa*255)), lroundf(Float(red*255)), lroundf(Float(green*255)), lroundf(Float(blue*255)))
        
        return hexString
    }
}
