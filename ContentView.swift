import SwiftUI
import Firebase
import Network

struct ContentView: View {
    @State var clothes: [Cloth] = []
    @State var selection = 0
    let db = Firestore.firestore()
    @EnvironmentObject var database: Database
    @State private var showDisconnectBanner = false
    @State private var showReconnectBanner = false
    @State private var isConnected = true
    let monitor = NWPathMonitor()

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                OutfitScreen()
                    .tabItem {
                        Label("Outfit", systemImage: "tshirt")
                            .accentColor(.primary)
                    }
                    .tag(0)
                
                ClothesScreen(clothes: $clothes)
                    .tabItem {
                        Label("Guardaroba", systemImage: "hanger")
                            .accentColor(.primary)
                    }
                    .tag(2)
                
                AdvicesScreen()
                    .tabItem {
                        Label("Consigli", systemImage: "globe.europe.africa.fill")
                            .accentColor(.primary)
                    }
                    .tag(1)
            }
            .onAppear {
                if let data = UserDefaults.standard.object(forKey: "CLOTHES") as? Data {
                    do {
                        let decoder = JSONDecoder()
                        let clo = try decoder.decode([Cloth].self, from: data)
                        clothes = clo
                    } catch {
                        print("Impossibile effettuare la decodifica \(error)")
                    }
                }
                startNetworkMonitoring()
            }

            // Banner per la disconnessione
            if showDisconnectBanner {
                VStack {
                    Text("Connessione ad Internet interrotta")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                        .offset(y: showDisconnectBanner ? 0 : -100) // Start above the view
                        .opacity(showDisconnectBanner ? 1 : 0) // Start invisible
                    Spacer()
                }
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Banner per la riconnessione
            if showReconnectBanner {
                VStack {
                    Text("Connessione ad Internet ristabilita")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                        .offset(y: showReconnectBanner ? 0 : -100) // Start above the view
                        .opacity(showReconnectBanner ? 1 : 0) // Start invisible
                    Spacer()
                }
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    
    func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let wasConnected = isConnected
                isConnected = path.status == .satisfied
                
                if wasConnected && !isConnected {
                    // Mostra banner di disconnessione
                    showDisconnectBannerMessage()
                } else if !wasConnected && isConnected {
                    // Mostra banner di riconnessione
                    showReconnectBannerMessage()
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func showDisconnectBannerMessage() {
        withAnimation {
            showDisconnectBanner = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showDisconnectBanner = false
            }
        }
    }

    func showReconnectBannerMessage() {
        withAnimation {
            showReconnectBanner = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showReconnectBanner = false
            }
        }
    }
}

extension UIImage {
    func toPngString() -> String? {
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

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
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


extension Color {
    
    func toUIColor() -> UIColor {
            let components = self.cgColor?.components
            let red = components?[0] ?? 0
            let green = components?[1] ?? 0
            let blue = components?[2] ?? 0
        let alpha = components!.count > 3 ? components?[3] ?? 1 : 1
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }

    init(hex: String) {
        // Rimuovi il simbolo `#` se presente
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        
        // Se la stringa non ha la lunghezza corretta, usa un colore di default
        guard hex.count == 6 || hex.count == 8 else {
            self.init(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
            return
        }
        
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: CGFloat
        switch hex.count {
        case 6:
            // RGB
            (r, g, b, a) = (
                CGFloat((int >> 16) & 0xFF) / 255.0,
                CGFloat((int >> 8) & 0xFF) / 255.0,
                CGFloat(int & 0xFF) / 255.0,
                1.0
            )
        case 8:
            // RGBA
            (r, g, b, a) = (
                CGFloat((int >> 16) & 0xFF) / 255.0,
                CGFloat((int >> 8) & 0xFF) / 255.0,
                CGFloat(int & 0xFF) / 255.0,
                CGFloat((int >> 24) & 0xFF) / 255.0
            )
        default:
            // Valore di default se il formato non è valido
            (r, g, b, a) = (1.0, 1.0, 1.0, 1.0)
        }
        
        // Inizializza il colore con i valori calcolati
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

extension UIColor {
    func rgbaToHex() -> String {
        // Ottieni i componenti del colore (red, green, blue, alpha)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Assicurati che il colore sia in formato RGB
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Converti i componenti in valori esadecimali
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)
        
        // Crea una stringa esadecimale
        if alpha < 1.0 {
            // Include alpha se è meno di 1.0 (parzialmente trasparente)
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            // Se alpha è 1.0 (pieno), si omette
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
    
    var displayP3Color: UIColor {
            if let cgColor = self.cgColor.converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .defaultIntent, options: nil) {
                return UIColor(cgColor: cgColor)
            }
            return self
        }

        var sRGBColor: UIColor {
            if let cgColor = self.cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil) {
                return UIColor(cgColor: cgColor)
            }
            return self
        }
}


#Preview {
    ContentView()
}
