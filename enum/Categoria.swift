enum Categoria: String, Codable, CaseIterable {
    case camicia = "Camicia",
         canotta = "Canotta",
         cappello = "Cappello",
         giacca = "Giacca",
         giubbino = "Giubbino",
         felpa = "Felpa",
         maglione = "Maglione",
         pantaloncini = "Pantaloncino",
         pantalone = "Pantalone",
         scarpe = "Scarpe",
         tshirt = "T-Shirt",
         NA = "N/A"
    
    init(fromRawValue: String){
        self = Categoria(rawValue: fromRawValue) ?? .NA
    }
    
    static func upper() -> [Categoria] {
        return [.camicia, .canotta, .felpa, .giacca, .giubbino, .tshirt]
    }
    
    static func lower() -> [Categoria] {
        return [.pantalone, .pantaloncini]
    }
    
    static func shoes() -> [Categoria] {
        return [.scarpe]
    }
    
}
