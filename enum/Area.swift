enum Area: CaseIterable {
    static var allCases: [Area] {
        return [.lower(items: []), .shoes(items: []), .upper(items: [])]
    }
    
    case upper(items: [String])
    case lower(items: [String])
    case shoes(items: [String])
    
    var items: [String] {
        switch self {
        case .upper:
            return ["Camicia", "Canotta", "Giacca", "Giubbino", "Felpa", "Maglione", "T-Shirt"]
        case .lower:
            return ["Pantaloni", "Pantaloncini"]
        case .shoes:
            return ["Scarpe"]
        }
    }
}
