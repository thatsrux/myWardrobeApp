import SwiftUI

struct MagicOutfit: View{
    @State private var isClothGridScreenActive = false
    @State private var createMagicOutfit = false
    @EnvironmentObject var database: Database
    
    @State var cloth: Cloth?
    
    @State private var selectedCloth: [Categoria] = [.NA]
    
    @State var outfit: [Cloth] = []
    
    // Lista per memorizzare le combinazioni valide
    @State var validOutfits: [[Cloth]] = []
    
    @State var isOutfitCreated = false
    
    var body: some View{
        NavigationStack {
            VStack (alignment: .center) {
                    if !isOutfitCreated {
                        if let cloth = cloth {
                            if let image = cloth.image?.toImage() {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(minWidth:100, maxWidth:150, minHeight:100, maxHeight:150)
                                
                                Button(action: {
                                    generateOutfit(cloth: cloth)
                                    isOutfitCreated = true
                                }){
                                    RoundedRectangle(cornerRadius: 50)
                                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 100, height: 80)
                                        .overlay(
                                            Text("Crea outfit")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        )
                                }
                            } else {
                                Text("No Image Available")
                                    .foregroundColor(.gray)
                            }
                        }
                        else{
                            VStack(spacing:20){
                                Text("Genera casualmente un outfit a partire da un capo a scelta")
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 18, weight: .bold))
                                NavigationLink(destination: PickCloth(selectedCloth: $cloth)) {
                                        RoundedRectangle(cornerRadius: 50)
                                        .fill(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
                                        .frame(width: 100, height: 80)
                                        .overlay(
                                            Text("Scegli un capo")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                        }
                    } else {
                        if outfit.count == 3 {
                            Image(uiImage: (outfit[0].image?.toImage())!)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth:100, maxWidth:150, minHeight:100, maxHeight:150)
                            Image(uiImage: (outfit[1].image?.toImage())!)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth:100, maxWidth:150, minHeight:100, maxHeight:150)
                            Image(uiImage: (outfit[2].image?.toImage())!)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth:100, maxWidth:150, minHeight:100, maxHeight:150)
                            HStack(spacing:20) {
                                NavigationLink(destination: AddOutfitScreen(shirt: outfit[0], trousers: outfit[1], shoes: outfit[2])) {
                                    RoundedRectangle(cornerRadius: 50)
                                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 100, height: 80)
                                        .overlay(
                                            Text("Salva")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        )
                                }
                                Button(action: {
                                    outfit = validOutfits.randomElement()!
                                }){
                                    RoundedRectangle(cornerRadius: 50)
                                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 100, height: 80)
                                        .overlay(
                                            Text("Crea altro outfit")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        )
                                }
                                NavigationLink(destination: PickCloth(selectedCloth: $cloth)) {
                                    RoundedRectangle(cornerRadius: 50)
                                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 100, height: 80)
                                        .overlay(
                                            Text("Scegli un altro capo")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        ).onDisappear() {
                                            isOutfitCreated = false
                                        }
                                }
                            }
                        } else {
                            Text("Impossibile creare un outfit con il capo selezionato")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 18, weight: .bold))
                            Spacer().frame(height:200)
                            Image(uiImage: (cloth!.image?.toImage())!)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth:100, maxWidth:150, minHeight:100, maxHeight:150)
                            VStack(spacing:20){
                                NavigationLink(destination: PickCloth(selectedCloth: $cloth)) {
                                    RoundedRectangle(cornerRadius: 50)
                                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .indigo]), startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 100, height: 80)
                                        .overlay(
                                            Text("Scegli un altro capo")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        ).onDisappear() {
                                            isOutfitCreated = false
                                        }
                                }
                            }
                        }
                    }
            }
            .navigationTitle("Magic Outfit")
            .padding()
        }
    }
    
    func generateOutfit(cloth: Cloth) {
        outfit.removeAll()
        validOutfits.removeAll()
        var selectedCloth: [Categoria] = []
        
        if upperCat.contains(cloth.categoria) {
            selectedCloth = upperCat
        } else if lowerCat.contains(cloth.categoria) {
            selectedCloth = lowerCat
        } else if shoesCat.contains(cloth.categoria) {
            selectedCloth = shoesCat
        }
        
        // Determina le categorie mancanti
        var missingCategory1: [Categoria] = []
        var missingCategory2: [Categoria] = []
        
        if selectedCloth == upperCat {
            missingCategory1.append(contentsOf: lowerCat)
            missingCategory2.append(contentsOf: shoesCat)
        } else if selectedCloth == lowerCat {
            missingCategory1.append(contentsOf: upperCat)
            missingCategory2.append(contentsOf: shoesCat)
        } else if selectedCloth == shoesCat {
            missingCategory1.append(contentsOf: upperCat)
            missingCategory2.append(contentsOf: lowerCat)
        }
        
        // Trova tutti i vestiti nelle categorie mancanti
        let missingClothes1: [Cloth] = database.clothes.filter { missingCategory1.contains($0.categoria) }
        let missingClothes2: [Cloth] = database.clothes.filter { missingCategory2.contains($0.categoria) }
        
        // Prova tutte le combinazioni possibili
        for cloth1 in missingClothes1 {
            for cloth2 in missingClothes2 {
                let potentialOutfit = [cloth, cloth1, cloth2]
                if quickColorEvaluation(shirt: potentialOutfit[0], trousers: potentialOutfit[1], shoes: potentialOutfit[2]) &&
                    quickStyleEvaluation(shirt: potentialOutfit[0], trousers: potentialOutfit[1], shoes: potentialOutfit[2]) {
                    if let o = orderOutfit(potentialOutfit, selectedCloth: selectedCloth) {
                        validOutfits.append(o)
                    }
                }
            }
        }
        
        // Se ci sono outfit validi, seleziona il primo
        if let bestOutfit = validOutfits.first {
            outfit = bestOutfit
        }
    }

    func orderOutfit(_ bestOutfit: [Cloth], selectedCloth: [Categoria]) -> [Cloth]? {
        var outfit: [Cloth] = []
        
        if selectedCloth == upperCat {
            if lowerCat.contains(bestOutfit[1].categoria) && shoesCat.contains(bestOutfit[2].categoria) {
                outfit.append(bestOutfit[0])
                outfit.append(bestOutfit[1])
                outfit.append(bestOutfit[2])
            } else {
                outfit.append(bestOutfit[0])
                outfit.append(bestOutfit[2])
                outfit.append(bestOutfit[1])
            }
        } else if selectedCloth == lowerCat {
            if upperCat.contains(bestOutfit[1].categoria) && shoesCat.contains(bestOutfit[2].categoria) {
                outfit.append(bestOutfit[1])
                outfit.append(bestOutfit[0])
                outfit.append(bestOutfit[2])
            } else {
                outfit.append(bestOutfit[2])
                outfit.append(bestOutfit[0])
                outfit.append(bestOutfit[1])
            }
        } else if selectedCloth == shoesCat {
            if upperCat.contains(bestOutfit[1].categoria) && lowerCat.contains(bestOutfit[2].categoria) {
                outfit.append(bestOutfit[1])
                outfit.append(bestOutfit[2])
                outfit.append(bestOutfit[0])
            } else {
                outfit.append(bestOutfit[2])
                outfit.append(bestOutfit[1])
                outfit.append(bestOutfit[0])
            }
        } else {
            return nil
        }
        return outfit
    }
}
