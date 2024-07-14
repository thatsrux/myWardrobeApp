//
//  AddClothScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//
// https://github.com/yamoridon/ColorThiefSwift
//

import ColorKit
import SwiftUI

import UIImageColors
import BackgroundRemoval
import ColorThiefSwift

class Cloth {
    let image: UIImage
    let imageNoBackground: UIImage
    
    var mainColor: Color
    var secondColor: Color
    var thirdColor: Color
    
    var categoria: String
    var nome:String
    var taglia:String
    
    let backgroundRemoval = BackgroundRemoval()
    
    init(image: UIImage) {
        self.image = image
        do {
            self.imageNoBackground = try backgroundRemoval.removeBackground(image: image)
        }catch {
            fatalError(error.localizedDescription)
        }
        let colors = ColorThief.getPalette(from: imageNoBackground, colorCount: 9, quality: 10, ignoreWhite: false)
        mainColor = Color(colors![0].makeUIColor())
        secondColor = Color(colors![1].makeUIColor())
        thirdColor = Color(colors![2].makeUIColor())
        self.categoria = ""
        self.nome = ""
        self.taglia = ""
    }
}

struct AddClothScreen: View {
    var cloth: Cloth
    @State var categoriaText = ""
    @State var nomeText = ""
    @State var tagliaText = ""
    
    @State var cpColor1:Color
    @State var cpColor2:Color
    @State var cpColor3:Color
    
    
    @ObservedObject var classifier = ImageClassifier()
    
    init(cloth: Cloth){
        self.cloth = cloth
        self.nomeText = ""
        self.tagliaText = ""
        self.cpColor1 = Color(cloth.mainColor)
        self.cpColor2 = Color(cloth.secondColor)
        self.cpColor3 = Color(cloth.thirdColor)
        classifier.detect(uiImage: cloth.image)
    }
    
    var body: some View {
        ScrollView{
            VStack{
                Image(uiImage: cloth.imageNoBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 200)
                
                Group {
                    if classifier.imageConfidence>0 {
                        HStack{
                            Text("Image categories:")
                                .font(.caption)
                            Text(classifier.imageClass)
                                .bold()
                            Text("(\(classifier.imageConfidence))")
                        }
                    } else {
                        HStack{
                            Text("Image categories: NA")
                                .font(.caption)
                        }
                    }
                }
                HStack() {
                    VStack() {
                        Text("Colore principale")
                        Rectangle()
                            .fill(Color((cpColor1)))
                    }
                    
                    VStack() {
                        Text("Secondo colore")
                        Rectangle()
                            .fill(Color(cpColor2))
                    }
                    VStack() {
                        Text("Terzo colore")
                        Rectangle()
                            .fill(Color(cpColor3))
                        
                    }
                }
                Text("ColorThief")
                
                LabeledContent {
                    TextField("", text: $categoriaText)
                } label: {
                    Text("Categoria: ")
                }
                LabeledContent {
                    TextField("", text: $nomeText)
                } label: {
                    Text("Nome articolo: ")
                }
                LabeledContent {
                    TextField("", text: $tagliaText)
                } label: {
                    Text("Taglia: ")
                }
                LabeledContent {
                    ColorPicker("", selection: $cpColor1)
                } label: {
                    Text("Colore primario: ")
                }
                LabeledContent {
                    ColorPicker("", selection: $cpColor2)
                } label: {
                    Text("Colore secondario: ")
                }
                LabeledContent {
                    ColorPicker("", selection: $cpColor3)
                } label: {
                    Text("Colore terziario: ")
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

#Preview {
    AddClothScreen(cloth: Cloth(image: UIImage(named: "juve2")!))
}
