import SwiftUI
import Firebase

struct AddOutfitScreen: View, Deletable {
    @State private var isAddToOutfitScreenActive = false
    @EnvironmentObject var database: Database
    @Environment(\.dismiss) private var dismiss
    
    @State private var categoria: [Categoria] = [.NA]
    @State var shirt: Cloth?
    @State var trousers: Cloth?
    @State var shoes: Cloth?
    
    let defaultShirt = Cloth(image: UIImage(systemName: "tshirt")!)
    let defaultTrousers = Cloth(image: UIImage(named: "trousers")!)
    let defaultShoes = Cloth(image: UIImage(systemName: "shoe")!)
    
    @State private var missingCloth: [Categoria] = [.NA]
    
    @State var nomeText = ""
    @State var stile = Stile.NA
    
    @State var compatibleClothes: [Cloth] = []
    
    @State var coloreValido = true
    @State var spiegazioneColore = ""
    
    @State var stileValido = true
    @State var spiegazioneStile = ""
    
    var outfit: Outfit?
    @State var isOutfitFavourite : Bool
    
    var edit = false
    @State var first = true
    @State var updateStyle = false
    
    init(outfit:Outfit) {
        self.outfit = outfit
        edit = true
        self.isOutfitFavourite = outfit.favourite
    }
    
    init(shirt: Cloth, trousers: Cloth, shoes: Cloth) {
        self.shirt = shirt
        self.trousers = trousers
        self.shoes = shoes
        self.isOutfitFavourite = false
    }
    
