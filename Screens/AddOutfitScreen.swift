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
    var outfit:Outfit?
    
    
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
    
    }
    //
    //#Preview {
    //    AddOutfitScreen()
    //}

