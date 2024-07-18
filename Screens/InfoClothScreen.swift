import SwiftUI
import UIImageColors
import BackgroundRemoval
import ColorThiefSwift
import Firebase

struct InfoClothScreen: View {
    var image: UIImage
    
    var cloth:Cloth
    @State var nomeText = ""
    @State var tagliaText = ""
    @State var categoriaClassificata = ""
    
    @State var cpColor1: Color = .clear
    @State var cpColor2: Color = .clear
    @State var cpColor3: Color = .clear
    
    @ObservedObject var classifier = ImageClassifier()
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var database:Database
    
    private var imageNoBackground: UIImage
    
    var edit: Bool = false
    
    init(cloth: Cloth){
        self.cloth = cloth
        
        self.nomeText = cloth.nome
        self.tagliaText = cloth.taglia
        
        let backgroundRemoval = BackgroundRemoval()
        do {
            self.imageNoBackground = try backgroundRemoval.removeBackground(image: (cloth.image?.toImage())!)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        self.image = (cloth.image?.toImage())!
        edit = true
    }
    
    init(image: UIImage) {
        
        self.image = image
        
        self.cloth = Cloth(image: image)
        
        let backgroundRemoval = BackgroundRemoval()
        
        do {
            imageNoBackground = try backgroundRemoval.removeBackground(image: image)
        } catch {
            fatalError(error.localizedDescription)
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
                    TextField("Categoria", text: $categoriaClassificata)
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
        .onAppear {
            extractColorsAndClassify()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    saveCloth()
                    dismiss()
                }) {
                    Text("Salva")
                }
                
                Button(action: {
                    deleteCloth(cloth: cloth)
                    dismiss()
                }) {
                    Text("Elimina")
                }
            }
        }
        .navigationTitle(cloth.nome)
    }
    
    func extractColorsAndClassify() {
        let colors = ColorThief.getPalette(from: imageNoBackground, colorCount: 9, quality: 10, ignoreWhite: false)
        
        if let colors = colors {
            self.cpColor1 = Color(colors[0].makeUIColor())
            self.cpColor2 = Color(colors[1].makeUIColor())
            self.cpColor3 = Color(colors[2].makeUIColor())
            
            let cloth = Cloth(image: image)
            cloth.mainColor = ColorData(uiColor: colors[0].makeUIColor())
            cloth.secondColor = ColorData(uiColor: colors[1].makeUIColor())
            cloth.thirdColor = ColorData(uiColor: colors[2].makeUIColor())
            
            classifier.detect(uiImage: (cloth.image?.toImage())!)
            self.categoriaClassificata = classifier.imageClass
        }
    }
    
    private func saveCloth() {
        if edit {
            editCloth()
        }
        else {
            let newCloth = Cloth(image: image)
            
            newCloth.mainColor = ColorData(uiColor: UIColor(cpColor1))
            newCloth.secondColor = ColorData(uiColor: UIColor(cpColor2))
            newCloth.thirdColor = ColorData(uiColor: UIColor(cpColor3))
            
            newCloth.nome = nomeText
            newCloth.taglia = tagliaText
            newCloth.categoria = categoriaClassificata
            
            database.clothes.append(newCloth)
            InfoClothScreen.save(clothes: database.clothes)
        }
     
        database.fetchClothes()
    }
    
    private func editCloth(){
        cloth.nome = nomeText
        cloth.taglia = tagliaText
        cloth.categoria = categoriaClassificata
        
        cloth.mainColor = ColorData(uiColor: UIColor(cpColor1))
        print(cpColor1)
        print(cloth.mainColor)
        cloth.secondColor = ColorData(uiColor: UIColor(cpColor2))
        cloth.thirdColor = ColorData(uiColor: UIColor(cpColor3))
        
        database.clothes.append(cloth)
        InfoClothScreen.save(clothes: database.clothes)
    }
    
    private func deleteCloth(cloth:Cloth){
        Firestore.firestore().collection("Cloth").document(cloth.id.uuidString).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        database.fetchClothes()
    }
    
    static func save(clothes: [Cloth]) {
        
        var img:UIImage?
        
        
        for cloth in clothes{
            
            if let data = cloth.image?.toImage()!.compress(to: 100){
                img = UIImage(data: data)!
            }
            else{
                img = cloth.image?.toImage()!
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let dataString = dateFormatter.string(from: cloth.data)
            
            
            let db = Firestore.firestore()
            let ref = db.collection("Cloth").document(cloth.id.uuidString)
            ref.setData(["foto": img!.toPngString()!,
                         "id" : cloth.id.uuidString,
                         "nome": cloth.nome,
                         "categoria": cloth.categoria,
                         "taglia": cloth.taglia,
                         "color1a": cloth.mainColor.alpha.description,
                         "color1r": cloth.mainColor.red.description,
                         "color1g": cloth.mainColor.green.description,
                         "color1b": cloth.mainColor.blue.description,
                         "color2a": cloth.secondColor.alpha.description,
                         "color2r": cloth.secondColor.red.description,
                         "color2g": cloth.secondColor.green.description,
                         "color2b": cloth.secondColor.blue.description,
                         "color3a": cloth.thirdColor.alpha.description,
                         "color3r": cloth.thirdColor.red.description,
                         "color3g": cloth.thirdColor.green.description,
                         "color3b": cloth.thirdColor.blue.description,
                         "data":dataString
                        ]){
                error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
