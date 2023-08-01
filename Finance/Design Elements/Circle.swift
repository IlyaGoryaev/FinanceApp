import UIKit

class CircleCategories{
    
    func getCategoriesLayer(percentArray: [Double]) -> [CAShapeLayer] {
        var layersArray: [CAShapeLayer] = []
        var degreesArray: [CGFloat] = []
        var startAngle = -1.57
        let sumPercent = percentArray.reduce(0, +)
        print(Int(sumPercent))
        if sumPercent == 1.0{
            
            
            
            for item in percentArray {
                degreesArray.append(deg2rad(360 * item))// Item в долях
            }
            
            for item in degreesArray {
                layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: item, color: .random()))
                startAngle = startAngle + item
            }
            return layersArray
            
            
        } else if sumPercent <= 1{
            
            
            
            for item in percentArray {
                degreesArray.append(deg2rad(360 * item))// Item в долях
            }
            degreesArray.append(deg2rad((1 - sumPercent) * 360))
            
            for item in degreesArray {
                layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: item, color:  .random()))
                startAngle = startAngle + item
            }
            return layersArray
            
            
        } else {
        
            print("Ошибка")
            return []
        }
    }
    
    
    private func configureLayer(startAngle: CGFloat, degreesInPath: CGFloat, color: UIColor) -> CAShapeLayer{
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configureLayerPath(startAngle: startAngle, degreesInPath: degreesInPath)
        backgroundLayer.strokeColor = color.cgColor
        backgroundLayer.lineWidth = 26
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = nil
        return backgroundLayer
    }
    
    
    private func configureLayerPath(startAngle: CGFloat, degreesInPath: CGFloat) -> CGPath{
        UIBezierPath(arcCenter: CGPoint(x: 150, y: 150),
                     radius: 150,
                     startAngle: startAngle + .pi / 26,
                     endAngle: startAngle + degreesInPath - .pi / 26,
                     clockwise: true).cgPath
    }
    
    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    func configureSingleLayer(degreesInPath: Int) -> CAShapeLayer{
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configureLayerPath(startAngle: -1.57, degreesInPath: deg2rad(Double(degreesInPath)))
        backgroundLayer.strokeColor = UIColor.white.cgColor
        backgroundLayer.lineWidth = 30
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = nil
        backgroundLayer.strokeEnd = 1
        return backgroundLayer
    }
    
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
