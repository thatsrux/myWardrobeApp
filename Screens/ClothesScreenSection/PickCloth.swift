import SwiftUI
import Firebase

let columns2 = [
    GridItem(.adaptive(minimum: 160))
]

struct PickCloth: View {
    
    @EnvironmentObject var database:Database
    
    @Environment(\.dismiss) private var dismiss
        
    @Binding var selectedCloth: Cloth?
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVGrid(columns: columns2, spacing: 10) {
                    ForEach(database.categorie.sorted(), id: \.self){ category in
                        Section(header: Text(categoriePlurale[Categoria(rawValue: category) ?? .NA]!).font(.headline)){
                            ForEach(database.clothes, id: \.self) { cloth in
                                if cloth.categoria.rawValue == category {
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
                                                }
                                            }
                                        }.frame(width: 150, height: 200)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .onTapGesture{
                                                selectedCloth = cloth
                                                dismiss()
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
}
