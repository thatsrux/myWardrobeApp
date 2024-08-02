import SwiftUI

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
