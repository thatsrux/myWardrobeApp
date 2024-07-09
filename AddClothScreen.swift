//
//  AddClothScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct AddClothScreen: View {
    var image: Image?
    @State var s: String
    
    init(image: Image?, string: String){
        self.image = image
        self.s = string
    }
    
    var body: some View {
        HStack{
            if image != nil {
                image!
                    .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(width: 150, height: 200)
            }
            
            
        }
        LabeledContent {
          TextField("", text: $s)
        } label: {
          Text("Categoria: ")
        }
        LabeledContent {
          TextField("", text: $s)
        } label: {
          Text("Nome articolo: ")
        }
        LabeledContent {
          TextField("", text: $s)
        } label: {
          Text("Taglia: ")
        }
        LabeledContent {
          TextField("", text: $s)
        } label: {
          Text("Colore primario: ")
        }
        Spacer()
        
        
    }
                
}

#Preview {
    AddClothScreen(image: Image("icon"), string: "")
}
