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
            GeometryReader { geometry in
                VStack {
                    Text("Outfit del giorno")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    if let dailyOutfitID = dailyOutfitID,
                       let outfit = database.outfits.first(where: { $0.id == dailyOutfitID }) {
                        
                        HStack {
                            VStack(spacing: 10) {
                                Image(uiImage: outfit.shirt?.image?.toImage() ?? UIImage(imageLiteralResourceName: "shirt"))
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(
                                        width: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.35 : geometry.size.width * 0.33,
                                        height: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.height * 0.15 : geometry.size.height * 0.16
                                    )
                                Image(uiImage: outfit.trousers?.image?.toImage() ?? UIImage(imageLiteralResourceName: "trousers"))
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(
                                        width: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.35 : geometry.size.width * 0.33,
                                        height: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.height * 0.15 : geometry.size.height * 0.16
                                    )
                                Image(uiImage: outfit.shoes?.image?.toImage() ?? UIImage(imageLiteralResourceName: "shoes"))
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(
                                        width: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.2 : geometry.size.width * 0.2,
                                        height: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.height * 0.085 : geometry.size.height * 0.1
                                    )
                                Text(outfit.nome ?? "")
                                    .foregroundStyle(.black)
                            }
                            .frame(
                                width: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.width * 0.4 : geometry.size.width * 0.375,
                                height: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.height * 0.6 : geometry.size.height * 0.58
                            )
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(10)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        Text("Nessun outfit disponibile")
                            .padding(.top, 50)
                        Spacer()
                    }
                    
                    // Bottoni
                    VStack(spacing: 20) {
                        Button(action: {
                            isColorMatchScreenActive.toggle()
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple]), startPoint: .leading, endPoint: .trailing))
                                .frame(
                                    width: geometry.size.width * 0.9,
                                    height: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.height * 0.12 : geometry.size.height * 0.1
                                )
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
                                .frame(
                                    width: geometry.size.width * 0.9,
                                    height: UIDevice.current.userInterfaceIdiom == .phone ? geometry.size.height * 0.12 : geometry.size.height * 0.1
                                )
                                .overlay(
                                    Text("Magic Outfit")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                )
                        }
                        .sheet(isPresented: $isMagicOutfitScreenActive) {
                            MagicOutfit(cloth: cloth)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .navigationTitle("Consigli per te")
            .onAppear {
                selectDailyOutfit()
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
           let savedID = UserDefaults.standard.uuid(forKey: "dailyOutfitID"),
           database.outfits.contains(where: { $0.id == savedID }) {
            // Se è lo stesso giorno e l'outfit salvato esiste ancora, usa l'outfit salvato
            dailyOutfitID = savedID
        } else {
            selectNewOutfit()
        }
    }

    // Funzione per selezionare un nuovo outfit da database.outfits
    func selectNewOutfit() {
        let today = Date()
        
        // Recupera l'outfit del giorno precedente
        let previousOutfitID = UserDefaults.standard.uuid(forKey: "dailyOutfitID")
        
        // Escludi l'outfit del giorno precedente dalla selezione
        var availableOutfits = database.outfits
        if let previousID = previousOutfitID, availableOutfits.count > 1 {
            availableOutfits.removeAll(where: { $0.id == previousID })
        }
        
        // Seleziona un nuovo outfit casuale o ripropone lo stesso se è l'unico
        if let randomOutfit = availableOutfits.randomElement() {
            dailyOutfitID = randomOutfit.id
            
            // Salva l'UUID e la data di oggi
            UserDefaults.standard.set(dailyOutfitID, forKey: "dailyOutfitID")
            UserDefaults.standard.set(today, forKey: "dailyOutfitDate")
            UserDefaults.standard.set(true, forKey: "validOutfitSelected")
        } else if let previousID = previousOutfitID {
            // Se non ci sono altri outfit disponibili, ripropone lo stesso outfit
            dailyOutfitID = previousID
        } else {
            // Se non ci sono outfit disponibili, segna che non è stato selezionato un outfit valido
            UserDefaults.standard.set(false, forKey: "validOutfitSelected")
            dailyOutfitID = nil
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