    init(){
        self.isOutfitFavourite = false
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(){
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = upperCat
                    }) {
                        if let shirt = shirt, let image = shirt.image?.toImage() {
                            VStack(spacing:5){
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:150,height:150)
                                
                                Button(action: {
                                    self.shirt = nil
                                    updateOutfit()
                                }){
                                    Text("Rimuovi")                                }
                            }
                        } else {
                            ZStack() {
                                Image(systemName: "tshirt")
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:150,height:150)
                                    .foregroundStyle(.black)
                                    .opacity(0.2)
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:50,height:50)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = lowerCat
                    }) {
                        if let trousers = trousers, let image = trousers.image?.toImage() {
                            VStack(spacing:5){
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:150,height:150)
                                
                                Button(action: {
                                    self.trousers = nil
                                    updateOutfit()
                                }){
                                    Text("Rimuovi")
                                }
                            }
                        } else {
                            ZStack() {
                                Image(uiImage: UIImage(imageLiteralResourceName: "trousers"))
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:150,height:150)
                                    .foregroundStyle(.black)
                                    .opacity(0.2)
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:50,height:50)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = shoesCat
                    }) {
                        if let shoes = shoes, let image = shoes.image?.toImage() {
                            VStack(spacing:1){
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:150,height:150)
                                
                                Button(action: {
                                    self.shoes = nil
                                    updateOutfit()
                                }){
                                    Text("Rimuovi")
                                }
                            }
                        } else {
                            ZStack() {
                                Image(systemName: "shoe")
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:150,height:150)
                                    .foregroundStyle(.black)
                                    .opacity(0.2)
                                Image(systemName: "plus.app")
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width:50,height:50)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }.frame(width: 200, height: 550)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(10)
                
                VStack(spacing: 20){
                    
                    LabeledContent {
                        TextField("Nome outfit", text: $nomeText)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing, 14)
                    } label: {
                        Text("Nome outfit: ")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    LabeledContent {
                        Picker("", selection: $stile){
                            ForEach(Stile.allCases, id:\.self){ s in
                                Text(s.rawValue)
                            }
                        }
                    } label: {
                        Text("Stile: ")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    if shirt != nil && trousers != nil && shoes != nil {
                        VStack {
                            Text("Valutazione Colori:")
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            if coloreValido {
                                Text("Positiva")
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundStyle(.green)
                            } else {
                                Text("Negativa")
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundStyle(.red)
                            }
                            Text(spiegazioneColore)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 18))
                        }
                        VStack {
                            Text("Valutazione Stile:")
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            if stileValido {
                                Text("Positiva")
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundStyle(.green)
                            } else {
                                Text("Negativa")
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                    .foregroundStyle(.red)
                            }
                            Text(spiegazioneStile)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 18))
                        }
                    }
                }
                .padding(35)
                VStack {
                    if missingCloth != [.NA] && !compatibleClothes.isEmpty {
                        Text("Completa il tuo outfit con uno di questi capi: ")
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing:25){
                                ForEach(compatibleClothes) { cloth in
                                    SingleClothGrid(cloth: cloth)
                                        .onTapGesture {
                                            if upperCat.contains(cloth.categoria) {
                                                shirt = cloth
                                            }
                                            else if lowerCat.contains(cloth.categoria) {
                                                trousers = cloth
                                            }
                                            else if shoesCat.contains(cloth.categoria) {
                                                shoes = cloth
                                            }
                                            updateOutfit()
                                            spiegazioneColore = outfitColorEvaluation(shirt: shirt!, trousers: trousers!, shoes: shoes!)
                                            spiegazioneStile = outfitStyleEvaluation(shirt: shirt!, trousers: trousers!, shoes: shoes!)
                                        }
                                }
                            }
                            .padding(.leading,20)
                            .padding(.bottom,20)
                            .padding(.top,20)
                        }
                    }
                }
            }.onAppear{
                updateOutfit()
                if shirt != nil && trousers != nil && shoes != nil {
                    spiegazioneColore = outfitColorEvaluation(shirt: shirt!, trousers: trousers!, shoes: shoes!)
                    spiegazioneStile = outfitStyleEvaluation(shirt: shirt!, trousers: trousers!, shoes: shoes!)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    Button{
                        isOutfitFavourite.toggle()
                    }
                label:{
                    Image(systemName: isOutfitFavourite ? "star.fill" : "star")
                }
                    
                    Button(action: {
                        saveOutfit()
                        database.fetchOutfits()
                        database.fetchCategorieOutfit()
                        dismiss()
                    }) {
                        Text("Salva")
                    }.disabled(shirt == nil || trousers == nil || shoes == nil)
                    if edit {
                        Button(action: {
                            database.outfitsNum -= 1
                            deleteOutfit(outfit: outfit!)
                            
                            database.fetchOutfits()
                            database.fetchCategorieOutfit()
                            
                            dismiss()
                        }) {
                            Text("Elimina")
                        }
                    }
                }
            }
            
        }.navigationTitle(outfit?.nome ?? "Componi Outfit")
            .navigationDestination(isPresented: $isAddToOutfitScreenActive){
                AddToOutfitScreen(category: $categoria,shirtToAdd: $shirt,trousersToAdd:$trousers,shoesToAdd:$shoes)
                    .onDisappear {
                        updateOutfit()
                    }
            }
        
    }
    
    func updateOutfit() {
        if self.shirt == nil && self.trousers != nil && self.shoes != nil {
            missingCloth = upperCat
        } else if self.shirt != nil && self.trousers == nil && self.shoes != nil {
            missingCloth = lowerCat
        } else if self.shirt != nil && self.trousers != nil && self.shoes == nil {
            missingCloth = shoesCat
        } else {
            missingCloth = [.NA]
        }
        checkCompatibleClothes()
        if first == true {
            guard let outfit = outfit else {return}
            
            print(outfit.shirt!.id.uuidString)
            
            guard let shirt = outfit.shirt, let trousers = outfit.trousers, let shoes = outfit.shoes else {
                print("error shirt/trousers/shoes")
                return}
            
            self.shirt = shirt
            self.trousers = trousers
            self.shoes = shoes
            self.nomeText = outfit.nome!
            self.stile = outfit.stile
            self.isOutfitFavourite = outfit.favourite
            first = false
        }
        else {
            self.shirt = shirt
            self.trousers = trousers
            self.shoes = shoes
        }
    }
    
    
    func saveOutfit(){
        if edit {
            editOutfit()
            return
        }
        
        database.outfitsNum += 1
        var shirtToAdd:Cloth?
        var trousersToAdd:Cloth?
        var shoesToAdd:Cloth?
        
        if let shirt = shirt{
            shirtToAdd = shirt
        }
        
        if let trousers = trousers{
            trousersToAdd = trousers
        }
        
        if let shoes = shoes{
            shoesToAdd = shoes
        }
        
        let outfit = Outfit(shirt:shirtToAdd,trousers: trousersToAdd,shoes:shoesToAdd, nome: nomeText, stile: stile)
        
        let db = Firestore.firestore()
        let ref = db.collection("Outfit").document(outfit.id.uuidString)
        ref.setData([
            "id": outfit.id.uuidString,
            "shirtId": shirt?.id.uuidString ?? "00000000-0000-0000-0000-000000000000",
            "trousersId" : trousers?.id.uuidString ?? "00000000-0000-0000-0000-000000000000",
            "shoesId" : shoes?.id.uuidString ?? "00000000-0000-0000-0000-000000000000",
            "nome" : nomeText,
            "stile" : stile.rawValue,
            "favourite": isOutfitFavourite
        ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func editOutfit() {
        let db = Firestore.firestore()
        let ref = db.collection("Outfit").document(outfit!.id.uuidString)
        ref.setData([
            "id": outfit!.id.uuidString,
            "shirtId": shirt!.id.uuidString,
            "trousersId" : trousers!.id.uuidString,
            "shoesId" : shoes!.id.uuidString,
            "nome" : nomeText,
            "stile" : stile.rawValue,
            "favourite": isOutfitFavourite
        ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func outfitColorEvaluation(shirt: Cloth, trousers: Cloth, shoes: Cloth) -> String {
        var valutazione = ""
        coloreValido = true
        
        var shirtColors = [closestColor(to: shirt.mainColor.uiColor)]
        if shirt.colorsNum > 1 {
            shirtColors.append(closestColor(to: shirt.secondColor.uiColor))
            if shirt.colorsNum > 2 {
                shirtColors.append(closestColor(to: shirt.thirdColor.uiColor))
            }
        }
        
        var trousersColors = [closestColor(to: trousers.mainColor.uiColor)]
        if trousers.colorsNum > 1 {
            trousersColors.append(closestColor(to: trousers.secondColor.uiColor))
            if trousers.colorsNum > 2 {
                trousersColors.append(closestColor(to: trousers.thirdColor.uiColor))
            }
        }
        
        var shoesColors = [closestColor(to: shoes.mainColor.uiColor)]
        if shoes.colorsNum > 1 {
            shoesColors.append(closestColor(to: shoes.secondColor.uiColor))
            if shoes.colorsNum > 2 {
                shoesColors.append(closestColor(to: shoes.thirdColor.uiColor))
            }
        }
        
        for shirtColor in shirtColors {
            for trousersColor in trousersColors {
                if shirtColor == trousersColor {
                    continue // Ignora la combinazione se i colori sono uguali
                }
                if let vietati = coloriVietati[shirtColor], vietati.contains(trousersColor) {
                    valutazione.append("Combinazione da evitare: \(shirtColor.rawValue) (\(shirt.categoria)) e \(trousersColor.rawValue) (\(trousers.categoria))\n")
                    coloreValido = false
                } else if let consentiti = coloriConsentiti[shirtColor], !consentiti.contains(trousersColor) {
                    valutazione.append("Combinazione da evitare: \(shirtColor.rawValue) (\(shirt.categoria)) e \(trousersColor.rawValue) (\(trousers.categoria))\n")
                    coloreValido = false
                }
            }
        }
        
        for shirtColor in shirtColors {
            for shoesColor in shoesColors {
                if shirtColor == shoesColor {
                    continue // Ignora la combinazione se i colori sono uguali
                }
                if let vietati = coloriVietati[shirtColor], vietati.contains(shoesColor) {
                    valutazione.append("Combinazione da evitare: \(shirtColor.rawValue) (\(shirt.categoria)) e \(shoesColor.rawValue) (\(shoes.categoria))\n")
                    coloreValido = false
                } else if let consentiti = coloriConsentiti[shirtColor], !consentiti.contains(shoesColor) {
                    valutazione.append("Combinazione da evitare: \(shirtColor.rawValue) (\(shirt.categoria)) e \(shoesColor.rawValue) (\(shoes.categoria))\n")
                    coloreValido = false
                }
            }
        }
        
        for trousersColor in trousersColors {
            for shoesColor in shoesColors {
                if trousersColor == shoesColor {
                    continue // Ignora la combinazione se i colori sono uguali
                }
                if let vietati = coloriVietati[trousersColor], vietati.contains(shoesColor) {
                    valutazione.append("Combinazione da evitare: \(trousersColor.rawValue) (\(trousers.categoria)) e \(shoesColor.rawValue) (\(shoes.categoria))\n")
                    coloreValido = false
                } else if let consentiti = coloriConsentiti[trousersColor], !consentiti.contains(shoesColor) {
                    valutazione.append("Combinazione da evitare: \(trousersColor.rawValue) (\(trousers.categoria)) e \(shoesColor.rawValue) (\(shoes.categoria))\n")
                    coloreValido = false
                }
            }
        }
        
        if coloreValido {
            valutazione.append("Parte superiore: \(shirtColors.map { $0.rawValue }.joined(separator: ", "))\nParte inferiore: \(trousersColors.map { $0.rawValue }.joined(separator: ", "))\nScarpe: \(shoesColors.map { $0.rawValue }.joined(separator: ", "))")
        }
        
        return valutazione
    }
    
    func outfitStyleEvaluation(shirt: Cloth, trousers: Cloth, shoes: Cloth) -> String {
        let outfit = [shirt, trousers, shoes]
        
        stileValido = true
        var combinazionePerfetta = true
        var valutazione = ""
        
        for c1 in outfit {
            for c2 in outfit {
                if c1.stile == Stile.formale && c1.stile != c2.stile && c1.stile != .NA && c2.stile != .NA {
                    stileValido = false
                    combinazionePerfetta = false
                    valutazione += "Stile non coordinato! \(c1.categoria) \(c1.stile) con \(c2.categoria) \(c2.stile).\n"
                }
                if (c1.categoria == .giacca || c1.categoria == .giubbino) && c2.categoria == .pantaloncini {
                    stileValido = false
                    combinazionePerfetta = false
                    valutazione += "Stile non coordinato! \(c1.categoria) con \(c2.categoria).\n"
                }
                if c1.stile != c2.stile && c1.stile != .NA && c2.stile != .NA {
                    combinazionePerfetta = false
                }
            }
        }
        
        if stileValido {
            valutazione = "L'outfit è ben coordinato\n"
            if combinazionePerfetta {
                valutazione.append("(stile " + shirt.stile.rawValue+")")
                if updateStyle {
                    stile = shirt.stile
                }
            } else {
                valutazione.append("(stile sportivo e casual)")
                if updateStyle {
                    stile = .casual
                }
            }
            if !updateStyle {
                updateStyle = true
            }
        }
        
        return valutazione
    }
    
    func checkCompatibleClothes() {
        compatibleClothes.removeAll()
        for cat in missingCloth {
            for cloth in database.clothes {
                if cloth.categoria == cat {
                    if missingCloth == upperCat && quickColorEvaluation(shirt: cloth, trousers: trousers!, shoes: shoes!) && quickStyleEvaluation(shirt: cloth, trousers: trousers!, shoes: shoes!)
                        ||
                        missingCloth == lowerCat && quickColorEvaluation(shirt: shirt!, trousers: cloth, shoes: shoes!) && quickStyleEvaluation(shirt: shirt!, trousers: cloth, shoes: shoes!)
                        ||
                        missingCloth == shoesCat && quickColorEvaluation(shirt: shirt!, trousers: trousers!, shoes: cloth) && quickStyleEvaluation(shirt: shirt!, trousers: trousers!, shoes: cloth) {
                        compatibleClothes.append(cloth)
                    }
                }
            }
        }
    }
}

func quickColorEvaluation(shirt: Cloth, trousers: Cloth, shoes: Cloth) -> Bool {
    var coloreValido = true
    
    var shirtColors = [closestColor(to: shirt.mainColor.uiColor)]
    if shirt.colorsNum > 1 {
        shirtColors.append(closestColor(to: shirt.secondColor.uiColor))
        if shirt.colorsNum > 2 {
            shirtColors.append(closestColor(to: shirt.thirdColor.uiColor))
        }
    }
    
    var trousersColors = [closestColor(to: trousers.mainColor.uiColor)]
    if trousers.colorsNum > 1 {
        trousersColors.append(closestColor(to: trousers.secondColor.uiColor))
        if trousers.colorsNum > 2 {
            trousersColors.append(closestColor(to: trousers.thirdColor.uiColor))
        }
    }
    
    var shoesColors = [closestColor(to: shoes.mainColor.uiColor)]
    if shoes.colorsNum > 1 {
        shoesColors.append(closestColor(to: shoes.secondColor.uiColor))
        if shoes.colorsNum > 2 {
            shoesColors.append(closestColor(to: shoes.thirdColor.uiColor))
        }
    }
    
    for shirtColor in shirtColors {
        for trousersColor in trousersColors {
            if shirtColor == trousersColor {
                continue // Ignora la combinazione se i colori sono uguali
            }
            if let vietati = coloriVietati[shirtColor], vietati.contains(trousersColor) {
                coloreValido = false
            } else if let consentiti = coloriConsentiti[shirtColor], !consentiti.contains(trousersColor) {
                coloreValido = false
            }
        }
    }
    
    for shirtColor in shirtColors {
        for shoesColor in shoesColors {
            if shirtColor == shoesColor {
                continue // Ignora la combinazione se i colori sono uguali
            }
            if let vietati = coloriVietati[shirtColor], vietati.contains(shoesColor) {
                coloreValido = false
            } else if let consentiti = coloriConsentiti[shirtColor], !consentiti.contains(shoesColor) {
                coloreValido = false
            }
        }
    }
    
    for trousersColor in trousersColors {
        for shoesColor in shoesColors {
            if trousersColor == shoesColor {
                continue // Ignora la combinazione se i colori sono uguali
            }
            if let vietati = coloriVietati[trousersColor], vietati.contains(shoesColor) {
                coloreValido = false
            } else if let consentiti = coloriConsentiti[trousersColor], !consentiti.contains(shoesColor) {
                coloreValido = false
            }
        }
    }
    
    return coloreValido
}

func quickStyleEvaluation(shirt: Cloth, trousers: Cloth, shoes: Cloth) -> Bool {
    let outfit = [shirt, trousers, shoes]
    
    var stileValido = true
    
    for c1 in outfit {
        for c2 in outfit {
            if c1.stile == Stile.formale && c1.stile != c2.stile && c1.stile != .NA && c2.stile != .NA {
                stileValido = false
            }
            if (c1.categoria == .giacca || c1.categoria == .giubbino) && c2.categoria == .pantaloncini {
                stileValido = false
            }
        }
    }
    
    return stileValido
}
