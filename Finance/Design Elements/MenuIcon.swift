import UIKit

class DrawRect{
    
    static func drawCGRoundedRect(_ rect: CGRect, usingColor color: UIColor, withCornerRadius cornerRadius: CGFloat){
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        color.setFill()
        path.fill()
    }
    
}



class MenuIcon: UIView{
    
    static func build(color: UIColor, frame: CGRect) -> MenuIcon{
        
        let icon = MenuIcon()
        
        icon.backgroundColor = color
        
        icon.clipsToBounds = true
                
        icon.frame = frame
        
        return icon
    }
    
    private let heightLinePercentage = 0.1
    private let bigLineWidthPercentage = 0.9
    private let smallLineWidthPercentage = 0.6
    private let spaceBetweenLines = 0.1
    
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let x = self.bounds.origin.x
        let y = self.bounds.origin.y
        let width = self.bounds.width
        let height = self.bounds.height
        
        context.setFillColor(UIColor.white.cgColor)
        
        //First line
        let firstLineWidth = self.bounds.width * smallLineWidthPercentage
        let firstLineHeight = self.bounds.height * heightLinePercentage
        let firstLineRect = CGRect(x: 0, y: 0, width: firstLineWidth, height: firstLineHeight)
        DrawRect.drawCGRoundedRect(firstLineRect, usingColor: .gray, withCornerRadius: 2)
        
        //SecondLine
        let secondLineWidth = self.bounds.width * bigLineWidthPercentage
        let secondLineHeight = self.bounds.height * heightLinePercentage
        let secondLineRect = CGRect(x: 0, y: height * spaceBetweenLines + firstLineHeight, width: secondLineWidth, height: secondLineHeight)
        DrawRect.drawCGRoundedRect(secondLineRect, usingColor: .gray, withCornerRadius: 2)
        
        //ThirdLine
        let thirdLineWidth = self.bounds.width * bigLineWidthPercentage
        let thirdLineHeight = self.bounds.height * heightLinePercentage
        let thirdLineRect = CGRect(x: 0, y: (height * spaceBetweenLines) * 2 + firstLineHeight + secondLineHeight, width: thirdLineWidth, height: thirdLineHeight)
        DrawRect.drawCGRoundedRect(thirdLineRect, usingColor: .gray, withCornerRadius: 2)
        
        //FourthLine
        let fourthLineWidth = self.bounds.width * smallLineWidthPercentage
        let fourthLineHeight = self.bounds.height * heightLinePercentage
        let fourthLineX = thirdLineWidth - fourthLineWidth
        let fourthLineRect = CGRect(x: fourthLineX, y: (height * spaceBetweenLines) * 3 + firstLineHeight + secondLineHeight + thirdLineHeight, width: fourthLineWidth, height: fourthLineHeight)
        DrawRect.drawCGRoundedRect(fourthLineRect, usingColor: .gray, withCornerRadius: 2)
        
        
    }
    
}
