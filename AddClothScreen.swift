//
//  AddClothScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//
import ColorKit
import SwiftUI

class imageClass {
    let image: UIImage?
    let averageColor: UIColor!
    let colors: [UIColor]
    let palette: ColorPalette
    
    var primaryColor: UIColor!
    var secondaryColor: UIColor!
    
    init(image: UIImage) {
        self.image = image
        
        do {
            averageColor = try image.averageColor()
            
            colors = try image.dominantColors(with: .fair, algorithm: .kMeansClustering)
            
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

struct AddClothScreen: View {
    var image: imageClass
    @State var s: String
    
    init(image: imageClass, string: String){
        self.image = image
        self.s = string
    }
    
    var body: some View {
        ScrollView{
            VStack{
                if image.image != nil {
                    Image(uiImage: image.image!)
                        .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 150, height: 200)
                }
                Text("Colore medio")
                    .fontWeight(.bold)
                
                Rectangle()
                    .fill(Color(image.averageColor))
                
                Text("Colori presi dall'array")
                    .fontWeight(.bold)
                
                HStack {
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
                
                HStack {
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
                
                LabeledContent {
                  TextField("", text: $s)
                } label: {
                  Text("Categoria: ")
                }
                LabeledContent {
                  TextField("", text: $s)
                } label: {
                  Text("Nome articolo: ")
                }
                LabeledContent {
                  TextField("", text: $s)
                } label: {
                  Text("Taglia: ")
                }
                LabeledContent {
                  TextField("", text: $s)
                } label: {
                  Text("Colore primario: ")
                }
                
            }
        
        } 
        .toolbar {
            ToolbarItem (placement: .topBarTrailing){
                Button (action: {
                    
                }, label: {Text("Salva")}
                )
            }
        }
        .navigationTitle("Advices")
    }
        
                
}
/*
#Preview {
    //AddClothScreen(image: imageClass(image: Image("")), string: "")
}
*/
