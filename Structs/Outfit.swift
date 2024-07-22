import SwiftUI

class Outfit{
    var shirt = Cloth(image: UIImage())
    var trousers = Cloth(image: UIImage())
    var shoes:Cloth = Cloth(image: UIImage())
    
    init(shirt: Cloth, trousers: Cloth, shoes: Cloth) {
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
