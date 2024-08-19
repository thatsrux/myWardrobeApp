import SwiftUI

struct AdvicesScreen: View {
    
    @EnvironmentObject var database: Database
    
    @State private var dailyOutfitID: UUID?
    @State private var isColorMatchScreenActive = false
    @State private var isColorSeasonScreenActive = false
    @State private var isMagicOutfitScreenActive = false
    
    @State var cloth: Cloth?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Outfit del giorno").font(.headline)

                    // Se esiste un dailyOutfitID, mostra l'outfit del giorno
                    if let dailyOutfitID = dailyOutfitID,
                       let outfit = database.outfits.first(where: { $0.id == dailyOutfitID }) {
                        SingleOutfitGrid(outfit: outfit)
                    } else {
                        Text("Nessun outfit disponibile")
                        Spacer(minLength: 300)
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
                        isMagicOutfitScreenActive.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.purple))
                            .frame(height: 100)
                            .overlay(
                                Text("Magic Outfit")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                    }.sheet(isPresented: $isMagicOutfitScreenActive) {
                        MagicOutfit(cloth: cloth)
                    }
                }
                .padding()
                .navigationTitle("Consigli per te")
            }
            .onAppear {
                selectDailyOutfit()
            }
            .onChange(of: database.outfits) { _, _ in
                retrieveDailyOutfit()
            }
        }
    }
    
    // Funzione per selezionare l'outfit del giorno
    func selectDailyOutfit() {
        let calendar = Calendar.current
        let today = Date()

        // Controlla se è stato già selezionato un outfit valido oggi
        if let savedDate = UserDefaults.standard.object(forKey: "dailyOutfitDate") as? Date,
           calendar.isDate(savedDate, inSameDayAs: today),
           UserDefaults.standard.bool(forKey: "validOutfitSelected") {
            // Se è lo stesso giorno e un outfit valido è stato selezionato, usa l'outfit salvato
            dailyOutfitID = UserDefaults.standard.uuid(forKey: "dailyOutfitID")
        } else {
            selectNewOutfit()
        }
    }

    // Funzione per recuperare l'outfit del giorno dopo l'aggiornamento degli outfits
    func retrieveDailyOutfit() {
        // Recupera l'outfit salvato
        if let savedID = UserDefaults.standard.uuid(forKey: "dailyOutfitID") {
            dailyOutfitID = savedID
            
            // Controlla se l'outfit esiste ancora nel database
            if !database.outfits.contains(where: { $0.id == savedID }) {
                // Se l'outfit non esiste più, seleziona un nuovo outfit da database.outfits
                selectNewOutfit()
            }
        }
        
        // Se l'array degli outfits è stato aggiornato ed è non vuoto ma il dailyOutfitID è nil o un outfit valido non è stato selezionato, seleziona un nuovo outfit
        if dailyOutfitID == nil || !UserDefaults.standard.bool(forKey: "validOutfitSelected"), !database.outfits.isEmpty {
            selectNewOutfit()
        }
    }

    // Funzione per selezionare un nuovo outfit da database.outfits
    func selectNewOutfit() {
        let today = Date()
        
        // Seleziona un nuovo outfit casuale da database.outfits
        if let randomOutfit = database.outfits.randomElement() {
            dailyOutfitID = randomOutfit.id
            
            // Salva l'UUID e la data di oggi
            UserDefaults.standard.set(dailyOutfitID, forKey: "dailyOutfitID")
            UserDefaults.standard.set(today, forKey: "dailyOutfitDate")
            UserDefaults.standard.set(true, forKey: "validOutfitSelected")
        } else {
            // Se non ci sono outfit disponibili, segna che non è stato selezionato un outfit valido
            UserDefaults.standard.set(false, forKey: "validOutfitSelected")
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
                    Text(outfit.nome ?? "")
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

// Estensione per salvare e recuperare UUID in UserDefaults
extension UserDefaults {
    func set(_ value: UUID?, forKey defaultName: String) {
        set(value?.uuidString, forKey: defaultName)
    }

    func uuid(forKey defaultName: String) -> UUID? {
        if let uuidString = string(forKey: defaultName) {
            return UUID(uuidString: uuidString)
        }
        return nil
    }
}
