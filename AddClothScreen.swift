import ColorKit
import SwiftUI

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
        self.cpColor2 = Color(cloth.secondColor!)
        self.cpColor3 = Color(cloth.thirdColor!)
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
