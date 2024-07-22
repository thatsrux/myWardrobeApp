class Outfit{
    var shirt = Cloth(nome: "", categoria: Categoria.NA)
    var trousers = Cloth(nome: "", categoria: Categoria.NA)
    var shoes:Cloth = Cloth(nome: "", categoria: Categoria.NA)
    
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
        self.shirt = Cloth(nome: "", categoria: Categoria.NA)
        self.trousers = Cloth(nome: "", categoria: Categoria.NA)
        self.shoes = Cloth(nome: "", categoria: Categoria.NA)
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
