import SwiftUI

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

#Preview {
    ColorMatch()
}
