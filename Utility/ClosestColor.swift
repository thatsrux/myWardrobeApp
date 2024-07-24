import UIKit
import ColorKit

// Assegnazione di nomi ai colori
// Per i colori più scuri sono presenti più variazioni
let colorMap: [String: UIColor] = [
    "Rosso": UIColor.red,
    // Variazioni del rosso
    "Rosso2": UIColor(red: 0.57, green: 0.24, blue: 0.24, alpha: 1.0),
    "Bordeaux": UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0),
    "Rosa": UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0),
    "Arancione": UIColor.orange,
    // Variazioni dell'arancione
    "Arancione2": UIColor(red: 0.76, green: 0.4, blue: 0.2, alpha: 1.0),
    "Giallo Uovo": UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0),
    "Giallo": UIColor.yellow,
    //Variazioni del giallo
    "Giallo2": UIColor(red: 0.9, green: 0.8, blue: 0.4, alpha: 1.0),
    "Crema": UIColor(red: 1.0, green: 0.99, blue: 0.82, alpha: 1.0),
    "Lime": UIColor(red: 0.7, green: 1, blue: 0, alpha: 1.0),
    //Variazioni del lime
    "Lime2": UIColor(red: 0.73, green: 0.86, blue: 0.58, alpha: 1.0),
    "Lime3": UIColor(red: 0.88, green: 0.93, blue: 0.84, alpha: 1.0),
    "Verde Fluo": UIColor.green,
    "Verde Foglia": UIColor(red: 0.23, green: 0.53, blue: 0.22, alpha: 1.0),
    "Verde Scuro": UIColor(red: 0.1, green: 0.28, blue: 0.13, alpha: 1.0),
    "Verde Oliva": UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0),
    "Avio": UIColor(red: 0.43, green: 0.6, blue: 0.75, alpha: 1.0),
    "Avio Scuro": UIColor(red: 0.33, green: 0.43, blue: 0.62, alpha: 1.0),
    // Variazioni dell'avio scuro
    "Avio Scuro2": UIColor(red: 0.33, green: 0.43, blue: 0.62, alpha: 1.0),
    "Avio Scuro3": UIColor(red: 0.11, green: 0.3, blue: 0.38, alpha: 1.0),
    "Avio Scuro4": UIColor(red: 0.2, green: 0.5, blue: 0.6, alpha: 1.0),
    "Avio Scuro5": UIColor(red: 0.46, green: 0.5, blue: 0.6, alpha: 1.0),
    "Celeste": UIColor(red: 0.8, green: 0.95, blue: 0.97, alpha: 1.0),
    // Variazioni del celeste
    "Celeste2": UIColor(red: 0.65, green: 0.9, blue: 0.98, alpha: 1.0),
    "Celeste3": UIColor(red: 0.25, green: 0.56, blue: 0.8, alpha: 1.0),
    "Celeste Scuro": UIColor(red: 0, green: 0.83, blue: 1, alpha: 1.0),
    // Variazioni del celeste scuro
    "Celeste Scuro2": UIColor(red: 0.32, green: 0.75, blue: 0.84, alpha: 1.0),
    "Blu": UIColor.blue,
    // Variazioni del blu
    "Blu2": UIColor(red: 0.063, green: 0.18, blue: 0.46, alpha: 1.0),
    "Blu3": UIColor(red: 0.16, green: 0.37, blue: 0.9, alpha: 1.0),
    "Blu4": UIColor(red: 0.3, green: 0.5, blue: 0.96, alpha: 1.0),
    "Blu Navy": UIColor(red: 0.03, green: 0.11, blue: 0.33, alpha: 1.0),
    // Variazioni del blu navy
    "Blu Navy2": UIColor(red: 0.16, green: 0.04, blue: 0.44, alpha: 1.0),
    "Blu Notte": UIColor(red: 0.13, green: 0.13, blue: 0.25, alpha: 1.0),
    // Variazioni del blu notte
    "Blu Notte2": UIColor(red: 0.058, green: 0.02, blue: 0.22, alpha: 1.0),
    "Viola": UIColor.purple,
    // Variazioni del viola
    "Viola2": UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0),
    "Viola4": UIColor(red: 0.25, green: 0.07, blue: 0.34, alpha: 1.0),
    "Viola5": UIColor(red: 0.165, green: 0, blue: 0.23, alpha: 1.0),
    "Viola6": UIColor(red: 0.27, green: 0.22, blue: 0.4, alpha: 1.0),
    "Viola7": UIColor(red: 0.55, green: 0.2, blue: 0.7, alpha: 1.0),
    "Viola8": UIColor(red: 0.4, green: 0, blue: 0.4, alpha: 1.0),
    "Fuxia Fluo": UIColor.magenta,
    "Fuxia": UIColor(red: 0.8, green: 0.05, blue: 0.5, alpha: 1.0),
    // Variazioni del fucsia
    "Fuxia2": UIColor(red: 0.44, green: 0.2, blue: 0.4, alpha: 1.0),
    "Lilla": UIColor(red: 0.84, green: 0.6, blue: 0.97, alpha: 1.0),
    "Beige": UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0),
    "Marrone": UIColor.brown,
    // Variazioni del marrone
    "Marrone2": UIColor(red: 0.675, green: 0.475, blue: 0.3, alpha: 1.0),
    "Marrone Cammello": UIColor(red: 0.63, green: 0.5, blue: 0.42, alpha: 1.0),
    "Marrone Scuro": UIColor(red: 0.32, green: 0.2, blue: 0.05, alpha: 1.0),
    "Grigio": UIColor.gray,
    "Nero": UIColor.black,
    "Bianco": UIColor.white
    
    // COLORI RIMOSSI
    
    //"Viola3": UIColor(red: 0.25, green: 0.18, blue: 0.25, alpha: 1.0),
    //"Viola7": UIColor(red: 0.27, green: 0, blue: 0.4, alpha: 1.0),
    //"Rosa carne": UIColor(red: 0.8, green: 0.3, blue: 0.5, alpha: 1.0),
    //"Avorio": UIColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0),
    //"Turchese": UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0),
    //"Porpora": UIColor(red: 0.3, green: 0.08, blue: 0.16, alpha: 1.0),
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

func closestColor(to color: UIColor) -> Colore {
    var closestColorName: String?
    var smallestDifference = CGFloat.infinity

    // Si valuta la differenza dei colori presi in esame con tutti i colori presenti nella mappa.
    // Viene restituito il colore con la differenza minore
    for (name, testColor) in colorMap {
        let diff = color.CIE94(compare: testColor)
        if diff < smallestDifference {
            smallestDifference = diff
            closestColorName = name
        }
    }
    
    // I colori che hanno variazioni vengono raggruppati
    closestColorName = groupColors(closestColorName: closestColorName!)
    
    // Se il colore ha molte variazioni o colori simili, viene utilizzato l'algoritmo CIEDE2000, che risulta più preciso nelle piccole variazioni
    if closestColorName == "Blu navy" || closestColorName == "Blu notte" || closestColorName == "Viola" || closestColorName == "Nero" || closestColorName == "Grigio" || closestColorName == "Beige" {
        for (name, testColor) in colorMap {
            let diff = color.CIEDE2000(compare: testColor)
            if diff < smallestDifference {
                smallestDifference = diff
                closestColorName = name
            }
        }
    }
    
    // I colori vengono raggruppati nuovamente
    closestColorName = groupColors(closestColorName: closestColorName!)

    return Colore(rawValue: closestColorName!) ?? .na
}

func groupColors(closestColorName: String) -> String {
    return closestColorName.filter { !$0.isNumber }
}
