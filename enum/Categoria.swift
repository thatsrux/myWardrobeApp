enum Categoria: String, Codable, CaseIterable {
    case camicia, canotta, cappello, giacca, giubbino, felpa, maglione, pantaloncini, pantalone, scarpe, tshirt, NA
    
    init(fromRawValue: String){
        self = Categoria(rawValue: fromRawValue) ?? .NA
    }
}
