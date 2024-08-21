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
            VStack{
                if !database.outfits.isEmpty{
                    ScrollView{
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(database.outfits, id:\.self){ o in
                                if (o.favourite && favouriteActive || !favouriteActive) && // Filtraggio preferiti
                                    (selectedOption == o.stile.rawValue || selectedOption == "AllOutfits") && // Filtraggio stile
                                    (o.nome!.lowercased().contains(searchText.lowercased()) || searchText == "") { // Ricerca
                                    NavigationLink(destination: AddOutfitScreen(outfit: o)) {
                                        SingleOutfitGrid(outfit: o)
                                    }.padding(.leading,10)
                                        .padding(.trailing,10)
                                }
                            }
                        }
                    }
                }
                else {
                    if database.outfitsNum <= 0 {
                        Text("Inserisci un outfit")
                    } else {
                        ProgressView("Aggiornamento guardaroba in corso").frame(maxHeight: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle(getNavigationTitle())
            .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca outfit")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
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
                }
            }
            .navigationDestination(isPresented: $isAddOutfitScreenActive){
                AddOutfitScreen()
            }
        }
    }
    
    func getNavigationTitle() -> Text {
        if selectedOption == "AllOutfits" && !favouriteActive {
            return Text("I tuoi outfit")
        } else if selectedOption != "AllOutfits" && !favouriteActive {
            return Text("Outfit \(stilePlurale[Stile(rawValue: selectedOption) ?? .NA]!)")
        } else if selectedOption != "AllOutfits" && favouriteActive {
            return Text("Outfit \(stilePlurale[Stile(rawValue: selectedOption) ?? .NA]!) preferiti")
        } else if selectedOption == "AllOutfits" && favouriteActive{
            return Text("I tuoi outfit preferiti")
        } else {
            return Text("Outfit \(stilePlurale[Stile(rawValue: selectedOption) ?? .NA]!)")
        }
    }
    
    struct SingleOutfitGrid: View, Deletable, Favourable {
        
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
                        
                        Button{
                            favouriteToggle(outfit: outfit)
                            database.fetchOutfits()
                        }
                    label:{
                        Label(!outfit.favourite ? "Aggiungi ai preferiti" : "Rimuovi dai preferiti",
                              systemImage:!outfit.favourite ? "star" : "star.fill")
                    }
                        Button(role: .destructive){
                            database.outfitsNum -= 1
                            deleteOutfit(outfit: outfit)
                            database.fetchOutfits()
                        }
                    label:{
                        Label("Elimina", systemImage: "trash")
                        
                    }
                    })
                    .shadow(radius: 5)
                    .padding(10)
            }
        }
    }
}
