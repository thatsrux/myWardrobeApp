import SwiftUI

struct MagicOutfit: View{
    @State private var isClothGridScreenActive = false
    @State private var createMagicOutfit = false
    
    @State var cloth: Cloth?
    
    var outfit:Outfit?
    
    var body: some View{
        NavigationStack {
            ScrollView{
                VStack{
                    if let cloth = cloth {
                        if let image = cloth.image?.toImage() {
                            Spacer().frame(height:200)
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width:100,height:100)
                            
                            Button(action: {
                               print("Crea outfit")
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
                }
            }
            .navigationTitle("Magic Outfit")
        }
    }
}
