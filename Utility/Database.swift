import Firebase

class Database:ObservableObject{
    
    @Published var clothes:[Cloth]
    @Published var categorie:[String]
    @Published var outfits:[Outfit]
    @Published var categorieOutfit:[String]
    
    @Published var clothesNum = 0
    @Published var outfitsNum = 0
    
    var firstClothCheck = true
    var firstOutfitCheck = true
    
    init(){
        self.clothes = []
        self.categorie = []
        self.outfits = []
        self.categorieOutfit = []
        
        fetchClothes()
        fetchCategorie()
        fetchOutfits()
        fetchCategorieOutfit()
    }
    
    func fetchClothes(){
        clothes.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Clothes")
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    
                    let image = data["foto"] as? String ?? ""
                    let nome = data["nome"] as? String ?? ""
                    let categoria = data["categoria"] as? String ?? ""
                    let taglia = data["taglia"] as? String ?? ""
                    
                    let firstColor = data["color1"] as? String ?? ""
                    let secondColor = data["color2"] as? String ?? ""
                    let thirdColor = data["color3"] as? String ?? ""
                    
                    let colorsNum = data["colorsnum"] as? Int ?? 3
                    
                    let stile = data["stile"] as? String ?? ""
                    let dataAgg = data["data"] as? String ?? ""
                    
                    let favourite = data["favourite"] as? Bool ?? false
                    
                    let cloth = Cloth(id: UUID(uuidString: id)!, image: image,
                                      mainColor: ColorData(hex:firstColor),
                                      secondColor:ColorData(hex:secondColor),
                                      thirdColor: ColorData(hex:thirdColor),
                                      colorsNum: colorsNum, categoria: Categoria(rawValue: categoria) ?? Categoria.NA, nome: nome, taglia: Taglia(rawValue: taglia) ?? Taglia.NA,stile: Stile(rawValue: stile) ?? Stile.NA, data: dataAgg.data(using: .utf8)!, favourite: favourite)
                    
                    self.clothes.append(cloth)
                    if self.firstClothCheck {
                        self.clothesNum += 1
                        self.firstClothCheck = false
                    }
                }
            }
            self.clothes.sort(by:{$0.data>$1.data})
        }
    }
    
    
    func fetchCategorie(){
        categorie.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Clothes")
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let categoria = data["categoria"] as? String ?? ""
                    
                    if !self.categorie.contains(categoria)  {
                        self.categorie.append(categoria)
                    }
                }
            }
        }
        
    }
    
    func fetchOutfits(){
        outfits.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Outfit")
        ref.getDocuments{ [self] snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                let group = DispatchGroup()
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let shirtId = data["shirtId"] as? String ?? "Non specificato"
                    let trousersId = data["trousersId"] as? String ?? "Non specificato"
                    let shoesId = data["shoesId"] as? String ?? "Non specificato"
                    let nome = data["nome"] as? String ?? ""
                    let stile = data["stile"] as? String ?? ""
                    let favourite = data["favourite"] as? Bool ?? false
                    
                    var shirt: Cloth?
                    var trousers: Cloth?
                    var shoes: Cloth?
                    
                    group.enter()
                    getClothById(shirtId){ s in
                        shirt = s
                        group.leave()
                    }
                    
                    group.enter()
                    getClothById(trousersId){ t in
                        trousers = t
                        group.leave()
                    }
                    
                    group.enter()
                    getClothById(shoesId){ sh  in
                        shoes = sh
                        group.leave()
                    }
                    
                    group.notify(queue: .main) {
                        let outfit = Outfit(id: UUID(uuidString: id)!, shirt: shirt ?? Cloth(image: UIImage(imageLiteralResourceName: "shirt")), trousers: trousers ?? Cloth(image: UIImage(imageLiteralResourceName: "trousers")), shoes: shoes ?? Cloth(image: UIImage(imageLiteralResourceName: "shoes")), nome: nome, stile: Stile(rawValue: stile) ?? .NA, favourite: favourite)
                        
                        self.outfits.append(outfit)
                        
                        if self.firstOutfitCheck {
                            self.outfitsNum += 1
                            self.firstOutfitCheck = false
                        }
                    }
                }
            }
        }
    }
    
    
    func fetchCategorieOutfit(){
        categorieOutfit.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Outfit")
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let categoria = data["stile"] as? String ?? ""
                    
                    if !self.categorieOutfit.contains(categoria)  {
                        self.categorieOutfit.append(categoria)
                    }
                }
            }
        }
    }
    
    func deleteCloth(cloth:Cloth){
        clothesNum -= 1
        Firestore.firestore().collection("Clothes").document(cloth.id.uuidString).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        for outfit in outfits {
            if outfit.shirt!.id == cloth.id || outfit.trousers!.id == cloth.id || outfit.shoes!.id == cloth.id {
                Firestore.firestore().collection("Outfit").document(outfit.id.uuidString).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document \(outfit.id) successfully removed!")
                    }
                }
            }
        }
        fetchClothes()
        fetchOutfits()
        fetchCategorie()
        fetchCategorieOutfit()
    }
    
    func removeOutfits(){
        outfits.removeAll()
    }
    
    func getClothById(_ idCloth: String, completion: @escaping (Cloth?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Clothes").document(idCloth)
        
        ref.getDocument { document, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                guard let data = document.data() else {
                    print("document is nil")
                    completion(nil)
                    return
                }
                
                let id = data["id"] as? String ?? ""
                let image = data["foto"] as? String ?? ""
                let nome = data["nome"] as? String ?? ""
                let categoria = data["categoria"] as? String ?? ""
                let taglia = data["taglia"] as? String ?? ""
                
                let firstColor = data["color1"] as? String ?? ""
                let secondColor = data["color2"] as? String ?? ""
                let thirdColor = data["color3"] as? String ?? ""

                
                let colorsNum = data["colorsnum"] as? Int ?? 3
                
                let stile = data["stile"] as? String ?? ""
                let dataAgg = data["data"] as? String ?? ""
                
                let favourite = data["favourite"] as? Bool ?? false
                
                let cloth = Cloth(
                    id: UUID(uuidString: id) ?? UUID(),
                    image: image,
                    mainColor: ColorData(hex:firstColor),
                    secondColor: ColorData(hex: secondColor),
                    thirdColor: ColorData(hex:thirdColor),
                    colorsNum: colorsNum,
                    categoria: Categoria(rawValue: categoria) ?? Categoria.NA,
                    nome: nome,
                    taglia: Taglia(rawValue: taglia) ?? Taglia.NA,
                    stile: Stile(rawValue: stile) ?? Stile.NA,
                    data: dataAgg.data(using: .utf8)!,
                    favourite: favourite
                )
                
                completion(cloth)
            } else {
                completion(nil) // Indica che il documento non esiste
            }
        }
    }
    
    
}


