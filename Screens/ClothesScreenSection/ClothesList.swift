import SwiftUI
import Firebase

struct ClothesList: View {
    
    @EnvironmentObject var database:Database
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(database.categorie.sorted(), id: \.self){ category in
                Section(header: Text(categoriePlurale[Categoria(rawValue: category)!]!).font(.headline)){
                    ForEach(database.clothes, id: \.self) { cloth in
                        if cloth.categoria.rawValue == category {
                            NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                SingleClothList(cloth: cloth)
                            }
                        }
                    }.onDelete(perform: deleteClothSwipe)
                }
            }
        }
    }
    
    func deleteClothSwipe(at offsets:IndexSet){
        
        guard let index = offsets.first else {
            print("No index available to delete")
            return
        }
        
        guard index >= 0 && index < database.clothes.count else {
            print("Index \(index) out of range")
            return
        }
        
        let clothToDelete = database.clothes[index]
        
        database.deleteCloth(cloth: clothToDelete)
    }
    
}


struct SingleClothList: View {
    
    @EnvironmentObject var database:Database
    private let cloth: Cloth
    
    init(cloth: Cloth) {
        self.cloth = cloth
    }
    
    var body: some View {
        HStack {
            VStack{
                Image(uiImage: (cloth.image?.toImage())!)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width:100,height:100)
                HStack{
                    Circle().fill(cloth.mainColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                    if cloth.colorsNum > 1 {
                        Circle().fill(cloth.secondColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        if cloth.colorsNum > 2 {
                            Circle().fill(cloth.thirdColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        }
                    }
                }.padding(.bottom,10)
            }
            
            Spacer().frame(width: 30, height: 100)
            
            VStack(spacing:5){
                Text(cloth.nome).frame(maxWidth: .infinity, alignment: .leading)
                if cloth.taglia != .NA {
                    Text(cloth.taglia.rawValue).frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
