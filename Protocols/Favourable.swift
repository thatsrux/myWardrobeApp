import Firebase

protocol Favourable {
    
    func favouriteToggle(outfit: Outfit)
    
    func favouriteToggle(cloth: Cloth)
}

extension Favourable {
    func favouriteToggle(outfit: Outfit){
        outfit.favourite.toggle()
        
        let db = Firestore.firestore()
        let ref = db.collection("Outfit").document(outfit.id.uuidString)
        ref.updateData([
            "favourite": outfit.favourite
        ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func favouriteToggle(cloth: Cloth){
        
        cloth.favourite.toggle()
        
        let db = Firestore.firestore()
        let ref = db.collection("Clothes").document(cloth.id.uuidString)
        ref.updateData([
            "favourite": cloth.favourite
        ]){
            error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
