import SwiftUI
import Firebase

struct ClothesScreen: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isInfoClothScreenActive = false
    @State private var isEditClothScreenActive = false
    
    @State private var loading = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @Binding var clothes : [Cloth]
    
    @EnvironmentObject var database:Database
    
    @State private var selectedOption = "icone"
    @State private var selectedOption2 = "AllTypes"
    
    @State private var favouriteActive = false
    
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
    
    var body: some View {
        NavigationStack {
            VStack {
                if loading {
                    ProgressView("Elaborazione immagine in corso").frame(maxHeight: .infinity, alignment: .center)
                } else {
                    if !database.clothes.isEmpty {
                        if selectedOption == "elenco" {
                            if selectedOption2 == "AllTypes" && !favouriteActive && searchText == "" {
                                ClothesList()
                            }
                            else {
                                List{
                                    ForEach(database.clothes, id: \.self) { cloth in
                                        if (favouriteActive && cloth.favourite || !favouriteActive ) && // Filtraggio preferiti
                                            (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") && // Filtraggio tipo
                                            (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "") { // Ricerca
                                            NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                SingleClothList(cloth: cloth)
                                            }
                                        }
                                    }.onDelete(perform: deleteClothSwipe)
                                }
                            }
                        } else {
                            if selectedOption2 == "AllTypes" && !favouriteActive && searchText == "" {
                                ClothesGrid()
                            }
                            else {
                                ScrollView{
                                    LazyVGrid(columns: columns, spacing: 10) {
                                        ForEach(database.clothes, id: \.self) { cloth in
                                            if (favouriteActive && cloth.favourite || !favouriteActive ) && // Filtraggio preferiti
                                                (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") && // Filtraggio tipo
                                                (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "") { // Ricerca
                                                NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                    SingleClothGrid(cloth: cloth)
                                                }
                                            }
                                        }
                                    }.padding()
                                }
                            }
                        }
                    }
                    else{
                        if database.clothesNum <= 0 {
                            Text("Inserisci un capo d'abbigliamento")
                        } else {
                            ProgressView("Aggiornamento guardaroba in corso").frame(maxHeight: .infinity, alignment: .center)
                        }
                    }
                }
            }
            .navigationTitle(getNavigationTitle())
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu() {
                        Button(action: {
                            isPresenting = true
                            sourceType = .photoLibrary
                        }) {
                            Text("Scegli foto")
                            Image(systemName: "photo.on.rectangle")
                        }
                        
                        Button(action: {
                            isPresenting = true
                            sourceType = .camera
                        }) {
                            Text("Scatta foto")
                            Image(systemName: "camera")
                        }
                    }
                label:{
                    Image(systemName: "camera")
                }
                    
                    Menu() {
                        Picker(selection: $selectedOption, label: Text("Options")) {
                            HStack{
                                Text("Icone")
                                Image(systemName: "square.grid.2x2")
                            }.tag("icone")
                            
                            HStack{
                                Text("Elenco")
                                Image(systemName: "list.bullet")
                            }.tag("elenco")
                        }
                    }
                label:{
                    Image(systemName: "ellipsis.circle")
                }
                    
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
            .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca capo")
            .sheet(isPresented: $isPresenting){
                ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                    .onDisappear {
                        if uiImage != nil {
                            isInfoClothScreenActive = true
                            loading = true
                        }
                    }
            }
            
            .navigationDestination(isPresented: $isInfoClothScreenActive) {
                if uiImage != nil {
                    InfoClothScreen(image: uiImage!)
                        .onDisappear {
                            uiImage = nil
                            isInfoClothScreenActive = false
                        }
                        .onAppear {
                            loading = false
                        }
                }
            }
        }
    }
    func getNavigationTitle() -> Text {
        if selectedOption2 == "AllTypes" && !favouriteActive {
            return Text("I tuoi capi")
        } else if selectedOption2 != "AllTypes" && !favouriteActive {
            return Text(categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA]!)
        } else if selectedOption2 != "AllTypes" && favouriteActive {
            return Text(categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA] == "Camicie" || categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA] == "Canotte" || categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA] == "Giacche" || categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA] == "Felpe" || categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA] == "Scarpe" || categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA] == "T-Shirts" ? "\(categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA]!) preferite": "\(categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA]!) preferiti")
        } else if selectedOption2 == "AllTypes" && favouriteActive{
            return Text("I tuoi capi preferiti")
        } else {
            return Text(categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA]!)
        }
    }
}
