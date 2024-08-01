import SwiftUI
import ColorKit

struct AdvicesScreen: View {
    
    @EnvironmentObject var database:Database
    
    @State private var dailyOutfitIndex: Int?
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("Outfit del giorno").font(.headline)
                
                if let index = dailyOutfitIndex, !database.outfits.isEmpty {
                    NavigationLink(destination: AddOutfitScreen(outfit: database.outfits[index])) {
                        SingleOutfitGrid(outfit: database.outfits[index])
                    }
                } else {
                    Text("No outfit available").font(.subheadline).foregroundColor(.gray)
                }
            }
            .navigationTitle("Consigli per te")
            .onAppear {
                if !database.outfits.isEmpty {
                    dailyOutfitIndex = Int.random(in: 0..<database.outfits.count)
                }
                
            }
            
            
            
            
            .navigationTitle("Consigli per te")
        }
        
    }
    
    
    struct SingleOutfitGrid: View {
        
        @EnvironmentObject var database:Database
        
        private var outfit: Outfit
        
        
        init(outfit: Outfit){
            self.outfit = outfit
        }
        
        var body: some View {
            HStack{
                VStack(spacing:10){
                    Image(uiImage: outfit.shirt?.image?.toImage() ?? UIImage(imageLiteralResourceName: "shirt"))
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width:100,height:100)
                    Image(uiImage: outfit.trousers?.image?.toImage() ?? UIImage(imageLiteralResourceName: "trousers"))
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width:100,height:100)
                    Image(uiImage: outfit.shoes?.image?.toImage() ?? UIImage(imageLiteralResourceName: "shoes"))
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width:100,height:100)
                    Text(outfit.nome!)
                        .foregroundStyle(.black)
                }.frame(width: 150, height: 370)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(10)
            }
        }
    }
}
#Preview {
    AdvicesScreen()
}
