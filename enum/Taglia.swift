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
         NA = "Non specificata"
    
    init(fromRawValue: String){
        self = Taglia(rawValue: fromRawValue) ?? .NA
    }
}

let tagliaUpper = [Taglia.tgXS, Taglia.tgS, Taglia.tgM, Taglia.tgL, Taglia.tgXL, Taglia.tgXXL, Taglia.NA]
let tagliaLower = [Taglia.tg42, Taglia.tg44, Taglia.tg46, Taglia.tg48, Taglia.tg50, Taglia.tg52, Taglia.tg54, Taglia.NA]
let tagliaShoes = [Taglia.tg38, Taglia.tg39, Taglia.tg40, Taglia.tg41, Taglia.tg42, Taglia.tg43, Taglia.tg44, Taglia.tg45, Taglia.NA]
