enum Taglia: String, Codable, CaseIterable {
    case tgXS = "XS",
         tgS = "S",
         tgM = "M",
         tgL = "L",
         tgXL = "XL",
         tgXXL = "XXL",
         tg42 = "42",
         tg44 = "44",
         tg46 = "46",
         tg48 = "48",
         tg50 = "50",
         tg52 = "52",
         tg54 = "54",
         tg38 = "38",
         tg39 = "39",
         tg40 = "40",
         tg41 = "41",
         tg43 = "43",
         tg45 = "45",
         NA = "N/A"
    
    init(fromRawValue: String){
        self = Taglia(rawValue: fromRawValue) ?? .NA
    }
}
