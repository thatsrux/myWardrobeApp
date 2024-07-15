//
//  AddClothScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//
//

import ColorKit
import SwiftUI

import UIImageColors
import BackgroundRemoval
import ColorThiefSwift

struct AddClothScreen: View {
    var image: UIImage
    var cloth: Cloth
    
    // @Binding var clothes: [Cloth]
    
    @State var nomeText = ""
    @State var tagliaText = ""
    
    @State var cpColor1: Color
    @State var cpColor2: Color
    @State var cpColor3: Color
    
    @State var categoriaClassificata = ""
    
    @ObservedObject var classifier = ImageClassifier()
    
    static func salva(clothes:[Cloth]){
        do {
            let data = try JSONEncoder().encode(clothes)
            UserDefaults.standard.set(data, forKey: "CLOTHES")
        } catch {
            print("Impossibile salvare \(error)")
        }
    }
    
    var imageNoBackground : UIImage
    
    init(image: UIImage){
        self.image = image
        
        let backgroundRemoval = BackgroundRemoval()
        
        
        do {
            imageNoBackground = try backgroundRemoval.removeBackground(image: image)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let colors = ColorThief.getPalette(from: imageNoBackground, colorCount: 9, quality: 10, ignoreWhite: false)
        
        cloth = Cloth(image: image)
        
        cloth.mainColor = ColorData(uiColor: colors![0].makeUIColor())
        cloth.secondColor = ColorData(uiColor: colors![1].makeUIColor())
        cloth.thirdColor = ColorData(uiColor: colors![2].makeUIColor())
        
        self.nomeText = ""
        self.tagliaText = ""
        
        self.cpColor1 = Color(red: cloth.mainColor.red, green: cloth.mainColor.green, blue: cloth.mainColor.blue)
        self.cpColor2 = Color(red: cloth.secondColor.red, green: cloth.secondColor.green, blue: cloth.secondColor.blue)
        self.cpColor3 = Color(red: cloth.thirdColor.red, green: cloth.thirdColor.green, blue: cloth.thirdColor.blue)
        
        classifier.detect(uiImage: UIImage(data: cloth.image)!)
        
        self.categoriaClassificata = classifier.imageClass
        
        
        
    }
    
    var body: some View {
        ScrollView{
            VStack{
                Image(uiImage: imageNoBackground)
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
                HStack(alignment:.center) {
                    VStack(alignment:.center) {
                        Text("Colore principale").frame(
                            minWidth: 0,
                            maxWidth: 80,
                            minHeight: 0,
                            maxHeight: 50,
                            alignment: .center
                        ).multilineTextAlignment(.center)
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                            .fill(Color(cpColor1))
                            .frame(width: 100, height: 50)
                            .overlay {
                                ColorPicker("", selection: $cpColor1)
                                    .opacity(0.015)
                                    .scaleEffect(x:3,y:3)
                                    .labelsHidden()
                            }
                    }
                    
                    VStack() {
                        Text("Secondo colore").frame(
                            minWidth: 0,
                            maxWidth: 80,
                            minHeight: 0,
                            maxHeight: 50,
                            alignment: .center
                        ).multilineTextAlignment(.center)
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                            .fill(Color(cpColor2))
                            .frame(width: 100, height: 50)
                            .overlay {
                                ColorPicker("", selection: $cpColor2)
                                    .opacity(0.015)
                                    .scaleEffect(x:3,y:3)
                                    .labelsHidden()
                                
                            }
                    }
                    
                    
                    VStack() {
                        Text("Terzo colore").frame(
                            minWidth: 0,
                            maxWidth: 80,
                            minHeight: 0,
                            maxHeight: 50,
                            alignment: .center
                        ).multilineTextAlignment(.center)
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                            .fill(Color(cpColor3))
                            .frame(width: 100, height: 50)
                            .overlay {
                                ColorPicker("", selection: $cpColor3)
                                    .opacity(0.015)
                                    .scaleEffect(x:3,y:3)
                                    .labelsHidden()
                                
                            }
                        
                    }
                }.padding(.bottom,20)
                
                LabeledContent {
                    TextField("\(classifier.imageClass)",text:$categoriaClassificata).padding(.bottom,10).padding(.leading,10).foregroundColor(.blue)
                } label: {
                    Text("Categoria: ")
                }.padding(.leading,20)
                LabeledContent {
                    TextField("", text: $nomeText).padding(.bottom,10).padding(.leading,10)
                } label: {
                    Text("Nome articolo: ")
                }.padding(.leading,20)
                LabeledContent {
                    TextField("", text: $tagliaText).padding(.bottom,10).padding(.leading,10)
                } label: {
                    Text("Taglia: ")
                }.padding(.leading,20)
            }
            
        }
        .toolbar {
            ToolbarItem (placement: .topBarTrailing){
                Button (action: {
                    //clothes.append(cloth)
                    //AddClothScreen.salva(clothes: clothes)
                    print("salvata")
                }, label: {Text("Salva")}
                )
            }
        }
        .navigationTitle("Advices")
    }
    
    
}

#Preview {
    AddClothScreen(image: UIImage(named: "juve2")!)
}
