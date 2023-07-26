import SwiftUI
import UIKit


struct SwiftUIView: View {
    
    @State var line: CGFloat = 30
    @State var greenLine: CGFloat = 30
    @State var value: CGFloat = 1
    
    var colorBackground: UIColor
    var text: String
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 400, height: 300)
                .background(Color(colorBackground))
            Color(colorBackground)
            CircleView(color: .red, trimFrom: 0.2, trimTo: 0.4, size: 250)
            CircleView(color: .green, trimFrom: 0.1, trimTo: 0.2, size: 250)
            CircleView(color: .magenta, trimFrom: 0, trimTo: 0.1, size: 250)
            CircleView(color: .purple, trimFrom: 0.4, trimTo: 1, size: 250)
            CircleView(color: .systemGray4, trimFrom: 0, trimTo: value, size: 250)
            Text(text)
                .font(.custom("MochiyPopPOne-Regular", size: 35))
                .foregroundColor(Color.white)
        }.onAppear{
            withAnimation(.easeIn(duration: 0.8)) {
                self.value = 0
            }
        }
        
    }
}

struct CircleView: View{
    
    var color: UIColor
    var trimFrom: CGFloat
    var trimTo: CGFloat
    var size: CGFloat
    
    
    var body: some View{
        let dist = 0.001
        
        Circle()
            .trim(from: trimFrom + dist, to: trimTo - dist)
            .stroke(Color(color), style: StrokeStyle(lineWidth: 30))
            .rotationEffect(Angle(degrees: 90))
            .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
            .frame(width: size, height: size)
    }
    
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(colorBackground: UIColor.black, text: "5674")
    }
}
