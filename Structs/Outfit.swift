import SwiftUI

class Outfit: Identifiable, Hashable{
    var id = UUID()
    var shirt:Cloth?
    var trousers:Cloth?
    var shoes:Cloth?
    var nome: String?
    var stile: Stile
    var favourite:Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Outfit, rhs: Outfit) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(shirt: Cloth, trousers: Cloth, shoes: Cloth, nome: String, stile: Stile) {
        self.shirt = shirt
        self.trousers = trousers
        self.shoes = shoes
        self.nome = nome
        self.stile = stile
    }
    
    init(shirt: Cloth?, trousers: Cloth?, shoes: Cloth?, nome: String, stile: Stile) {
        self.shirt = shirt
        self.trousers = trousers
        self.shoes = shoes
        self.nome = nome
        self.stile = stile
    }
    
    init(id: UUID, shirt: Cloth, trousers: Cloth, shoes: Cloth, nome: String, stile: Stile, favourite: Bool) {
        self.id = id
        self.shirt = shirt
        self.trousers = trousers
        self.shoes = shoes
        self.nome = nome
        self.stile = stile
        self.favourite = favourite
    }
    
    // QUESTO è INUTILIZZATO
    init(){
        self.shirt = Cloth(image: UIImage())
        self.trousers = Cloth(image: UIImage())
        self.shoes = Cloth(image: UIImage())
        self.nome = ""
        self.stile = .NA
    }
    
    // QUESTO è INUTILIZZATO
    init(cloth:Cloth){
        if cloth.categoria.rawValue == "T-Shirt" {
            self.shirt = cloth
        }
        else if cloth.categoria.rawValue == "Pantalone"{
            self.trousers = cloth
        }
        else if cloth.categoria.rawValue == "Scarpe"{
            self.shoes = cloth
        }
        self.nome = ""
        self.stile = .NA
    }
}
