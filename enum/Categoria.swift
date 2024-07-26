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
         NA = "Altro"
    
    init(fromRawValue: String){
        self = Categoria(rawValue: fromRawValue) ?? .NA
    }
    
}

let categoriePlurale: [Categoria: String] = [
    .camicia: "Camicie",
    .canotta: "Canotte",
    .cappello: "Cappelli",
    .giacca: "Giacche",
    .giubbino: "Giubbini",
    .felpa: "Felpe",
    .maglione: "Maglioni",
    .pantaloncini: "Pantaloncini",
    .pantalone: "Pantaloni",
    .scarpe: "Scarpe",
    .tshirt: "T-Shirts",
    .NA: "Altro"
]

let upperCat = [Categoria.camicia, Categoria.canotta, Categoria.felpa, Categoria.giacca, Categoria.giubbino, Categoria.tshirt]
let lowerCat = [Categoria.pantalone, Categoria.pantaloncini]
let shoesCat = [Categoria.scarpe]
