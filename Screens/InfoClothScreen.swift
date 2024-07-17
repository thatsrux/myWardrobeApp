import SwiftUI
import UIImageColors
import BackgroundRemoval
import ColorThiefSwift

struct InfoClothScreen: View {
    var image: UIImage
    
    @Binding var clothes: [Cloth]
    
    var cloth: Cloth
    
    @State var nomeText = ""
    @State var tagliaText = ""
    @State var categoriaText = ""
    
    @State var cpColor1: Color
    @State var cpColor2: Color
    @State var cpColor3: Color
    
    @ObservedObject var classifier = ImageClassifier()
    
    @Environment(\.dismiss) private var dismiss
    
    private var imageNoBackground: UIImage
    
    init(cloth: Cloth, clothes: Binding<[Cloth]>){
        self.cloth = cloth
        self.image = UIImage(data: cloth.image)!
        
        self.cpColor1 = cloth.mainColor.toColor()
        self.cpColor2 = cloth.secondColor.toColor()
        self.cpColor3 = cloth.thirdColor.toColor()
        
        nomeText = cloth.nome
        tagliaText = cloth.taglia
        categoriaText = cloth.categoria
        
        _clothes = clothes
        
        let backgroundRemoval = BackgroundRemoval()
        do {
            self.imageNoBackground = try backgroundRemoval.removeBackground(image: UIImage(data: cloth.image)!)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    init(image: UIImage, clothes: Binding<[Cloth]>) {
        
        self.image = image
        
        self.cloth = Cloth(image: image)
        
        _clothes = clothes
        
        let backgroundRemoval = BackgroundRemoval()
        
        do {
            imageNoBackground = try backgroundRemoval.removeBackground(image: image)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let colors = ColorThief.getPalette(from: imageNoBackground, colorCount: 9, quality: 10, ignoreWhite: false)
        
        if let colors = colors {
            self.cpColor1 = Color(colors[0].makeUIColor())
            self.cpColor2 = Color(colors[1].makeUIColor())
            self.cpColor3 = Color(colors[2].makeUIColor())
            
            let cloth = Cloth(image: image)
            cloth.mainColor = ColorData(uiColor: colors[0].makeUIColor())
            cloth.secondColor = ColorData(uiColor: colors[1].makeUIColor())
            cloth.thirdColor = ColorData(uiColor: colors[2].makeUIColor())
            
            classifier.detect(uiImage: UIImage(data: cloth.image)!)
            self.categoriaText = classifier.imageClass
            
        } else {
            self.cpColor1 = Color(.clear)
            self.cpColor2 = Color(.clear)
            self.cpColor3 = Color(.clear)
        }
        
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: imageNoBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 200)
                
                Group {
                    if classifier.imageConfidence > 0 {
                        HStack {
                            Text("Image categories:")
                                .font(.caption)
                            Text(classifier.imageClass)
                                .bold()
                            Text("(\(classifier.imageConfidence))")
                        }
                    } else {
                        HStack {
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
                    TextField("Categoria", text: $categoriaText)
                } label: {
                    Text("Categoria: ")
                }
                .padding(.leading, 20)
                
                LabeledContent {
                    TextField("Nome articolo", text: $nomeText)
                } label: {
                    Text("Nome articolo: ")
                }
                
                LabeledContent {
                    TextField("Taglia", text: $tagliaText)
                } label: {
                    Text("Taglia: ")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    saveCloth()
                    dismiss()
                }) {
                    Text("Salva")
                }
            }
        }
        .navigationTitle("Advices")
    }
    
    func saveCloth() {
        let newCloth = Cloth(image: imageNoBackground)
        
        newCloth.mainColor = ColorData(uiColor: UIColor(cpColor1))
        newCloth.secondColor = ColorData(uiColor: UIColor(cpColor2))
        newCloth.thirdColor = ColorData(uiColor: UIColor(cpColor3))
        
        newCloth.nome = nomeText
        newCloth.taglia = tagliaText
        newCloth.categoria = categoriaText
        
        clothes.append(newCloth)
        
        InfoClothScreen.save(clothes: clothes)
        
    }
    
    static func save(clothes: [Cloth]) {
        do {
            let data = try JSONEncoder().encode(clothes)
            UserDefaults.standard.set(data, forKey: "CLOTHES")
        } catch {
            print("Unable to save \(error)")
        }
    }
}
