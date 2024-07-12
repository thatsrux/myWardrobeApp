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
    let mainColor: Color
    var secondColor: Color?
    var thirdColor: Color?
    
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
    }
}

struct AddClothScreen: View {
    var cloth: Cloth
    @State var s: String
    
    init(cloth: Cloth, string: String){
        self.cloth = cloth
        self.s = string
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
                            .fill(Color((cloth.mainColor)))
                    }
                    if let secondColor = cloth.secondColor {
                        VStack() {
                            Text("Secondo colore")
                            Rectangle()
                                .fill(Color(secondColor))
                        }
                    }
                    if let thirdColor = cloth.thirdColor {
                        VStack() {
                            Text("Terzo colore")
                            Rectangle()
                                .fill(Color(thirdColor))
                        }
                    }
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
