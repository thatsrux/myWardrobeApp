import SwiftUI
import Firebase

struct AddOutfitScreen: View {
    @State private var isAddToOutfitScreenActive = false
    @EnvironmentObject var database:Database
    @Environment(\.dismiss) private var dismiss
    
    @State private var categoria: Categoria = .NA
    @State var shirt:Cloth?
    @State var trousers:Cloth?
    @State var shoes:Cloth?
    @State var outfit:Outfit?
    
    
    init(outfit:Outfit?) {
        if let outfit = outfit{
            self.outfit = outfit
            self.shirt = outfit.shirt
            self.trousers = outfit.trousers
            self.shoes = outfit.shoes
        }
        
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
                        categoria = .tshirt
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
                        categoria = .pantalone
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
                        categoria = .scarpe
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
                
            }.onAppear{
                updateOutfit(outfit: outfit ?? Outfit(shirt: Cloth(image: UIImage(imageLiteralResourceName: "imageNA")), trousers: Cloth(image: UIImage(imageLiteralResourceName: "imageNA")) , shoes: Cloth(image: UIImage(imageLiteralResourceName: "imageNA"))))
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
    
    func updateOutfit(outfit:Outfit){
        self.shirt = outfit.shirt
        self.trousers = outfit.trousers
        self.shoes = outfit.shoes
    }
    
    func saveOutfit(){
        guard let shirt = shirt, let trousers = trousers, let shoes = shoes else { return }
                let newOutfit = Outfit(shirt: shirt, trousers: trousers, shoes: shoes)
                database.outfits.append(newOutfit)
    }
    
}
//
//#Preview {
//    AddOutfitScreen()
//}
