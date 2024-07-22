//
//  ContentView.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @State var clothes : [Cloth] = ([])
    @State var selection = 0
    let db = Firestore.firestore()
    
    var body: some View {
            TabView(selection: $selection) {
                OutfitScreen(outfits: [Outfit(shirt: Cloth(nome: "gucci", categoria: Categoria(rawValue: "maglia") ?? Categoria.NA), trousers: Cloth(nome: "cargo", categoria: Categoria(rawValue: "pantaloni") ?? Categoria.NA), shoes: Cloth(nome: "balenciaga", categoria: Categoria(rawValue: "scarpe") ?? Categoria.NA))])
                    .tabItem {
                        Label ("Galleria Outfit", systemImage: "tshirt")
                        .accentColor(.primary)}
                    .tag (0)
                
                ClothesScreen(clothes: $clothes)
                    .tabItem {
                        Label ("Guardaroba", systemImage: "hanger")
                        .accentColor(.primary)}
                    .tag (2)
                AdvicesScreen()
                    .tabItem{
                        Label("Consigli", systemImage: "globe.europe.africa.fill")
                            .accentColor(.primary)
                    }.tag(1)
            }.onAppear(){
                if let data = UserDefaults.standard.object(forKey: "CLOTHES"){
                    do {
                        let decoder = JSONDecoder()
                        let clo = try decoder.decode([Cloth].self, from: data as! Data)
                        clothes = clo
                    } catch {
                        print("Impossibile effettuare la decodifica \(error)")
                    }
                }
            }
        }
}

extension UIImage{
    func toPngString() -> String?{
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * percentage, height: size.height * percentage)

        return self.preparingThumbnail(of: newSize)
        }
    
    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data? {
            let bytes = kb * 1024
            let threshold = Int(CGFloat(bytes) * (1 + allowedMargin))
            var compression: CGFloat = 1.0
            let step: CGFloat = 0.05
            var holderImage = self
            while let data = holderImage.pngData() {
                let ratio = data.count / bytes
                if data.count < threshold {
                    return data
                } else {
                    let multiplier = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)

                    guard let newImage = self.resized(withPercentage: compression) else { break }
                    holderImage = newImage
                }
            }

            return nil
        }
}

extension String{
    func toImage() -> UIImage?{
        if let data = Data(base64Encoded: self,options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
            return nil
    }
    
    func CGFloatValue() -> CGFloat? {
        guard let doubleValue = Double(self) else {
          return nil
        }

        return CGFloat(doubleValue)
      }
}


#Preview {
    ContentView()
}
