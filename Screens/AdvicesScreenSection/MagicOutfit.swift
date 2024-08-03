import SwiftUI

struct MagicOutfit: View{
    @State private var isClothGridScreenActive = false
    @State private var createMagicOutfit = false
    @EnvironmentObject var database: Database
    
    @State var cloth: Cloth?
    
    @State private var selectedCloth: [Categoria] = [.NA]
    
    @State var outfit: [Cloth] = []
    
    @State var isOutfitCreated = false
    
    var body: some View{
        NavigationStack {
            ScrollView{
                VStack{
                    if !isOutfitCreated {
                        if let cloth = cloth {
                            if let image = cloth.image?.toImage() {
                                Spacer().frame(height:200)
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:100,height:100)
                                
                                Button(action: {
                                    generateOutfit(cloth: cloth)
                                    isOutfitCreated = true
                                }){
                                    Circle()
                                        .fill(Color(.purple))
                                        .frame(height: 100)
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
                                Spacer().frame(height:200)
                                NavigationLink(destination: PickCloth(selectedCloth: $cloth)) {
                                    Circle()
                                        .fill(Color(.purple))
                                        .frame(height: 100)
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
                                .frame(width:100,height:100)
                            Image(uiImage: (outfit[1].image?.toImage())!)
                                .resizable()
                                .scaledToFit()
                                .frame(width:100,height:100)
                            Image(uiImage: (outfit[2].image?.toImage())!)
                                .resizable()
                                .scaledToFit()
                                .frame(width:100,height:100)
                            HStack(spacing:20) {
                                NavigationLink(destination: AddOutfitScreen(shirt: outfit[0], trousers: outfit[1], shoes: outfit[2])) {
                                    Circle()
                                        .fill(Color(.purple))
                                        .frame(height: 100)
                                        .overlay(
                                            Text("Salva")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        )
                                }
                                Button(action: {
                                    generateOutfit(cloth: cloth!)
                                    isOutfitCreated = true
                                }){
                                    Circle()
                                        .fill(Color(.purple))
                                        .frame(height: 100)
                                        .overlay(
                                            Text("Crea altro outfit")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        )
                                }
                                NavigationLink(destination: PickCloth(selectedCloth: $cloth)) {
                                    Circle()
                                        .fill(Color(.purple))
                                        .frame(height: 100)
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
                            Spacer().frame(height:200)
                            Image(uiImage: (cloth!.image?.toImage())!)
                                .resizable()
                                .scaledToFit()
                                .frame(width:100,height:100)
                            VStack(spacing:20){
                                NavigationLink(destination: PickCloth(selectedCloth: $cloth)) {
                                    Circle()
                                        .fill(Color(.purple))
                                        .frame(height: 100)
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
            }
            .navigationTitle("Magic Outfit")
        }
    }
    
    func generateOutfit(cloth: Cloth) {
        outfit.removeAll()
        if upperCat.contains(cloth.categoria) {
            selectedCloth = upperCat
        } else if lowerCat.contains(cloth.categoria) {
            selectedCloth = lowerCat
        } else if shoesCat.contains(cloth.categoria) {
            selectedCloth = shoesCat
        }
        
        // Array per memorizzare i vestiti selezionati
        var selectedOutfit: [Cloth] = []
        
        // Aggiungi il vestito passato come parametro
        selectedOutfit.append(cloth)
        
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
        for cloth in database.clothes {
            if missingCategory1.contains(cloth.categoria) {
                selectedOutfit.append(cloth)
                break
            }
        }
        for cloth in database.clothes {
            if missingCategory2.contains(cloth.categoria) {
                selectedOutfit.append(cloth)
                break
            }
        }
        if quickColorEvaluation(shirt: selectedOutfit[0], trousers: selectedOutfit[1], shoes: selectedOutfit[2]) && quickStyleEvaluation(shirt: selectedOutfit[0], trousers: selectedOutfit[1], shoes: selectedOutfit[2]) {
            print(selectedOutfit[0].nome, selectedOutfit[1].nome, selectedOutfit[2].nome)
            
            if selectedCloth == upperCat {
                outfit.append(cloth)
                if lowerCat.contains(selectedOutfit[1].categoria) && shoesCat.contains(selectedOutfit[2].categoria) {
                    outfit.append(selectedOutfit[1])
                    outfit.append(selectedOutfit[2])
                } else {
                    outfit.append(selectedOutfit[2])
                    outfit.append(selectedOutfit[1])
                }
            } else if selectedCloth == lowerCat {
                if upperCat.contains(selectedOutfit[1].categoria) && shoesCat.contains(selectedOutfit[2].categoria) {
                    outfit.append(selectedOutfit[1])
                    outfit.append(cloth)
                    outfit.append(selectedOutfit[2])
                } else {
                    outfit.append(selectedOutfit[2])
                    outfit.append(cloth)
                    outfit.append(selectedOutfit[1])
                }
            } else {
                if upperCat.contains(selectedOutfit[1].categoria) && lowerCat.contains(selectedOutfit[2].categoria) {
                    outfit.append(selectedOutfit[1])
                    outfit.append(selectedOutfit[2])
                } else {
                    outfit.append(selectedOutfit[2])
                    outfit.append(selectedOutfit[1])
                }
                outfit.append(cloth)
            }
        }
    }
}
