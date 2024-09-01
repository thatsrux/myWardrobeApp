import SwiftUI
import BackgroundRemoval
import ColorThiefSwift
import Firebase

struct InfoClothScreen: View, Deletable {
    var image: UIImage
    
    var cloth:Cloth
    @State var isStarFilled : Bool
    
    @State var nomeText = ""
    @State var tagliaText = Taglia.NA
    @State var categoriaClassificata = Categoria.NA
    @State var stileClassificato = Stile.NA
    
    @State var cpColor1: Color = .clear
    @State var cpColor2: Color = .clear
    @State var cpColor3: Color = .clear
    
    @ObservedObject var classifier = ImageClassifier()
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var database:Database
    
    private var imageNoBackground: UIImage?
    
    @State var colorsNum = 3
    
    var edit: Bool = false
    
    init(cloth: Cloth){
        self.cloth = cloth
        
        self.isStarFilled = cloth.favourite
        
        self.nomeText = cloth.nome
        self.tagliaText = cloth.taglia
        self.categoriaClassificata = cloth.categoria
        self.stileClassificato = cloth.stile
        
        self.image = (cloth.image?.toImage())!
        edit = true
    }
    
    init(image: UIImage) {
        self.isStarFilled = false
        let backgroundRemoval = BackgroundRemoval()
        
        do {
            imageNoBackground = try backgroundRemoval.removeBackground(image: image)
            self.image = imageNoBackground!.croppedToBoundingBox() ?? imageNoBackground!
        } catch {
            fatalError(error.localizedDescription)
        }
        self.cloth = Cloth(image: image)
        cloth.image = cloth.image?.toImage()!.toPngString()
        
        // Il classificatore analizza l'immagine non tagliata, così che possa tenere conto delle dimensioni del capo
        if let i = imageNoBackground {
            classifier.detect(uiImage: i.withBackground(color: UIColor.white))
        } else {
            classifier.detect(uiImage: image)
        }
        
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 150, maxWidth: 187.5, minHeight: 200, maxHeight: 250, alignment: .center)
                if !edit {
                    Group {
                        if classifier.typeConfidence > 0.5 {
                            HStack {
                                Text("Capo di abbigliamento:")
                                Text(classifier.typeClass)
                                    .bold()
                                Text("(sicurezza: \(classifier.typeConfidence * 100, specifier: "%.0f")%)")
                            }
                        } else {
                            HStack {
                                Text("Capo di abbigliamento non riconosciuto")
                                    .bold()
                            }
                        }
                    }
                    Group {
                        if classifier.styleConfidence > 0.5 {
                            HStack {
                                Text("Stile:")
                                Text(classifier.styleClass)
                                    .bold()
                                Text("(sicurezza: \(classifier.styleConfidence * 100, specifier: "%.0f")%)")
                            }
                        } else {
                            HStack {
                                Text("Stile non riconosciuto")
                                    .bold()
                            }
                        }
                    }
                }
                
                VStack{
                    HStack(alignment:.center) {
                        VStack(alignment:.center) {
                            Button(action: removeColor) {
                                Label("", systemImage: "minus")
                            }.disabled(colorsNum == 1)
                                .padding(.leading,20)
                                .padding(.top,15)
                        }
                        
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
                                .frame(width: 85, height: 50)
                                .overlay {
                                    ColorPicker("", selection: $cpColor1)
                                        .opacity(0.015)
                                        .scaleEffect(x:3,y:3)
                                        .labelsHidden()
                                }
                            Text(closestColor(to: UIColor(cpColor1)).rawValue)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 140, minHeight: 50 ,alignment: .top)
                        }
                        
