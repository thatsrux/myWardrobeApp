//
//  InfoOutfitScreen.swift
//  myWardrobe
//
//  Created by Studente on 09/07/24.
//

import SwiftUI

struct InfoOutfitScreen: View {
    @State var stato:String
    
    init(stato: String){
        self.stato = stato
    }
    var body: some View {
        Text("InfoOutfitScreen \($stato)")
    }
}

#Preview {
    InfoOutfitScreen(stato: "prova")
}
