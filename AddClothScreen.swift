//
//  AddClothScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct AddClothScreen: View {
    var image: Image?
    
    init(image: Image?){
        self.image = image
    }
    
    var body: some View {
    
        if image != nil {
            image!
                .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 300, height: 400)
        }
        
        
        
    }
                
}

#Preview {
    AddClothScreen(image: Image("icon"))
}
