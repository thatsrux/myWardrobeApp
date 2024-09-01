import SwiftUI
// Assegnazione di nomi ai colori
// Per i colori più scuri sono presenti più variazioni
let colorMap: [String: UIColor] = [
    "Rosso": UIColor.red,
    // Variazioni del rosso
    "Rosso2": UIColor(red: 0.57, green: 0.24, blue: 0.24, alpha: 1.0),
    "Bordeaux": UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0),
    "Bordeaux2": UIColor(red: 0.3, green: 0.1, blue: 0.1, alpha: 1.0),
    "Rosa": UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0),
    "Rosa2": UIColor(red: 1.0, green: 0.72, blue: 0.7, alpha: 1.0),
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
    "Verde Scuro2": UIColor(red: 0.34, green: 0.33, blue: 0.18, alpha: 1.0),
    "Verde Oliva": UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0),
    "Avio": UIColor(red: 0.43, green: 0.6, blue: 0.75, alpha: 1.0),
    "Avio Scuro": UIColor(red: 0.33, green: 0.43, blue: 0.62, alpha: 1.0),
    // Variazioni dell'avio scuro
    "Avio Scuro2": UIColor(red: 0.33, green: 0.43, blue: 0.62, alpha: 1.0),
    "Avio Scuro3": UIColor(red: 0.11, green: 0.3, blue: 0.38, alpha: 1.0),
    "Avio Scuro4": UIColor(red: 0.2, green: 0.5, blue: 0.6, alpha: 1.0),
    "Avio Scuro5": UIColor(red: 0.46, green: 0.5, blue: 0.6, alpha: 1.0),
    "Avio Scuro6": UIColor(red: 0, green: 0.6, blue: 0.55, alpha: 1.0),
    "Celeste": UIColor(red: 0.8, green: 0.95, blue: 0.97, alpha: 1.0),
    // Variazioni del celeste
    "Celeste2": UIColor(red: 0.65, green: 0.9, blue: 0.98, alpha: 1.0),
    "Celeste3": UIColor(red: 0.25, green: 0.56, blue: 0.8, alpha: 1.0),
    "Celeste4": UIColor(red: 0.75, green: 0.8, blue: 0.9, alpha: 1.0), //NUOVO
    "Celeste Scuro": UIColor(red: 0, green: 0.83, blue: 1, alpha: 1.0),
    // Variazioni del celeste scuro
    "Celeste Scuro2": UIColor(red: 0.32, green: 0.75, blue: 0.84, alpha: 1.0),
    "Celeste Scuro3": UIColor(red: 0.2, green: 0.46, blue: 0.75, alpha: 1.0),
    "Celeste Scuro4": UIColor(red: 0.54, green: 0.8, blue: 0.9, alpha: 1.0),
    "Celeste Scuro5": UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1.0), //NUOVO, PREVALENTEMENTE PER LE JORDAN UNIVERSITY
    "Blu": UIColor.blue,
    // Variazioni del blu
    "Blu2": UIColor(red: 0.063, green: 0.18, blue: 0.46, alpha: 1.0),
    "Blu3": UIColor(red: 0.16, green: 0.37, blue: 0.9, alpha: 1.0),
    "Blu4": UIColor(red: 0.3, green: 0.5, blue: 0.96, alpha: 1.0),
    "Blu5": UIColor(red: 0.23, green: 0.35, blue: 0.55, alpha: 1.0),
    "Blu Navy": UIColor(red: 0.03, green: 0.11, blue: 0.33, alpha: 1.0),
    // Variazioni del blu navy
    "Blu Navy2": UIColor(red: 0.16, green: 0.04, blue: 0.44, alpha: 1.0),
    "Blu Notte": UIColor(red: 0.13, green: 0.13, blue: 0.25, alpha: 1.0),
    // Variazioni del blu notte
    "Blu Notte2": UIColor(red: 0.058, green: 0.02, blue: 0.22, alpha: 1.0),
    "Blu Notte3": UIColor(red: 0.09, green: 0.1, blue: 0.2, alpha: 1.0),
    "Viola": UIColor.purple,
    // Variazioni del viola
    "Viola2": UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0),
    "Viola3": UIColor(red: 0.3, green: 0.2, blue: 0.45, alpha: 1.0),
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
    "Marrone Cammello": UIColor(red: 0.69, green: 0.52, blue: 0.42, alpha: 1.0),
    "Marrone Scuro": UIColor(red: 0.32, green: 0.2, blue: 0.05, alpha: 1.0),
    "Grigio": UIColor.gray,
    "Grigio2": UIColor(red: 0.64, green: 0.65, blue: 0.69, alpha: 1.0),
    "Nero": UIColor.black,
    "Nero2": UIColor(red: 0.17, green: 0.12, blue: 0.05, alpha: 1.0),
    "Bianco": UIColor.white,
    "Bianco2": UIColor(red: 0.93, green: 0.92, blue: 0.92, alpha: 1.0),
]

func closestColor(to color: UIColor) -> Colore {
    var closestColorName: String?
    var smallestDifference = CGFloat.infinity
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    let blueConstant = 0.25
    let differenceConstant = 0.035
    
    if blue <= blueConstant && red <= blueConstant && green <= blueConstant {
        if (blue-red >= differenceConstant || blue-green >= differenceConstant) &&
            (red-green <= 0.03 && red-green > 0 || green-red <= 0.03 && green-red > 0) {
            return .bluNotte
        }
        if blue-red < differenceConstant && blue-green < differenceConstant && blue-red > 0 && blue-green > 0 {
            return .nero
        }
    }
    
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
    if closestColorName == "Blu Navy" || closestColorName == "Blu Notte" || closestColorName == "Viola" || closestColorName == "Nero" || closestColorName == "Grigio" || closestColorName == "Beige" || closestColorName == "Celeste Scuro" || closestColorName == "Avio Scuro"  {
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
