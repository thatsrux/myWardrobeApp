//
//  Vestito.swift
//  myWardrobe
//
//  Created by Studente on 09/07/24.
//

import Foundation

struct Vestito: Identifiable, Codable {
    var id = UUID()
    var nome: String?
    var nomeImmagine: String
    var tipoVestito: String
//    var stile: String
//    var colore1: Color
//    var colore2: Color?
//    var colore3: Color?
}


struct Outfit{
    let shirt:Vestito
    let trousers:Vestito
    let shoes:Vestito
}
