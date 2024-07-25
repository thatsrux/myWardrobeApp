import SwiftUI
import Firebase

struct OutfitScreen: View {
    
    
    @State private var isAddOutfitScreenActive = false
    @State private var isInfoOutfitScreenActive = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @EnvironmentObject var database:Database
    
    init(){
        
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    Text("Outfits (\(database.outfits.count.description))")
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:25){
                            ForEach(database.outfits, id:\.self){ o in
                                NavigationLink(destination: AddOutfitScreen(outfit: o)) {
                                    HStack{
                                        VStack(spacing:10){
                                            Image(uiImage: o.shirt?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
                                                .resizable()
                                                .scaledToFit()
                                                .clipped()
                                                .frame(width:100,height:100)
                                            Image(uiImage: o.trousers?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
                                                .resizable()
                                                .scaledToFit()
                                                .clipped()
                                                .frame(width:100,height:100)
                                            Image(uiImage: o.shoes?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
                                                .resizable()
                                                .scaledToFit()
                                                .clipped()
                                                .frame(width:100,height:100)
                                        }.frame(width: 150, height: 350)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius:15))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color.black, lineWidth: 3)
                                            )
                                    }
                                }
                                .contextMenu(menuItems: {
                                    Button("Elimina", role: .destructive, action: {
                                        deleteOutfit(outfit: o)
                                    })
                                })
                            }
                        }.padding(.leading,20)
                    }
                }
                .navigationTitle("My Outfits")
                
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            isAddOutfitScreenActive = true
                        }
                    label: {
                        Image(systemName: "plus.circle")
                    }
                        Button {
                            deleteAllOutfits()
                            database.fetchOutfits()
                        }
                    label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    }
                }
                .navigationDestination(isPresented: $isAddOutfitScreenActive){
                    AddOutfitScreen()
                }
            }
        }.onAppear{
            //database.fetchOutfits()
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
