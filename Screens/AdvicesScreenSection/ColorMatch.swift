import SwiftUI

struct ColorMatch: View{
    
    var body: some View{
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Text("Abbinamenti consentiti:")
                            .font(.title2)
                            .fontWeight(.bold)
                        colorPairsView(colorPairs: coloriConsentiti)
                    }
                    .padding()

                    VStack(spacing: 20) {
                        Text("Abbinamenti sconsigliati:")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("I seguenti colori sono facilmente abbinabili, per cui sono riportati solo gli abbinamenti da evitare assolutamente")
                            .multilineTextAlignment(.center)
                        colorPairsView(colorPairs: coloriVietati)
                    }
                    .padding()
                }
                .navigationTitle("Abbinamento colori")
            }
        }
    }
    
    func colorPairsView(colorPairs: [Colore: [Colore]]) -> some View {
        ForEach(colorPairs.keys.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { baseColor in
            VStack(alignment: .center, spacing: 5) {
                HStack(spacing: 15) {
                    VStack {
                        Color(colorMap[baseColor.rawValue]!)
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            .border(Color.black, width: 2)
                        Text(baseColor.rawValue.capitalized)
                            .font(.headline)
                            //.foregroundColor(Color(colorMap[baseColor.rawValue]!))
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(colorPairs[baseColor]!, id: \.self) { color in
                            VStack {
                                Color(colorMap[color.rawValue]!)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                    .border(Color.black, width: 2)
                                Text(color.rawValue.capitalized)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }

}
