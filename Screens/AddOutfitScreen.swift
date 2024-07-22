import SwiftUI
import Firebase

struct AddOutfitScreen: View {
    @State private var isAddToOutfitScreenActive = false
    @EnvironmentObject var database:Database
    var cloth:Cloth?
    
    var upperCloth:Cloth?
    var lowerCloth:Cloth?
    var shoesCloth:Cloth?
    
    @State private var categoria: Categoria = .NA
    
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
                                    // Handle the case where the image is nil
                                    Text("No Image")
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
                                    // Handle the case where the image is nil
                                    Text("No Image")
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
                                    // Handle the case where the image is nil
                                    Text("No Image")
                                }
                        }
                    
                }.frame(width:150, height: 300,alignment: Alignment.center)
                    .border(Color.black)
                
                
                Spacer().frame(height: 50)
                
                Text("Outfit già composti")
                
                Spacer().frame(height: 20)
                
                ScrollView(.horizontal){
                    HStack(spacing:20){
                        ForEach(0..<10) {
                            Text("Outfit \($0)")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                                .frame(width: 200, height: 350)
                                .background(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Componi Outfit")
        .navigationDestination(isPresented: $isAddToOutfitScreenActive){
            AddToOutfitScreen(category: categoria)
        }
        
    }
}
//
//#Preview {
//    AddOutfitScreen()
//}
