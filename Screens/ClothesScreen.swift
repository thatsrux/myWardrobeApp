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
                    if searchIsActive {
                        if !database.clothes.isEmpty{
                            if favouriteActive{
                                List{
                                    ForEach(database.favClothes, id: \.self) { cloth in
                                        if (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") && (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "") {
                                            NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                SingleClothList(cloth: cloth)
                                            }
                                        }
                                    }.onDelete(perform: deleteClothSwipe)
                                }
                            }
                            else if selectedOption2 != "AllTypes" {
                                List{
                                    ForEach(database.clothes, id: \.self) { cloth in
                                        if (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") && (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "") {
                                            NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                SingleClothList(cloth: cloth)
                                            }
                                        }
                                    }.onDelete(perform: deleteClothSwipe)
                                }
                            }
                            else {
                                List {
                                    ForEach(database.clothes) { cloth in
                                        if cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "" {
                                            NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                SingleClothList(cloth: cloth)
                                            }
                                        }
                                    }.onDelete(perform: deleteClothSwipe)
                                }
                            }
                        }
                        else{
                            Text("Inserisci un capo d'abbigliamento")
                        }
                        
                    }
                    
                    else {
                        
                        if !database.clothes.isEmpty{
                            selectedOption2 == "AllTypes" ? Text("Tutti i capi").font(.headline)
                            : Text(selectedOption2).font(.headline)
                            
                            if selectedOption == "elenco" {
                                if favouriteActive{
                                    List{
                                        ForEach(database.favClothes, id: \.self) { cloth in
                                            if selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes"{
                                                NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                    SingleClothList(cloth: cloth)
                                                }
                                            }
                                        }.onDelete(perform: deleteClothSwipe)
                                    }
                                }
                                else if selectedOption2 != "AllTypes" {
                                    List{
                                        ForEach(database.clothes, id: \.self) { cloth in
                                            if selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes"{
                                                NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                    SingleClothList(cloth: cloth)
                                                }
                                            }
                                        }.onDelete(perform: deleteClothSwipe)
                                    }
                                }
                                else {
                                    ClothesList()
                                }
                            } else {
                                if favouriteActive{
                                    if !database.favClothes.isEmpty{
                                        ScrollView{
                                            LazyVGrid(columns: columns, spacing: 10) {
                                                ForEach(database.favClothes, id: \.self) { cloth in
                                                    if selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes" {
                                                        NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                            SingleClothGrid(cloth: cloth)
                                                        }
                                                    }
                                                }
                                            }.padding()
                                        }
                                    }
                                }
                                else if selectedOption2 != "AllTypes" {
                                    ScrollView{
                                        LazyVGrid(columns: columns, spacing: 10) {
                                            ForEach(database.clothes, id: \.self) { cloth in
                                                if selectedOption2 == cloth.categoria.rawValue {
                                                    NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                                        SingleClothGrid(cloth: cloth)
                                                    }
                                                }
                                            }
                                        }.padding()
                                    }
                                }
                                else {
                                    ClothesGrid()
                                }
                            }
                        }
                        else{
                            Text("Inserisci un capo d'abbigliamento")
                        }
                    }
                }
            }
            .navigationTitle(selectedOption2 == "AllTypes" ? Text("I tuoi capi") : Text(categoriePlurale[Categoria(rawValue: selectedOption2) ?? .NA]!))
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
                        
                        Divider()
                        Button(action: {
                            for cloth in database.clothes{
                                Firestore.firestore().collection("Cloth").document(cloth.id.uuidString).delete() { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                    }
                                }
                            }
                            database.fetchClothes()
                            database.fetchCategorie()
                        }) {
                            Text("Svuota")
                            Image(systemName: "trash")
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
}
