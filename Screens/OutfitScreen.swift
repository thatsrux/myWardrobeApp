import SwiftUI
import Firebase

struct OutfitScreen: View {
    @State private var selectedOption = "AllOutfits"
    
    @State private var isAddOutfitScreenActive = false
    @State private var isInfoOutfitScreenActive = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var favouriteActive = false
    
    @EnvironmentObject var database:Database
    
    
    let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    if !searchIsActive {
                        if favouriteActive {
                            if !database.favOutfits.isEmpty{
                                selectedOption == "AllOutfits" ? Text("Tutti gli outfit").font(.headline)
                                : Text("Outfit \(selectedOption)").font(.headline)
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(database.favOutfits, id:\.self){ o in
                                        if selectedOption == o.stile.rawValue || selectedOption == "AllOutfits" {
                                            NavigationLink(destination: AddOutfitScreen(outfit: o)) {
                                                SingleOutfitGrid(outfit: o)
                                            }.padding(.leading,10)
                                                .padding(.trailing,10)
                                        }
                                    }
                                }
                            }
                        } else {
                            if !database.outfits.isEmpty {
                                selectedOption == "AllOutfits" ? Text("Tutti gli outfit").font(.headline)
                                : Text("Outfit \(selectedOption)").font(.headline)
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(database.outfits, id:\.self){ o in
                                        if selectedOption == o.stile.rawValue || selectedOption == "AllOutfits" {
                                            NavigationLink(destination: AddOutfitScreen(outfit: o)) {
                                                SingleOutfitGrid(outfit: o)
                                            }.padding(.leading,10)
                                                .padding(.trailing,10)
                                        }
                                    }
                                }
                                
                            }
                            else {
                                Text("inserisci outfit")
                            }
                        }
                        
                    }
                    else {
                        if !database.outfits.isEmpty{
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(database.outfits, id:\.self){ o in
                                    if o.nome!.lowercased().contains(searchText.lowercased()) {
                                        NavigationLink(destination: AddOutfitScreen(outfit: o)) {
                                            SingleOutfitGrid(outfit: o)
                                        }
                                    }
                                }.padding(.leading,10)
                                    .padding(.trailing,10)
                            }
                        }
                    }
                }
                .navigationTitle("I tuoi outfit")
                .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca outfit")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Menu() {
                            Picker(selection: $selectedOption, label: Text("Options")) {
                                Text("Tutti gli outfit").tag("AllOutfits")
                                ForEach(Stile.allCases, id: \.self) { style in
                                    if style != .NA {
                                        Text(style.rawValue).tag(style.rawValue)
                                    }
                                }
                            }
                        } label:{
                            Text("Stile")
                        }
                        Button {
                            isAddOutfitScreenActive = true
                        } label: {
                            Image(systemName: "plus.circle")
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
                    }
                }
                .navigationDestination(isPresented: $isAddOutfitScreenActive){
                    AddOutfitScreen()
                }
            }
        }
    }
    
    
    func deleteAllOutfits() {
        let db = Firestore.firestore()
        let ref = db.collection("Outfit")
        
        ref.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No documents found")
                return
            }
            
            let group = DispatchGroup()
            
            for document in snapshot.documents {
                group.enter()
                document.reference.delete { error in
                    if let error = error {
                        print("Error removing document \(document.documentID): \(error.localizedDescription)")
                    } else {
                        print("Document \(document.documentID) successfully removed!")
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                print("All documents have been processed.")
                database.fetchOutfits()
            }
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
                    .contextMenu(menuItems: {
                        Button(role: .destructive){
                            deleteOutfit(outfit: outfit)
                        }
                    label:{
                        Label("Elimina", systemImage: "trash")
                        
                    }
                        Button{
                            favouriteToggle(outfit: outfit)
                        }
                    label:{
                        Label(!database.favOutfits.contains(outfit) ? "Aggiungi ai preferiti" : "Rimuovi dai preferiti", systemImage:!database.favOutfits.contains(outfit) ? "star" : "star.fill")
                    }
                    })
                    .shadow(radius: 5)
                    .padding(10)
            }
        }
        
        func favouriteToggle(outfit: Outfit) {
            
            if database.favOutfits.contains(outfit){
                outfit.favourite = false
            }
            else{
                outfit.favourite = true
            }
            
            let db = Firestore.firestore()
            let ref = db.collection("Outfit").document(outfit.id.uuidString)
            
            ref.updateData([
                "favourite": outfit.favourite
            ]) { error in
                if let error = error {
                    print("Errore nell'aggiornamento del database: \(error.localizedDescription)")
                } else {
                    print("Aggiornamento del database riuscito")
                    // Aggiorna l'interfaccia utente dopo l'aggiornamento del database
                    DispatchQueue.main.async {
                        database.fetchOutfits()
                        database.fetchCategorieOutfit()
                    }
                }
            }
        }
        
        
        
        func deleteOutfit(outfit: Outfit){
            Firestore.firestore().collection("Outfit").document(outfit.id.uuidString).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document \(outfit.id) successfully removed!")
                }
            }
            database.fetchOutfits()
        }
    }
}
