import SwiftUI
import Firebase

struct AddOutfitScreen: View {
    @State private var isAddToOutfitScreenActive = false
    @EnvironmentObject var database:Database
    
    
    var upperCloth:Cloth?
    var lowerCloth:Cloth?
    var shoesCloth:Cloth?
    
    @State private var categoria: Categoria = .NA
    @State var cloth:Cloth?
    
    init(cloth:Cloth){
        self.cloth = cloth
        
        switch cloth.categoria {
        case .tshirt:
            self.upperCloth = cloth
        case .camicia:
            self.upperCloth = cloth
        case .canotta:
            self.upperCloth = cloth
        case .cappello:
            self.upperCloth = cloth
        case .giacca:
            self.upperCloth = cloth
        case .giubbino:
            self.upperCloth = cloth
        case .felpa:
            self.upperCloth = cloth
        case .maglione:
            self.upperCloth = cloth
            
        case .pantaloncini:
            self.lowerCloth = cloth
        case .pantalone:
            self.lowerCloth = cloth
            
        case .scarpe:
            self.shoesCloth = cloth
        
        case .NA:
            self.upperCloth = cloth
            self.lowerCloth = cloth
            self.shoesCloth = cloth
            
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
                            if let upperCloth = upperCloth, let image = upperCloth.image?.toImage() {
                                    Image(uiImage: image)
                                        .resizable()
                                } else {
                                    Image(uiImage: UIImage(imageLiteralResourceName: "test6"))
                                        .resizable()
                                }
                        }
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = .pantalone
                        }) {
                            if let lowerCloth = lowerCloth, let image = lowerCloth.image?.toImage() {
                                    Image(uiImage: image)
                                        .resizable()
                                } else {
                                    Image(uiImage: UIImage(imageLiteralResourceName: "test1"))
                                        .resizable()
                                }
                        }
                    Button(action: {
                        isAddToOutfitScreenActive = true
                        categoria = .scarpe
                        }) {
                            if let shoesCloth = shoesCloth, let image = shoesCloth.image?.toImage() {
                                    Image(uiImage: image)
                                        .resizable()
                                } else {
                                    
                                    Image(uiImage: UIImage(imageLiteralResourceName: "paperino"))
                                        .resizable()
                                }
                        }
                    
                }.frame(width:150, height: 300,alignment: Alignment.center)
                    .border(Color.black)
                
                
                
            }
        }
        .navigationTitle("Componi Outfit")
        .navigationDestination(isPresented: $isAddToOutfitScreenActive){
            AddToOutfitScreen(category: $categoria,clothToAdd: $cloth)
        }
        
    }
}
//
//#Preview {
//    AddOutfitScreen()
//}
