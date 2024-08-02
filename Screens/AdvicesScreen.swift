import SwiftUI

struct AdvicesScreen: View {
        
    @EnvironmentObject var database: Database
    
    @State private var dailyOutfitIndex: Int?
    @State private var isColorMatchScreenActive = false
    @State private var isColorSeasonScreenActive = false
    @State private var isMagicOutfitScreenActive = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Outfit del giorno").font(.headline)
                    
                    if let index = dailyOutfitIndex, !database.outfits.isEmpty {
                        NavigationLink(destination: AddOutfitScreen(outfit: database.outfits[index])) {
                            SingleOutfitGrid(outfit: database.outfits[index])
                        }
                    } else {
                        Text("No outfit available").font(.subheadline).foregroundColor(.gray)
                    }
                }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    Button(action: {
                        isColorMatchScreenActive.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple]), startPoint: .leading, endPoint: .trailing))
                            .frame(height: 100)
                            .overlay(
                                Text("Color Match")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                    }
                    .sheet(isPresented: $isColorMatchScreenActive) {
                        ColorMatch()
                    }
                    
                    Button(action: {
                        isColorSeasonScreenActive.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.teal))
                            .frame(height: 100)
                            .overlay(
                                Text("Color Season")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                    }.sheet(isPresented: $isColorSeasonScreenActive) {
                        ColorSeason()
                    }
                    
                    Button(action: {
                        isMagicOutfitScreenActive.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.teal))
                            .frame(height: 100)
                            .overlay(
                                Text("Magic Outfit")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                    }.sheet(isPresented: $isMagicOutfitScreenActive) {
                        MagicOutfit()
                    }
                    
                    Button(action: {
                        isColorSeasonScreenActive.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.teal))
                            .frame(height: 100)
                            .overlay(
                                Text("Color Season")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                    }.sheet(isPresented: $isColorSeasonScreenActive) {
                        ColorSeason()
                    }
                }
                .padding()
                
                .navigationTitle("Consigli per te")
                .onAppear {
                    updateDailyOutfitIndexIfNeeded()
                }
            }

        }
    }
    
    private func updateDailyOutfitIndexIfNeeded() {
        let today = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let todayString = dateFormatter.string(from: today)
        
        if let lastUpdateString = UserDefaults.standard.string(forKey: "lastUpdateDate"),
           let lastUpdateDate = dateFormatter.date(from: lastUpdateString),
           calendar.isDate(today, inSameDayAs: lastUpdateDate) {
            // Same day, retrieve the stored outfit index
            dailyOutfitIndex = UserDefaults.standard.integer(forKey: "dailyOutfitIndex")
            //print("Retrieved dailyOutfitIndex: \(String(describing: dailyOutfitIndex))")
        } else {
            // New day, update the outfit index
            if !database.outfits.isEmpty {
                dailyOutfitIndex = Int.random(in: 0..<database.outfits.count)
                UserDefaults.standard.set(todayString, forKey: "lastUpdateDate")
                if let index = dailyOutfitIndex {
                    UserDefaults.standard.set(index, forKey: "dailyOutfitIndex")
                }
                //print("Generated new dailyOutfitIndex: \(String(describing: dailyOutfitIndex))")
            }
        }
    }
    
    struct SingleOutfitGrid: View {
        
        private var outfit: Outfit
        
        init(outfit: Outfit) {
            self.outfit = outfit
        }
        
        var body: some View {
            HStack {
                VStack(spacing: 10) {
                    Image(uiImage: outfit.shirt?.image?.toImage() ?? UIImage(imageLiteralResourceName: "shirt"))
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: 100, height: 100)
                    Image(uiImage: outfit.trousers?.image?.toImage() ?? UIImage(imageLiteralResourceName: "trousers"))
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: 100, height: 100)
                    Image(uiImage: outfit.shoes?.image?.toImage() ?? UIImage(imageLiteralResourceName: "shoes"))
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: 100, height: 100)
                    Text(outfit.nome!)
                        .foregroundStyle(.black)
                }
                .frame(width: 150, height: 370)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(10)
            }
        }
    }
}





#Preview {
    AdvicesScreen().environmentObject(Database())
}
