import SwiftUI
import Firebase

let columns = [
    GridItem(.adaptive(minimum: 160))
]

struct ClothesGrid: View {
    
    @EnvironmentObject var database:Database
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(database.categorie.sorted(), id: \.self){ category in
                    Section(header: Text(categoriePlurale[Categoria(rawValue: category) ?? .NA]!).font(.headline)){
                        ForEach(database.clothes, id: \.self) { cloth in
                            if cloth.categoria.rawValue == category {
                                NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                    SingleClothGrid(cloth: cloth)
                                }
                            }
                        }
                    }
                }.padding(.bottom,20)
            }
            .padding()
        }
    }
}


struct SingleClothGrid: View, Favourable {
    
    @EnvironmentObject var database:Database
    private let cloth: Cloth
    
    init(cloth: Cloth) {
        self.cloth = cloth
    }
    
    var body: some View {
        VStack{
            VStack {
                Image(uiImage: (cloth.image?.toImage())!)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .cornerRadius(10)
                    .padding(5)
                HStack{
                    Circle().fill(cloth.mainColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                    if cloth.colorsNum > 1 {
                        Circle().fill(cloth.secondColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        if cloth.colorsNum > 2 {
                            Circle().fill(cloth.thirdColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        }
                    }
                }
                Text(cloth.nome)
                    .padding(5)
                    .foregroundStyle(.black)
                if cloth.taglia != .NA {
                    Text(cloth.taglia.rawValue)
                        .padding(.bottom,10)
                }
            }
        }.frame(width: 150, height: 200)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .contextMenu(menuItems: {
                
                
                Button{
                    favouriteToggle(cloth: cloth)
                    database.fetchClothes()
                }
            label:{
                Label(!cloth.favourite ? "Aggiungi ai preferiti" : "Rimuovi dai preferiti", systemImage:!cloth.favourite ? "star" : "star.fill")
            }
                Button(role: .destructive) {
                    database.deleteCloth(cloth: cloth)
                }
            label:{
                Label("Elimina", systemImage: "trash")
            }
            })
    }
    
}
