//
//  AdvicesScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct AdvicesScreen: View {
    var body: some View {
        NavigationStack {
            VStack{
                Image("icon")
                    .resizable()
                    .frame(width: 80, height: 80)
                
                Text("Cambia il tuo stile!")
                    .fontWeight(.bold)
                    .font(.system(size: 36))
                
                Text("Crea il tuo guardaroba personale.\nTocca il pulsante + per iniziare!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
            } .navigationTitle("Advices")
        }
    }
        
}

#Preview {
    AdvicesScreen()
}
