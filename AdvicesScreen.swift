//
//  AdvicesScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI
import ColorKit

let imageName = "gucci"

class imageClass {
    let image = UIImage(named: imageName)
    let averageColor: UIColor!
    let colors: [UIColor]
    let palette: ColorPalette
    
    var primaryColor: UIColor!
    var secondaryColor: UIColor!
    
    init() {
        do {
            averageColor = try image!.averageColor()
            
            colors = try image!.dominantColors(with: .fair, algorithm: .kMeansClustering)
            
            palette = ColorPalette(orderedColors: colors, ignoreContrastRatio: true)!
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
        primaryColor = colors[0]
        secondaryColor = colors[0]
        
        colors.forEach {color in
            if (color.difference(from: averageColor, using: .CIE94) < primaryColor.difference(from: averageColor, using: .CIE94)) {
                primaryColor = color
            }
        }
        if (secondaryColor == primaryColor) {
            secondaryColor = colors[1]
        }
    }
}

struct AdvicesScreen: View {
    let image = imageClass.init()
    var body: some View {
        NavigationStack {
            VStack{
                Image(imageName)
                    .resizable()
                    .frame(width: 80, height: 80)
                //Image(uiImage: image!)
                
                Text("Colore medio")
                    .fontWeight(.bold)
                
                Rectangle()
                    .fill(Color(image.averageColor))
                
                Text("Colori presi dall'array")
                    .fontWeight(.bold)
                
                HStack() {
                    Rectangle()
                        .fill(Color(image.colors[0]))
                    Rectangle()
                        .fill(Color(image.colors[1]))
                    Rectangle()
                        .fill(Color(image.colors[2]))
                    Rectangle()
                        .fill(Color(image.colors[3]))
                    Rectangle()
                        .fill(Color(image.colors[4]))
                    Rectangle()
                        .fill(Color(image.colors[5]))
                    Rectangle()
                        .fill(Color(image.colors[6]))
                    Rectangle()
                        .fill(Color(image.colors[7]))
                }
                
                Text("Colori presi dalla palette")
                    .fontWeight(.bold)
                
                HStack() {
                    VStack() {
                        Text("Principale:")
                        Rectangle()
                            .fill(Color(image.palette.primary))
                    }
                    VStack() {
                        Text("Secondario:")
                        Rectangle()
                            .fill(Color(image.palette.secondary!))
                    }
                    VStack() {
                        Text("Sfondo:")
                        Rectangle()
                            .fill(Color(image.palette.background))
                    }
                }
                
                Text("Processo analitico")
                    .fontWeight(.bold)
                HStack() {
                    VStack() {
                        Text("Colore principale:")
                        Rectangle()
                            .fill(Color(image.primaryColor))
                    }
                    VStack() {
                        Text("Colore secondario:")
                        Rectangle()
                            .fill(Color(image.secondaryColor))
                    }
                }
                
            } .navigationTitle("Advices")
        }
    }
        
}

#Preview {
    AdvicesScreen()
}
