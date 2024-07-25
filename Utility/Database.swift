import Firebase

class Database:ObservableObject{
    
    @Published var clothes:[Cloth]
    @Published var categorie:[String:[Cloth]]
    @Published var outfits:[Outfit]
    init(){
        self.clothes = []
        self.categorie = [:]
        self.outfits = []
        fetchClothes()
        fetchCategorie()
    }
    
    func fetchClothes(){
        clothes.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Cloth")
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
                    
                    let color1a = data["color1a"] as? String ?? ""
                    let color1r = data["color1r"] as? String ?? ""
                    let color1g = data["color1g"] as? String ?? ""
                    let color1b = data["color1b"] as? String ?? ""
                    
                    let color2a = data["color2a"] as? String ?? ""
                    let color2r = data["color2r"] as? String ?? ""
                    let color2g = data["color2g"] as? String ?? ""
                    let color2b = data["color2b"] as? String ?? ""
                    
                    let color3a = data["color3a"] as? String ?? ""
                    let color3r = data["color3r"] as? String ?? ""
                    let color3g = data["color3g"] as? String ?? ""
                    let color3b = data["color3b"] as? String ?? ""
                    
                    let colorsNum = data["colorsnum"] as? Int ?? 3
                    
                    let stile = data["stile"] as? String ?? ""
                    let dataAgg = data["data"] as? String ?? ""
                    
                    let cloth = Cloth(id: UUID(uuidString: id)!, image: image, mainColor: ColorData(red: color1r.CGFloatValue()! , green: color1g.CGFloatValue()!, blue: color1b.CGFloatValue()!, alpha: color1a.CGFloatValue()!), secondColor: ColorData(red: color2r.CGFloatValue()!, green: color2g.CGFloatValue()!, blue: color2b.CGFloatValue()!, alpha: color2a.CGFloatValue()!), thirdColor: ColorData(red: color3r.CGFloatValue()!, green: color3g.CGFloatValue()!, blue: color3b.CGFloatValue()!, alpha: color3a.CGFloatValue()!), colorsNum: colorsNum, categoria: Categoria(rawValue: categoria) ?? Categoria.NA, nome: nome, taglia: Taglia(rawValue: taglia) ?? Taglia.NA,stile: Stile(rawValue: stile) ?? Stile.NA, data: dataAgg.data(using: .utf8)!)
                    
                    self.clothes.append(cloth)
                    self.clothes.sort(by:{$0.data>$1.data})
                }
            }
        }
    }
    
    func fetchCategorie(){
        categorie.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Cloth")
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
                    
                    let color1a = data["color1a"] as? String ?? ""
                    let color1r = data["color1r"] as? String ?? ""
                    let color1g = data["color1g"] as? String ?? ""
                    let color1b = data["color1b"] as? String ?? ""
                    
                    let color2a = data["color2a"] as? String ?? ""
                    let color2r = data["color2r"] as? String ?? ""
                    let color2g = data["color2g"] as? String ?? ""
                    let color2b = data["color2b"] as? String ?? ""
                    
                    let color3a = data["color3a"] as? String ?? ""
                    let color3r = data["color3r"] as? String ?? ""
                    let color3g = data["color3g"] as? String ?? ""
                    let color3b = data["color3b"] as? String ?? ""
                    
                    let colorsNum = data["colorsnum"] as? Int ?? 3
                    
                    let stile = data["stile"] as? String ?? ""
                    let dataAgg = data["data"] as? String ?? ""
                    
                    let cloth = Cloth(id: UUID(uuidString: id)!, image: image, mainColor: ColorData(red: color1r.CGFloatValue()! , green: color1g.CGFloatValue()!, blue: color1b.CGFloatValue()!, alpha: color1a.CGFloatValue()!), secondColor: ColorData(red: color2r.CGFloatValue()!, green: color2g.CGFloatValue()!, blue: color2b.CGFloatValue()!, alpha: color2a.CGFloatValue()!), thirdColor: ColorData(red: color3r.CGFloatValue()!, green: color3g.CGFloatValue()!, blue: color3b.CGFloatValue()!, alpha: color3a.CGFloatValue()!), colorsNum: colorsNum, categoria: Categoria(rawValue: categoria) ?? Categoria.NA, nome: nome, taglia: Taglia(rawValue: taglia) ?? Taglia.NA, stile: Stile(rawValue: stile) ?? Stile.NA, data: dataAgg.data(using: .utf8)!)
                    
                    
                    if self.categorie[cloth.categoria.rawValue] == nil {
                        self.categorie[cloth.categoria.rawValue] = [cloth]
                    } else {
                        self.categorie[cloth.categoria.rawValue]?.append(cloth)
                    }
                    
                    self.categorie = self.categorie.mapValues { $0.sorted { $0.nome < $1.nome } }
                        
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
                    let shirtId = data["shirtId"] as? String ?? ""
                    let trousersId = data["trousersId"] as? String ?? ""
                    let shoesId = data["shoesId"] as? String ?? ""
                    
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
                        if let shirt = shirt, let trousers = trousers, let shoes = shoes {
                            let outfit = Outfit(id: UUID(uuidString: id)!, shirt: shirt, trousers: trousers, shoes: shoes)
                            self.outfits.append(outfit)
                        } else {
                            print("One or more items could not be fetched")
                        }
                        
                    }
                }
            }
        }
    }
    
    func removeOutfits(){
        outfits.removeAll()
    }
    
    func getClothById(_ idCloth: String, completion: @escaping (Cloth?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Cloth").document(idCloth)
        
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
                
                let color1a = data["color1a"] as? String ?? ""
                let color1r = data["color1r"] as? String ?? ""
                let color1g = data["color1g"] as? String ?? ""
                let color1b = data["color1b"] as? String ?? ""
                
                let color2a = data["color2a"] as? String ?? ""
                let color2r = data["color2r"] as? String ?? ""
                let color2g = data["color2g"] as? String ?? ""
                let color2b = data["color2b"] as? String ?? ""
                
                let color3a = data["color3a"] as? String ?? ""
                let color3r = data["color3r"] as? String ?? ""
                let color3g = data["color3g"] as? String ?? ""
                let color3b = data["color3b"] as? String ?? ""
                
                let colorsNum = data["colorsnum"] as? Int ?? 3
                
                let stile = data["stile"] as? String ?? ""
                let dataAgg = data["data"] as? String ?? ""
                
                let cloth = Cloth(
                    id: UUID(uuidString: id) ?? UUID(),
                    image: image,
                    mainColor: ColorData(
                        red: CGFloat(color1r.CGFloatValue() ?? 0),
                        green: CGFloat(color1g.CGFloatValue() ?? 0),
                        blue: CGFloat(color1b.CGFloatValue() ?? 0),
                        alpha: CGFloat(color1a.CGFloatValue() ?? 0)
                    ),
                    secondColor: ColorData(
                        red: CGFloat(color2r.CGFloatValue() ?? 0),
                        green: CGFloat(color2g.CGFloatValue() ?? 0),
                        blue: CGFloat(color2b.CGFloatValue() ?? 0),
                        alpha: CGFloat(color2a.CGFloatValue() ?? 0)
                    ),
                    thirdColor: ColorData(
                        red: CGFloat(color3r.CGFloatValue() ?? 0),
                        green: CGFloat(color3g.CGFloatValue() ?? 0),
                        blue: CGFloat(color3b.CGFloatValue() ?? 0),
                        alpha: CGFloat(color3a.CGFloatValue() ?? 0)
                    ),
                    colorsNum: colorsNum,
                    categoria: Categoria(rawValue: categoria) ?? Categoria.NA,
                    nome: nome,
                    taglia: Taglia(rawValue: taglia) ?? Taglia.NA,
                    stile: Stile(rawValue: stile) ?? Stile.NA,
                    data: dataAgg.data(using: .utf8)!
                )
                
                completion(cloth)
            } else {
                completion(nil) // Indica che il documento non esiste
            }
        }
    }


}


