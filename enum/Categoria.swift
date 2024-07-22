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
         NA = "NA"
    
    init(fromRawValue: String){
        self = Categoria(rawValue: fromRawValue) ?? .NA
    }
}
