import SwiftUI
import Firebase

struct OutfitScreen: View {
    
    
    @State private var isAddOutfitScreenActive = false
    @State private var isInfoOutfitScreenActive = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @EnvironmentObject var database:Database
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    if !searchIsActive {
                        Text("Tutti gli outfit (\(database.outfits.count.description))").font(.headline)
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing:25){
                                ForEach(database.outfits, id:\.self){ o in
                                    NavigationLink(destination: AddOutfitScreen(outfit: o)) {
                                        SingleOutfitGrid(outfit: o)
                                    }
                                }
                            }.padding(.leading,20)
                        }
                    }
                    else {
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing:25){
                                ForEach(database.outfits, id:\.self){ o in
                                    if o.nome!.contains(searchText) {
                                        NavigationLink(destination: AddOutfitScreen(outfit: o)) {
                                            SingleOutfitGrid(outfit: o)
                                        }
                                    }
                                }
                            }.padding(.leading,20)
                        }
                    }
                }
                .navigationTitle("I tuoi outfit")
                .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca outfit")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            isAddOutfitScreenActive = true
                        }
                    label: {
                        Image(systemName: "plus.circle")
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
                Image(uiImage: outfit.shirt?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width:100,height:100)
                Image(uiImage: outfit.trousers?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width:100,height:100)
                Image(uiImage: outfit.shoes?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
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
                    Button("Elimina", role: .destructive, action: {
                        deleteOutfit(outfit: outfit)
                    })
                })
                .shadow(radius: 5)
                .padding(10)
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
