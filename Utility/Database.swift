import Firebase
import FirebaseFirestore


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
        fetchOutfits()
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
                    
                    
                    let outfit = Outfit(cloth: cloth)
                    
                    
                    self.outfits.append(outfit)
                    
                    
                }
            }
        }
    }
    
    func removeOutfits(){
        outfits.removeAll()
    }
    
    
}


