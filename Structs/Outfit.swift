import SwiftUI

class Outfit: Identifiable, Hashable{
    var id = UUID()
    var shirt:Cloth?
    var trousers:Cloth?
    var shoes:Cloth?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Outfit, rhs: Outfit) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(shirt: Cloth, trousers: Cloth, shoes: Cloth) {
        self.shirt = shirt
        self.trousers = trousers
        self.shoes = shoes
    }
    
    init(id: UUID, shirt: Cloth, trousers: Cloth, shoes: Cloth) {
        self.id = id
        self.shirt = shirt
        self.trousers = trousers
        self.shoes = shoes
    }
    
    init(shirt:Cloth){
        
        self.shirt = shirt
    }
    
    init(trousers:Cloth){
        self.trousers = trousers
    }
    
    init(shoes:Cloth){
        self.shoes = shoes
    }
    
    init(){
        self.shirt = Cloth(image: UIImage())
        self.trousers = Cloth(image: UIImage())
        self.shoes = Cloth(image: UIImage())
    }
    
    init(cloth:Cloth){
        if cloth.categoria.rawValue == "T-Shirt"{
            self.shirt = cloth
        }
        else if cloth.categoria.rawValue == "Pantalone"{
            self.trousers = cloth
        }
        else if cloth.categoria.rawValue == "Scarpe"{
            self.shoes = cloth
        }
    }
}
