import UIKit
import ColorKit

let colorMap: [String: UIColor] = [
    "Rosso": UIColor.red,
    "Rosso scuro": UIColor(red: 0.33, green: 0.07, blue: 0.03, alpha: 1.0),
    "Rosa": UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0),
    "Arancione": UIColor(red: 0.76, green: 0.4, blue: 0.2, alpha: 1.0),
    "Oro": UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0),
    "Giallo": UIColor.yellow,
    "Crema": UIColor(red: 1.0, green: 0.99, blue: 0.82, alpha: 1.0),
    "Lime": UIColor(red: 0.72, green: 0.86, blue: 0.58, alpha: 1.0),
    "Verde": UIColor.green,
    "Verde foglia": UIColor(red: 0.23, green: 0.53, blue: 0.22, alpha: 1.0),
    "Verde scuro": UIColor(red: 0.1, green: 0.28, blue: 0.13, alpha: 1.0),
    "Oliva": UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0),
    "Celeste scuro": UIColor(red: 0.11, green: 0.3, blue: 0.38, alpha: 1.0),
    "Celeste scuro2": UIColor(red: 0.33, green: 0.43, blue: 0.62, alpha: 1.0),
    //"Turchese": UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0),
    "Celeste": UIColor(red: 0.43, green: 0.6, blue: 0.75, alpha: 1.0),
    "Lavanda": UIColor(red: 0.67, green: 0.55, blue: 0.97, alpha: 1.0),
    "Blu": UIColor.blue,
    "Blu marino": UIColor(red: 0.03, green: 0.11, blue: 0.33, alpha: 1.0),
    "Viola": UIColor.purple,
    "Viola scuro": UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0),
    "Magenta": UIColor.magenta,
    "Fucsia": UIColor(red: 0.8, green: 0.3, blue: 0.5, alpha: 1.0),
    "Beige": UIColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0),
    "Cammello": UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 1.0),
    "Marrone": UIColor.brown,
    "Marrone2": UIColor(red: 0.675, green: 0.475, blue: 0.3, alpha: 1.0),
    "Marrone scuro": UIColor(red: 0.32, green: 0.2, blue: 0.05, alpha: 1.0),
    "Grigio": UIColor.gray,
    "Nero": UIColor.black,
    "Bianco": UIColor.white
    //"Celeste": UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0),
    //"Porpora": UIColor(red: 0.3, green: 0.08, blue: 0.16, alpha: 1.0),
    //"Blu scuro": UIColor(red: 0.2, green: 0.18, blue: 0.25, alpha: 1.0),
    //"Bronze": UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0),
    //"Charcoal": UIColor(red: 0.21, green: 0.27, blue: 0.31, alpha: 1.0),
    //"Coffee Brown": UIColor(red: 0.44, green: 0.31, blue: 0.22, alpha: 1.0),
    //"Copper": UIColor(red: 0.72, green: 0.45, blue: 0.2, alpha: 1.0),
    //"Grey Melange": UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0),
    //"Khaki": UIColor(red: 0.76, green: 0.69, blue: 0.57, alpha: 1.0),
    //"Kavanda": UIColor(red: 0.9, green: 0.9, blue: 0.98, alpha: 1.0),
    //"Maroon": UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0),
    //"Mauve": UIColor(red: 0.88, green: 0.69, blue: 1.0, alpha: 1.0),
    //"Metallic": UIColor(red: 0.81, green: 0.83, blue: 0.82, alpha: 1.0),
    //"Mushroom Brown": UIColor(red: 0.65, green: 0.58, blue: 0.5, alpha: 1.0),
    //"Mustard": UIColor(red: 1.0, green: 0.86, blue: 0.35, alpha: 1.0),
    //"NA": UIColor.clear, // Placeholder
    //"Nude": UIColor(red: 0.92, green: 0.78, blue: 0.62, alpha: 1.0),
    //"Off White": UIColor(red: 0.99, green: 0.98, blue: 0.93, alpha: 1.0),
    //"Peach": UIColor(red: 1.0, green: 0.9, blue: 0.71, alpha: 1.0),
    //"Rosato": UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0),
    //"Rust": UIColor(red: 0.72, green: 0.26, blue: 0.06, alpha: 1.0),
    //"Silver": UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0),
    //"Skin": UIColor(red: 1.0, green: 0.82, blue: 0.71, alpha: 1.0),
    //"Steel": UIColor(red: 0.69, green: 0.77, blue: 0.87, alpha: 1.0),
    //"Tan": UIColor(red: 0.82, green: 0.71, blue: 0.55, alpha: 1.0),
    //"Taupe": UIColor(red: 0.28, green: 0.24, blue: 0.2, alpha: 1.0),
]

func closestColor(to color: UIColor) -> String {
    var closestColorName: String?
    var smallestDifference = CGFloat.infinity

    for (name, testColor) in colorMap {
        let diff = color.CIE94(compare: testColor)
        if diff < smallestDifference {
            smallestDifference = diff
            closestColorName = name
        }
    }
    if closestColorName == "Viola scuro" {
        closestColorName = "Viola"
    }
    if closestColorName == "Marrone2" {
        closestColorName = "Marrone"
    }
    if closestColorName == "Lavanda" {
        closestColorName = "Celeste"
    }
    if closestColorName == "Celeste scuro2" {
        closestColorName = "Celeste scuro"
    }


    return closestColorName ?? "NA"
}
