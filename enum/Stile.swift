enum Stile: String, Codable, CaseIterable {
    case casual, formale, sportivo, NA
    
    init(fromRawValue: String){
        self = Stile(rawValue: fromRawValue) ?? .NA
    }
}
