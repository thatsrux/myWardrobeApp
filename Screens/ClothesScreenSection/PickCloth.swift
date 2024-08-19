import SwiftUI
import Firebase

let columns2 = [
    GridItem(.adaptive(minimum: 160))
]

struct PickCloth: View {
    
    @EnvironmentObject var database:Database
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @State private var selectedOption2 = "AllTypes"
    
    @State private var favouriteActive = false
        
    @Binding var selectedCloth: Cloth?
    
    var body: some View {
        NavigationStack{
            VStack {
                if !database.clothes.isEmpty{
                    if selectedOption2 == "AllTypes" && !favouriteActive && searchText == "" {
                            ScrollView {
                                LazyVGrid(columns: columns2, spacing: 10) {
                                    ForEach(database.categorie.sorted(), id: \.self){ category in
                                        Section(header: Text(categoriePlurale[Categoria(rawValue: category) ?? .NA]!).font(.headline)){
                                            ForEach(database.clothes, id: \.self) { cloth in
                                                if cloth.categoria.rawValue == category {
                                                        SingleClothGrid(cloth: cloth)
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
                    else {
                        ScrollView{
                            LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(database.clothes, id: \.self) { cloth in
                                        if (favouriteActive && cloth.favourite || !favouriteActive ) && // Filtraggio preferiti
                                            (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") && // Filtraggio tipo
                                            (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "") { // Ricerca
                                                SingleClothGrid(cloth: cloth)
                                                .onTapGesture{
                                                    selectedCloth = cloth
                                                    dismiss()
                                                }
                                        }
                                    }
                            }.padding()
                        }
                    }
                }
                else{
                    Text("Inserisci un capo d'abbigliamento")
                }
            }
        }.toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    if !favouriteActive {
                        favouriteActive = true
                    } else {
                        favouriteActive = false
                    }
                } label: {
                    if !favouriteActive {
                        Image(systemName: "star")
                    } else {
                        Image(systemName: "star.fill")
                    }
                }
                Menu() {
                    Picker(selection: $selectedOption2, label: Text("Options")) {
                        Text("Tutti i tipi").tag("AllTypes")
                        ForEach(Categoria.allCases, id: \.self) { cat in
                            if cat != .NA {
                                Text(categoriePlurale[Categoria(rawValue: cat.rawValue) ?? .NA]!).tag(cat.rawValue)
                            }
                        }
                    }
                } label:{
                    Text("Tipi")
                }
            }
        }
    }
}
