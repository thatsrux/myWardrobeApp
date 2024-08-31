import Firebase

protocol Deletable {
    
    func deleteCloth(cloth:Cloth)
    
    func deleteOutfit(outfit:Outfit)
}

extension Deletable {
    
    func deleteCloth(cloth:Cloth){
        Firestore.firestore().collection("Clothes").document(cloth.id.uuidString).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
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
    }
    
    
}
