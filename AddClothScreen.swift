//
//  AddClothScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//
import ColorKit
import SwiftUI

import UIImageColors
import BackgroundRemoval




class Cloth {
    let image: UIImage
    let imageNoBackground: UIImage
    
    var mainColor: Color
    var secondColor: Color?
    var thirdColor: Color?
    
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
        let colors = imageNoBackground.getColors()
        mainColor = Color((colors?.background)!)
        if let second = colors?.primary {
            secondColor = Color(second)
        }
        if let third = colors?.secondary {
            thirdColor = Color(third)
        }
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

    
    init(cloth: Cloth){
        self.cloth = cloth
        self.categoriaText = ""
        self.nomeText = ""
        self.tagliaText = ""
        self.cpColor1 = Color(cloth.mainColor)
        self.cpColor2 = Color(cloth.secondColor!)
        self.cpColor3 = Color(cloth.thirdColor!)

    }
    
    var body: some View {
        ScrollView{
            VStack{
                Image(uiImage: cloth.imageNoBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 200)
                HStack() {
                    VStack() {
                        Text("Colore principale")
                        Rectangle()
                            .fill(Color((cpColor1)))
                    }
                    if let secondColor = cloth.secondColor {
                        VStack() {
                            Text("Secondo colore")
                            Rectangle()
                                .fill(Color(cpColor2))
                        }
                    }
                    if let thirdColor = cloth.thirdColor {
                        VStack() {
                            Text("Terzo colore")
                            Rectangle()
                                .fill(Color(cpColor3))
                        }
                    }
                }
                
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
/*
 #Preview {
 //AddClothScreen(image: imageClass(image: Image("")), string: "")
 }
 */