                        if colorsNum > 1 {
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
                                    .frame(width: 85, height: 50)
                                    .overlay {
                                        ColorPicker("", selection: $cpColor2)
                                            .opacity(0.015)
                                            .scaleEffect(x:3,y:3)
                                            .labelsHidden()
                                    }
                                Text(closestColor(to: UIColor(cpColor2)).rawValue)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 140, minHeight: 50 ,alignment: .top)
                            }
                        }
                        
                        if colorsNum > 2 {
                            VStack(alignment: .center) {
                                Text("Terzo colore")
                                    .frame(
                                        minWidth: 0,
                                        maxWidth: 80,
                                        minHeight: 0,
                                        maxHeight: 50,
                                        alignment: .center
                                    )
                                    .multilineTextAlignment(.center)
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1)
                                    .fill(Color(cpColor3))
                                    .frame(width: 85, height: 50)
                                    .overlay(
                                        ColorPicker("", selection: $cpColor3)
                                            .opacity(0.015)
                                            .scaleEffect(x: 3, y: 3)
                                            .labelsHidden()
                                    )
                                
                                Text(closestColor(to: UIColor(cpColor3)).rawValue)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 140, minHeight: 50 ,alignment: .top)
                            }
                            
                        }
                        
                        VStack(alignment:.center) {
                            Button(action: addColor) {
                                Label("", systemImage: "plus")
                            }.disabled(colorsNum == 3)
                                .padding(.trailing, 20)
                                .padding(.top,15)
                        }
                    }.padding(.bottom,30)
                }
                
                
                VStack(spacing: 30){
                    
                    LabeledContent {
                        Picker("", selection: $categoriaClassificata){
                            ForEach(Categoria.allCases, id:\.self){ c in
                                Text(c.rawValue)
                            }
                        }.onTapGesture(perform: {
                            tagliaText = Taglia.NA
                        })
                    } label: {
                        Text("Categoria: ")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    LabeledContent {
                        TextField("Nome articolo", text: $nomeText)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing, 14)
                        
                    } label: {
                        Text("Nome articolo: ")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    LabeledContent {
                        Picker("", selection: $tagliaText){
                            if(upperCat.contains(categoriaClassificata)){
                                ForEach(tagliaUpper, id:\.self){ t in
                                    Text(t.rawValue)
                                }
                            } else if(lowerCat.contains(categoriaClassificata)){
                                ForEach(tagliaLower, id:\.self){ t in
                                    Text(t.rawValue)
                                }
                            } else if(shoesCat.contains(categoriaClassificata)){
                                ForEach(tagliaShoes, id:\.self){ t in
                                    Text(t.rawValue)
                                }
                            } else {
                                ForEach(Taglia.allCases, id:\.self){ t in
                                    Text(t.rawValue)
                                }
                            }
                        }
                    } label: {
                        Text("Taglia: ")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    LabeledContent {
                        Picker("", selection: $stileClassificato){
                            ForEach(Stile.allCases, id:\.self){ s in
                                Text(s.rawValue)
                            }
                        }
                    } label: {
                        Text("Stile: ")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    
                }
                .padding(.leading, 35)
                .padding(.trailing, 35)
                
            }
            
        }
        .onAppear {
            if !edit {
                extractColorsAndClassify()
            }
            else {
                self.cpColor1 = cloth.mainColor.toColor()
                self.cpColor2 = cloth.secondColor.toColor()
                self.cpColor3 = cloth.thirdColor.toColor()
                colorsNum = cloth.colorsNum
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    isStarFilled.toggle()
                } label: {
                    Image(systemName: isStarFilled ? "star.fill" : "star")
                }
                
                Button(action: {
                    saveCloth()
                    database.fetchClothes()
                    database.fetchCategorie()
                    dismiss()
                }) {
                    Text("Salva")
                }
                
                if edit{
                    Button(action: {
                        database.clothesNum -= 1
                        deleteCloth(cloth: cloth)
                        database.fetchClothes()
                        database.fetchCategorie()
                        dismiss()
                    }) {
                        Text("Elimina")
                    }
                }
                
            }
        }
        
        .navigationTitle(cloth.nome)
    }
    
    func extractColorsAndClassify() {
        // Estrazione dei tre colori principali, ignorando il bianco puro, inserendo uno sfondo bianco all'immagine semitrasparente.
        // Questo metodo fornisce risultati più accurati
        let colors = ColorThief.getPalette(from: image.withBackground(color: UIColor.white), colorCount: 3, quality: 1, ignoreWhite: true)
        
        // Estrazione dei nove colori principali, lasciando il bianco puro, sull'immagine semitrasparente.
        // Questo metodo fornisce i risultati migliori per capire se l'immagine è monocolore
        let testSingleColor = ColorThief.getPalette(from: image, colorCount: 9, quality: 1, ignoreWhite: false)
        
        // Si verifica la differenza tra il primo e il secondo colore.
        let diff1 = testSingleColor![0].makeUIColor().CIE94(compare: testSingleColor![1].makeUIColor())
        
        // Si verifica la differenza tra il secondo colore (preso dal test per il monocolore) e il nero puro, siccome viene restituito erroneamente quando il capo è monocolore.
        let diff2 = testSingleColor![1].makeUIColor().CIE94(compare: UIColor.black)
        
        // Si verifica la differenza tra il primo e il terzo colore.
        let diff3 = colors![2].makeUIColor().CIE94(compare: colors![0].makeUIColor())
        
        // Si verifica la differenza tra il secondo e il terzo colore.
        let diff4 = colors![2].makeUIColor().CIE94(compare: colors![1].makeUIColor())
        
        // Si verifica la differenza tra il terzo colore (preso dal test per il monocolore) e il nero puro, siccome viene restituito erroneamente quando il capo è monocolore.
        let diff5 = testSingleColor![2].makeUIColor().CIE94(compare: UIColor.black)
        
        // Se il terzo colore è poco differente dal primo e dal secondo, o se quando viene preso dal primo test è molto simile al nero puro, il capo ha 2 colori.
        if diff3 < 30 || diff4 < 30 || diff5 < 1 {
            colorsNum = 2
        }
        
        // Se il secondo colore è poco differente dal primo, o se quando viene preso dal primo test è molto simile al nero puro, il capo ha 1 colore.
        if diff1 < 20 || diff2 < 1 {
            colorsNum = 1
        }
        
        if let colors = colors {
            self.cpColor1 = Color(colors[0].makeUIColor())
            self.cpColor2 = Color(colors[1].makeUIColor())
            self.cpColor3 = Color(colors[2].makeUIColor())
            
            let cloth = Cloth(image: image)
            cloth.mainColor = ColorData(uiColor: colors[0].makeUIColor())
            if colors[1].makeUIColor() == colors[0].makeUIColor() {
                cloth.secondColor = ColorData(uiColor: colors[1].makeUIColor())
            }
            if colors[2].makeUIColor() == colors[0].makeUIColor() || colors[2].makeUIColor() == colors[1].makeUIColor() {
                cloth.thirdColor = ColorData(uiColor: colors[2].makeUIColor())
            }
        }
        if classifier.typeConfidence > 0.5 {
            self.categoriaClassificata = Categoria(fromRawValue: classifier.typeClass)
        } else {
            self.categoriaClassificata = .NA
        }
        
        if classifier.styleConfidence > 0.5 {
            self.stileClassificato = Stile(fromRawValue: classifier.styleClass)
        } else {
            self.stileClassificato = .NA
        }
    }
    
    private func saveCloth() {
        if edit {
            editCloth()
            database.fetchOutfits()
        }
        else {
            database.clothesNum += 1
            let coreImage = image.cgImage
            UIGraphicsBeginImageContext(CGSize(width: coreImage!.width, height: coreImage!.height))
            image.draw(in: CGRect(x: Int(0.0), y: Int(0.0), width: coreImage!.width, height: coreImage!.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let newCloth = Cloth(image: resultImage!)
            
            newCloth.mainColor = ColorData(uiColor: UIColor(cpColor1))
            newCloth.secondColor = ColorData(uiColor: UIColor(cpColor2))
            newCloth.thirdColor = ColorData(uiColor: UIColor(cpColor3))
            
            newCloth.nome = nomeText
            newCloth.taglia = tagliaText
            newCloth.categoria = categoriaClassificata
            newCloth.stile = stileClassificato
            
            newCloth.colorsNum = colorsNum
            newCloth.favourite = isStarFilled
            InfoClothScreen.save(cloth: newCloth)
        }
        
    }
    
    private func editCloth(){
        cloth.nome = nomeText
        cloth.taglia = tagliaText
        cloth.categoria = categoriaClassificata
        cloth.stile = stileClassificato
        cloth.favourite = isStarFilled
        
        cloth.mainColor = ColorData(uiColor: UIColor(cpColor1))
        cloth.secondColor = ColorData(uiColor: UIColor(cpColor2))
        cloth.thirdColor = ColorData(uiColor: UIColor(cpColor3))
        
        
        cloth.colorsNum = colorsNum
        InfoClothScreen.save(cloth: cloth)
    }
    
    static func save(cloth:Cloth) {
        
        var img:UIImage?
        
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
        let ref = db.collection("Clothes").document(cloth.id.uuidString)
        ref.setData(["foto": img!.toPngString()!,
                     "id" : cloth.id.uuidString,
                     "nome": cloth.nome,
                     "categoria": cloth.categoria.rawValue,
                     "taglia": cloth.taglia.rawValue,
                     "color1": cloth.mainColor.rgbaToHex(),
                     "color2": cloth.secondColor.rgbaToHex(),
                     "color3":cloth.thirdColor.rgbaToHex(),
                     "colorsnum" : cloth.colorsNum,
                     "stile": cloth.stile.rawValue,
                     "data":dataString,
                     "favourite": cloth.favourite
                    ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func removeColor() {
        colorsNum -= 1
    }
    
    func addColor() {
        colorsNum += 1
    }
}

