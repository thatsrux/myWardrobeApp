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
    var outfit: Outfit?
    
    
    init(outfit:Outfit) {
        self.outfit = outfit
    }
    
    init(){
        
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                Spacer().frame(height: 50)
                VStack(spacing:60){
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = upperCat
                    }) {
                        if let shirt = shirt, let image = shirt.image?.toImage() {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width:100,height:100)
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
                                .frame(width:100,height:100)
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
                                .frame(width:100,height:100)
                        } else {
                            
                            Image(uiImage: UIImage(imageLiteralResourceName: "imageNA"))
                                .resizable()
                        }
                    }
                }.frame(width:200, height: 500,alignment: Alignment.center)
                    .border(Color.black)
                
                Text("Valutazione")
                if shirt != nil && trousers != nil && shoes != nil {
                    Text(outfitColorEvaluation(shirt: shirt!, trousers: trousers!, shoes: shoes!))
                }
            }.onAppear{
                updateOutfit()
            }.toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        saveOutfit()
                        dismiss()
                    }) {
                        Text("Salva")
                    }
                }
            }
            
        }
        .navigationTitle("Componi Outfit")
        .navigationDestination(isPresented: $isAddToOutfitScreenActive){
            AddToOutfitScreen(category: $categoria,shirtToAdd: $shirt,trousersToAdd:$trousers,shoesToAdd:$shoes)
        }
        
    }
    
    func updateOutfit() {
        guard let outfit = outfit else {return}
        
        guard let shirt = outfit.shirt, let trousers = outfit.trousers, let shoes = outfit.shoes else {
            print("error shirt/trousers/shoes")
            return}
        
        self.shirt = shirt
        self.trousers = trousers
        self.shoes = shoes
        
    }
    
    
    func saveOutfit(){
        
        let outfit = Outfit(shirt:shirt!,trousers: trousers!,shoes:shoes!)
        
        let db = Firestore.firestore()
        let ref = db.collection("Outfit").document(outfit.id.uuidString)
        ref.setData(["shirtId": shirt!.id.uuidString,
                     "trousersId" : trousers!.id.uuidString,
                     "shoesId" : shoes!.id.uuidString
                    ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func outfitColorEvaluation(shirt: Cloth, trousers: Cloth, shoes: Cloth) -> String {
        var combinazioneValida = true
        var valutazione = ""
        
        var shirtColors = [closestColor(to: shirt.mainColor.uiColor)]
        if shirt.colorsNum > 1 {
            shirtColors.append(closestColor(to: shirt.secondColor.uiColor))
        }
        if shirt.colorsNum > 2 {
            shirtColors.append(closestColor(to: shirt.thirdColor.uiColor))
        }
        
        var trousersColors = [closestColor(to: trousers.mainColor.uiColor)]
        if trousers.colorsNum > 1 {
            trousersColors.append(closestColor(to: trousers.secondColor.uiColor))
        }
        if trousers.colorsNum > 2 {
            trousersColors.append(closestColor(to: trousers.thirdColor.uiColor))
        }
        
        var shoesColors = [closestColor(to: shoes.mainColor.uiColor)]
        if shoes.colorsNum > 1 {
            shoesColors.append(closestColor(to: shoes.secondColor.uiColor))
        }
        if shoes.colorsNum > 2 {
            shoesColors.append(closestColor(to: shoes.thirdColor.uiColor))
        }
        
        for shirtColor in shirtColors {
            for trousersColor in trousersColors {
                if shirtColor == trousersColor {
                    continue // Ignora la combinazione se i colori sono uguali
                }
                if let vietati = coloriVietati[shirtColor], vietati.contains(trousersColor) {
                    valutazione.append("Combinazione da evitare: \(shirtColor.rawValue) e \(trousersColor.rawValue)\n")
                    combinazioneValida = false
                } else if let consentiti = coloriConsentiti[shirtColor], !consentiti.contains(trousersColor) {
                    valutazione.append("Combinazione da evitare: \(shirtColor.rawValue) e \(trousersColor.rawValue)\n")
                    combinazioneValida = false
                }
            }
        }
        
        for shirtColor in shirtColors {
            for shoesColor in shoesColors {
                if shirtColor == shoesColor {
                    continue // Ignora la combinazione se i colori sono uguali
                }
                if let vietati = coloriVietati[shirtColor], vietati.contains(shoesColor) {
                    valutazione.append("Combinazione da evitare: \(shirtColor.rawValue) e \(shoesColor.rawValue)\n")
                    combinazioneValida = false
                } else if let consentiti = coloriConsentiti[shirtColor], !consentiti.contains(shoesColor) {
                    valutazione.append("Combinazione da evitare: \(shirtColor.rawValue) e \(shoesColor.rawValue)\n")
                    combinazioneValida = false
                }
            }
        }
        
        for trousersColor in trousersColors {
            for shoesColor in shoesColors {
                if trousersColor == shoesColor {
                    continue // Ignora la combinazione se i colori sono uguali
                }
                if let vietati = coloriVietati[trousersColor], vietati.contains(shoesColor) {
                    valutazione.append("Combinazione da evitare: \(trousersColor.rawValue) e \(shoesColor.rawValue)\n")
                    combinazioneValida = false
                } else if let consentiti = coloriConsentiti[trousersColor], !consentiti.contains(shoesColor) {
                    valutazione.append("Combinazione da evitare: \(trousersColor.rawValue) e \(shoesColor.rawValue)\n")
                    combinazioneValida = false
                }
            }
        }
        
        if combinazioneValida {
            valutazione.append("Combinazione valida: shirt - \(shirtColors.map { $0.rawValue }.joined(separator: ", ")), trousers - \(trousersColors.map { $0.rawValue }.joined(separator: ", ")), shoes - \(shoesColors.map { $0.rawValue }.joined(separator: ", "))")
        }
        
        return valutazione
    }
    
    func outfitStyleEvaluation(shirt: Cloth, trousers: Cloth, shoes: Cloth) -> String {
        var outfit = [shirt, trousers, shoes]
        
        var combinazioneValida = true
        var valutazione = ""
        
        var shirtStyle = shirt.stile
    
        var trousersStyle = trousers.stile
        
        var shoesStyle = shoes.stile
        
        for c1 in outfit {
            for c2 in outfit {
                if c1.stile == Stile.formale && c1.stile != c2.stile {
                    print("Stai male, non puoi mettere \(c1.stile) con \(c2.stile)")
                }
            }
        }
        
//        Stile.casual
//        Stile.formale
//        Stile.sportivo
//        
        return valutazione
    }
}
//
//#Preview {
//    AddOutfitScreen()
//}

