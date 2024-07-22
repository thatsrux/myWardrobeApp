enum Stile: String, Codable, CaseIterable {
    case casual = "Casual",
         formale = "Formale",
         sportivo = "Sportivo",
         NA = "N/A"
         
    init(fromRawValue: String){
        self = Stile(rawValue: fromRawValue) ?? .NA
    }
}
