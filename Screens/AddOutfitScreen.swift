import SwiftUI
import Firebase

struct AddOutfitScreen: View {
    @State private var isAddToOutfitScreenActive = false
    @EnvironmentObject var database:Database
    //var outfit:[Outfit]
    @State private var categoria: Categoria = .NA
    
    var body: some View {
        NavigationStack {
            ScrollView{
                Spacer().frame(height: 50)
                VStack(spacing:60){
                    Button("",systemImage: "tshirt") {
                        isAddToOutfitScreenActive = true
                        categoria = .tshirt
                    }
                    Button("",systemImage: "plus") {
                        isAddToOutfitScreenActive = true
                        categoria = .pantalone
                    }
                    Button("",systemImage: "shoe") {
                        isAddToOutfitScreenActive = true
                        categoria = .scarpe
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
