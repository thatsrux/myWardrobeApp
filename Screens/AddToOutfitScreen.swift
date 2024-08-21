import SwiftUI
import Firebase

struct AddToOutfitScreen: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    @State private var isInfoClothScreenActive = false
    @State private var isEditClothScreenActive = false
    @State private var returnCloth = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @EnvironmentObject var database: Database
    @Environment(\.dismiss) private var dismiss
    
    var onDismiss: ((_ model: Cloth) -> Void)?
    
    @Binding var category: [Categoria]
    
    @Binding var shirtToAdd: Cloth?
    @Binding var trousersToAdd: Cloth?
    @Binding var shoesToAdd: Cloth?
    
    @State private var selectedOption2 = "AllTypes"
    
    @State private var favouriteActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if !database.clothes.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(category.filter { cat in
                                let filteredClothes = database.clothes.filter { cloth in
                                    (favouriteActive && cloth.favourite || !favouriteActive) &&
                                    (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") &&
                                    (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "") &&
                                    cloth.categoria == cat
                                }
                                return !filteredClothes.isEmpty
                            }, id: \.self) { cat in
                                Section(header: Text(categoriePlurale[Categoria(rawValue: cat.rawValue) ?? .NA]!).font(.headline)) {
                                    ForEach(database.clothes.filter { cloth in
                                        (favouriteActive && cloth.favourite || !favouriteActive) &&
                                        (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") &&
                                        (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "") &&
                                        cloth.categoria == cat
                                    }) { cloth in
                                        Button(action: {
                                            chooseClothType(cloth: cloth)
                                        }) {
                                            SingleClothGrid(cloth: cloth)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    Text("Inserisci un capo d'abbigliamento")
                }
            }
            .navigationTitle(
                category == upperCat ? "Parte superiore" :
                    category == lowerCat ? "Parte inferiore" :
                    "Scarpe"
            )
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        favouriteActive.toggle()
                    } label: {
                        Image(systemName: favouriteActive ? "star.fill" : "star")
                    }
                    Menu {
                        Picker(selection: $selectedOption2, label: Text("Options")) {
                            Text("Tutti i tipi").tag("AllTypes")
                            ForEach(category, id: \.self) { cat in
                                if cat != .NA {
                                    Text(categoriePlurale[Categoria(rawValue: cat.rawValue) ?? .NA]!).tag(cat.rawValue)
                                }
                            }
                        }
                    } label: {
                        Text("Tipi")
                    }
                }
            }
            .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca capo")
        }
    }
    
    func chooseClothType(cloth: Cloth) {
        if upperCat.contains(cloth.categoria) {
            shirtToAdd = cloth
            onDismiss?(shirtToAdd!)
        } else if lowerCat.contains(cloth.categoria) {
            trousersToAdd = cloth
            onDismiss?(trousersToAdd!)
        } else if shoesCat.contains(cloth.categoria) {
            shoesToAdd = cloth
            onDismiss?(shoesToAdd!)
        }
        
        dismiss()
    }
}
