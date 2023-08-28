import UIKit

class CircleCategories{
    
    var circleValue: Int
    
    init(circleValue: Int) {
        self.circleValue = circleValue
    }
    
    
    func getCategoriesIncomeLayer(percentDict: [IncomeCategories.RawValue: Double]) -> [CAShapeLayer] {
        //MARK: Массив слоев для круговой диаграммы
        var layersArray: [CAShapeLayer] = []
        
        //MARK: Массив радина для окружности
        var radiansArray: [CGFloat] = []
        
        //MARK: Угол, с которого начинается построение окружности
        var startAngle = -1.57
        
        //MARK: Массив процентов, которой определяет слой для каждого категории
        var array: [Double] = []
        
        //MARK: Cумма процентов, которые из-за маленького размера нельзя поместить в отдельную категорию, они будут объеденены в одну категорию
        var sumDeleted: Double = 0
        
        //MARK: Массив категорий
        var tuplesArray1: [(IncomeCategories.RawValue, Double)] = []
        
        //MARK: Если трат за день нет, то возвращается серая окружность
        if percentDict == [:]{
            return [configureSingleLayer(degreesInPath: 360)]
        }
        
        var isExtraCategory = false
        //MARK: Сортировка категорий по размеру
        for (category, number) in percentDict{
            if number < 0.05{
                sumDeleted += number
            } else {
                array.append(number)
                tuplesArray1.append((category, number))
            }
        }
        
        
        //MARK: Cортировки по возрастанию процентов для отображения
        array.sort { first, second in
            first > second
        }
        
        tuplesArray1.sort { firstTuple, secondTuple in
            firstTuple.1 > secondTuple.1
        }
        
        print("T1:\(tuplesArray1)")
        print(sumDeleted)
        if sumDeleted >= 0.05{
            array.append(sumDeleted)
            isExtraCategory = true
        }
        let sumPercent = array.reduce(0, +)
        print(sumPercent)
        if sumPercent >= 1{
            array[array.count - 1] = array[array.count - 1] - (sumPercent - 1)
        }
        
        if round(sumPercent / 0.1) * 0.1 == 1.0{
            for item in array {
                var radian = deg2rad(360 * item)
                radian = round(radian / 0.01) * 0.01
                radiansArray.append(radian)
            }
            
            if isExtraCategory{
                for i in 0...radiansArray.count - 2 {
                    layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: radiansArray[i], color: CategoryIncomeDesignElements().getCategoryColors()[tuplesArray1[i].0]!))
                    startAngle = startAngle + radiansArray[i]
                }
                layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: radiansArray[radiansArray.count - 1], color: #colorLiteral(red: 0.7223421931, green: 0.8589904904, blue: 0.9465125203, alpha: 1)))
            } else {
                for i in 0...radiansArray.count - 1 {
                    layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: radiansArray[i], color: CategoryIncomeDesignElements().getCategoryColors()[tuplesArray1[i].0]!))
                    startAngle = startAngle + radiansArray[i]
                }
            }
            
            return layersArray
            
            
        } else if sumPercent <= 1 {
            
            for item in percentDict {
                radiansArray.append(deg2rad(360 * item.value))
            }
            radiansArray.append(deg2rad((1 - sumPercent) * 360))
            for item in radiansArray {
                layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: item, color:  .random()))
                startAngle = startAngle + item
            }
            return layersArray
            
            
        } else {
        
            print("Ошибка")
            return []
        }
    }
    
    func getCategoriesLayerCost(percentDict: [Categories.RawValue: Double]) -> [CAShapeLayer] {
        //MARK: Массив слоев для круговой диаграммы
        var layersArray: [CAShapeLayer] = []
        
        //MARK: Массив радина для окружности
        var radiansArray: [CGFloat] = []
        
        //MARK: Угол, с которого начинается построение окружности
        var startAngle = -1.57
        
        //MARK: Массив процентов, которой определяет слой для каждого категории
        var array: [Double] = []
        
        //MARK: Cумма процентов, которые из-за маленького размера нельзя поместить в отдельную категорию, они будут объеденены в одну категорию
        var sumDeleted: Double = 0
        
        //MARK: Массив категорий
        var tuplesArray1: [(Categories.RawValue, Double)] = []
        
        //MARK: Если трат за день нет, то возвращается серая окружность
        if percentDict == [:]{
            return [configureSingleLayer(degreesInPath: 360)]
        }
        
        var isExtraCategory = false
        print(percentDict)
        //MARK: Сортировка категорий по размеру
        for (category, number) in percentDict{
            if number < 0.05{
                sumDeleted += number
            } else {
                array.append(number)
                tuplesArray1.append((category, number))
            }
        }
        //MARK: Cортировки по возрастанию процентов для отображения
        array.sort { first, second in
            first > second
        }
        
        tuplesArray1.sort { firstTuple, secondTuple in
            firstTuple.1 > secondTuple.1
        }
        
        print("T1:\(tuplesArray1)")
        print(sumDeleted)
        if sumDeleted >= 0.05{
            array.append(sumDeleted)
            isExtraCategory = true
        }
        let sumPercent = array.reduce(0, +)
        print(sumPercent)
        if sumPercent >= 1{
            array[array.count - 1] = array[array.count - 1] - (sumPercent - 1)
        }
        
//        if sumPercent < 1{
//            array[array.count - 1] += 1 - sumPercent
//        }
        
        if round(sumPercent / 0.1) * 0.1 == 1.0{
            for item in array {
                var radian = deg2rad(360 * item)
                radian = round(radian / 0.01) * 0.01
                radiansArray.append(radian)// Item в долях
            }
            
            if isExtraCategory{
                for i in 0...radiansArray.count - 2 {
                    layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: radiansArray[i], color: CategoryCostsDesignElements().getCategoryColors()[tuplesArray1[i].0]!))
                    startAngle = startAngle + radiansArray[i]
                }
                layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: radiansArray[radiansArray.count - 1], color: #colorLiteral(red: 0.7223421931, green: 0.8589904904, blue: 0.9465125203, alpha: 1)))
            } else {
                for i in 0...radiansArray.count - 1 {
                    layersArray.append(configureLayer(startAngle: startAngle, degreesInPath: radiansArray[i], color: CategoryCostsDesignElements().getCategoryColors()[tuplesArray1[i].0]!))
                    startAngle = startAngle + radiansArray[i]
                }
            }
            
            return layersArray
            
            
        } else if sumPercent <= 1 {
            
            
            
            for item in percentDict {
                radiansArray.append(deg2rad(360 * item.value))
            }
            radiansArray.append(deg2rad((1 - sumPercent) * 360))
            for item in radiansArray {
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
    
    private func configureExtraLayer(startAngle: CGFloat, degreesInPath: CGFloat, color: UIColor) -> CAShapeLayer{
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configureExtraLayerPath(startAngle: startAngle, degreesInPath: degreesInPath)
        backgroundLayer.strokeColor = color.cgColor
        backgroundLayer.lineWidth = 26
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = nil
        print(degreesInPath)
        return backgroundLayer
    }
    
    
    private func configureExtraLayerPath(startAngle: CGFloat, degreesInPath: CGFloat) -> CGPath{
        UIBezierPath(arcCenter: CGPoint(x: circleValue, y: circleValue),
                     radius: CGFloat(circleValue),
                     startAngle: startAngle,
                     endAngle: startAngle + degreesInPath,
                     clockwise: true).cgPath
    }
    
    
    private func configureLayerPath(startAngle: CGFloat, degreesInPath: CGFloat) -> CGPath{
        UIBezierPath(arcCenter: CGPoint(x: circleValue, y: circleValue),
                     radius: CGFloat(circleValue),
                     startAngle: startAngle + .pi / 30,
                     endAngle: startAngle + degreesInPath - .pi / 30,
                     clockwise: true).cgPath
    }
    
    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    func configureSingleLayer(degreesInPath: Int) -> CAShapeLayer{
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configureLayerPath(startAngle: -1.57, degreesInPath: deg2rad(Double(degreesInPath)))
        backgroundLayer.strokeColor = UIColor.systemGray4.cgColor
        backgroundLayer.lineWidth = 26
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = nil
        backgroundLayer.strokeEnd = 1
        return backgroundLayer
    }
    
    
    private func configurePath(startAngle: CGFloat, degreesInPath: CGFloat, x: Int, y: Int) -> CGPath{
        UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                     radius: CGFloat(circleValue - 20),
                     startAngle: startAngle,
                     endAngle: startAngle + degreesInPath,
                     clockwise: true).cgPath
        
    }
    
    func configureLayer(degreesInPath: Int, x: Int, y: Int) -> CAShapeLayer{
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configurePath(startAngle: -1.57, degreesInPath: deg2rad(CGFloat(degreesInPath)), x: x, y: y)
        backgroundLayer.strokeColor = UIColor.systemGray4.cgColor
        backgroundLayer.lineWidth = 10
        backgroundLayer.lineCap = .round
        backgroundLayer.fillColor = nil
        backgroundLayer.strokeEnd = 1
        return backgroundLayer
    }
    
    func configureFillLayer(degreesInPath: Int, x: Int, y: Int, color: UIColor, lineWidth: Double)-> CAShapeLayer{
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = configurePath(startAngle: -1.57, degreesInPath: deg2rad(CGFloat(degreesInPath)), x: x, y: y)
        backgroundLayer.strokeColor = color.cgColor
        backgroundLayer.lineWidth = CGFloat(lineWidth)
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
