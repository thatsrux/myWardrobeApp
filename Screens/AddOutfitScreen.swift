import SwiftUI
import Firebase

struct AddOutfitScreen: View {
    @State private var isAddToOutfitScreenActive = false
    @EnvironmentObject var database: Database
    @Environment(\.dismiss) private var dismiss
    
    @State private var categoria: [Categoria] = [.NA]
    @State var shirt: Cloth?
    @State var trousers: Cloth?
    @State var shoes: Cloth?
    
    @State var nomeText = ""
    @State var stile = Stile.NA
    
    @State var coloreValido = true
    @State var spiegazioneColore = ""
    
    @State var stileValido = true
    @State var spiegazioneStile = ""
    
    var outfit: Outfit?
    @State var isStarFilled : Bool
    
    var edit = false
    @State var first = true
    
    init(outfit:Outfit) {
        self.outfit = outfit
        edit = true
        self._isStarFilled = State(initialValue: outfit.favourite)
    }
    
    init(){
        self._isStarFilled = State(initialValue: false)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                Spacer().frame(height: 50)
                VStack(spacing:20){
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = upperCat
                    }) {
                        if let shirt = shirt, let image = shirt.image?.toImage() {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .frame(width:150,height:150)
                        } else {
                            Image(uiImage: UIImage(imageLiteralResourceName: "imageNA"))
                                .resizable()
                        }
                    }
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = lowerCat
                    }) {
                        if let trousers = trousers, let image = trousers.image?.toImage() {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .frame(width:150,height:150)
                        } else {
                            Image(uiImage: UIImage(imageLiteralResourceName: "imageNA"))
                                .resizable()
                        }
                    }
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = shoesCat
                    }) {
                        if let shoes = shoes, let image = shoes.image?.toImage() {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .frame(width:150,height:150)
                        } else {
                            
                            Image(uiImage: UIImage(imageLiteralResourceName: "imageNA"))
                                .resizable()
                        }
                    }
                }.frame(width: 200, height: 550)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(10)
                
                VStack(spacing: 20){
            
                    Text("Preferiti: \($isStarFilled.wrappedValue)")

                    LabeledContent {
                        TextField("Nome outfit", text: $nomeText)
                            .font(.system(size: 18))
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
                }.onAppear{
                    database.fetchOutfits()
                    //print(database.favOutfits)

                }
                .padding(35)
            }.onAppear{
                updateOutfit()
                listenToOutfitChanges()
                if shirt != nil && trousers != nil && shoes != nil {
                    spiegazioneColore=outfitColorEvaluation(shirt: shirt!, trousers: trousers!, shoes: shoes!)
                    spiegazioneStile=outfitStyleEvaluation(shirt: shirt!, trousers: trousers!, shoes: shoes!)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
        
                    Button{
                        favouriteToggle(outfit: outfit!)
                    }
                label:{
                    Image(systemName: isStarFilled ? "star.fill" : "star")
                }.disabled(!edit)
                    
                    Button(action: {
                        saveOutfit()
                        dismiss()
                    }) {
                        Text("Salva")
                    }
                    if edit {
                        Button(action: {
                            deleteOutfit(outfit: outfit!)
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
        if first == true {
            guard let outfit = outfit else {return}
            
            guard let shirt = outfit.shirt, let trousers = outfit.trousers, let shoes = outfit.shoes else {
                print("error shirt/trousers/shoes")
                return}
            self.shirt = shirt
            self.trousers = trousers
            self.shoes = shoes
            self.nomeText = outfit.nome!
            self.stile = outfit.stile
            self.isStarFilled = outfit.favourite
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
            "favourite": outfit.favourite

        ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        database.fetchOutfits()
        database.fetchCategorieOutfit()
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
            "favourite": outfit!.favourite
        ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        database.fetchOutfits()
        database.fetchCategorieOutfit()
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
                if c1.stile != c2.stile && c1.stile != .NA && c2.stile != .NA {
                    combinazionePerfetta = false
                }
            }
        }
        
        if stileValido {
            valutazione = "L'outfit è ben coordinato\n"
            if combinazionePerfetta {
                valutazione.append("(stile " + shirt.stile.rawValue+")")
                stile = shirt.stile
            } else {
                valutazione.append("(stile sportivo e casual)")
                stile = .casual
            }
        }
        
        return valutazione
    }
    
    
    func deleteOutfit(outfit: Outfit){
        Firestore.firestore().collection("Outfit").document(outfit.id.uuidString).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document \(outfit.id) successfully removed!")
            }
        }
        database.fetchOutfits()
        database.fetchCategorieOutfit()
    }
    
    func favouriteToggle(outfit:Outfit){
        outfit.favourite.toggle()
        self.isStarFilled = outfit.favourite
        
        let db = Firestore.firestore()
        let ref = db.collection("Outfit").document(outfit.id.uuidString)
        ref.updateData([
            "favourite": outfit.favourite
        ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        database.fetchOutfits()
        database.fetchCategorieOutfit()
    }
    
    func listenToOutfitChanges() {
        guard let outfitId = outfit?.id.uuidString else { return }
        
        let db = Firestore.firestore()
        let ref = db.collection("Outfit").document(outfitId)
        
        ref.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("Error listening to outfit changes: \(error)")
                return
            }
            
            guard let document = documentSnapshot, document.exists,
                  let data = document.data() else {
                print("Document does not exist")
                return
            }
            
            if let favourite = data["favourite"] as? Bool {
                self.isStarFilled = favourite
            }
        }
    }

}


//
//#Preview {
//    AddOutfitScreen()
//}

