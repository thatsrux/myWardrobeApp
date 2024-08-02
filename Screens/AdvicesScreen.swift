import SwiftUI

struct AdvicesScreen: View {
        
    @EnvironmentObject var database: Database
    
    @State private var dailyOutfitIndex: Int?
    @State private var isColorMatchScreenActive = false
    @State private var isColorSeasonScreenActive = false
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

struct ColorMatch: View{
    
    var body: some View{
        NavigationView {
            ScrollView{
                VStack(spacing:20){
                    Text("Abbinamenti consentiti:")
                    HStack(spacing: 40){
                        Text("Rosso")
                        Circle().fill(.red).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Circle().fill(.blue).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Text("Blu")
                    }
                    HStack(spacing: 40){
                        Text("Giallo")
                        Circle().fill(.yellow).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Circle().fill(.green).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Text("Verde")
                    }
                    HStack(spacing: 40){
                        Text("Nero")
                        Circle().fill(.black).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Circle().fill(.gray).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Text("Grigio")
                    }
                }
                VStack(spacing:20){
                    Text("Abbinamenti sconsigliati:")
                    HStack(spacing: 40){
                        Text("Rosso")
                        Circle().fill(.red).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Circle().fill(.blue).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Text("Blu")
                    }
                    HStack(spacing: 40){
                        Text("Giallo")
                        Circle().fill(.yellow).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Circle().fill(.green).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Text("Verde")
                    }
                    HStack(spacing: 40){
                        Text("Nero")
                        Circle().fill(.black).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Circle().fill(.gray).frame(width: 60, height: 60).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                        Text("Grigio")
                    }
                }
                
                .navigationTitle("Abbinamento colori")
            }}
    }
}

struct ColorSeason: View {
    
    @State private var showSpringColors = false
    @State private var showSummerColors = false
    @State private var showAutumnColors = false
    @State private var showWinterColors = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    SeasonSection(title: "Primavera", colors: [Color.green, Color.pink, Color.yellow], allColors: [Color.green, Color.pink, Color.yellow, Color.blue, Color.purple], isExpanded: $showSpringColors)
                    
                    SeasonSection(title: "Estate", colors: [Color.blue, Color.white, Color.cyan], allColors: [Color.blue, Color.white, Color.cyan, Color.orange, Color.gray], isExpanded: $showSummerColors)
                    
                    SeasonSection(title: "Autunno", colors: [Color.brown, Color.orange, Color.red], allColors: [Color.brown, Color.orange, Color.red, Color.yellow, Color.yellow], isExpanded: $showAutumnColors)
                    
                    SeasonSection(title: "Inverno", colors: [Color.black, Color.gray, Color.blue], allColors: [Color.black, Color.gray, Color.blue, Color.red, Color.purple], isExpanded: $showWinterColors)
                }
                .padding()
            }
            .navigationTitle("Color Season")
        }
    }
}

struct SeasonSection: View {
    let title: String
    let colors: [Color]
    let allColors: [Color]
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
            
            if isExpanded {
                ForEach(allColors, id: \.self) { color in
                    Rectangle()
                        .fill(color)
                        .frame(height: 30)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.leading)
                }
            } else {
                ForEach(colors.prefix(3), id: \.self) { color in
                    Rectangle()
                        .fill(color)
                        .frame(height: 30)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.leading)
                }
            }
        }

    }
}

#Preview {
    AdvicesScreen().environmentObject(Database())
}
