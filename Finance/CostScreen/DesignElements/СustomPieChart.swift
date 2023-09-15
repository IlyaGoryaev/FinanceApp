import Foundation
import DGCharts
import UIKit

class CustomPieChart: PieChartView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CustomPieChart{
    
    private func setUpStyle(){
        let centerText = NSAttributedString(
            string: "",
            attributes: [
                .font : UIFont.systemFont(ofSize: 20, weight: .bold)
            ])
        self.centerAttributedText = centerText
        self.rotationEnabled = false
        self.legend.enabled = false
        self.drawCenterTextEnabled = true
        self.usePercentValuesEnabled = false
        self.chartDescription.enabled = true
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 5
        self.entryLabelColor = .blue
    }
    
}
