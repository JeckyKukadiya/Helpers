//  SubClass.swift

import Foundation
import UIKit
import TTRangeSlider
import Charts
import KMPlaceholderTextView

class Main : UIViewController, UITextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

class RangeSlider: TTRangeSlider {
    
}

class JKButton: UIButton {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var Border: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = Border
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

class CustomProgressBar: UIProgressView {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var Border: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = Border
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

class CustomLabel : UILabel {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var Border: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = Border
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
}

class CustomImage : UIImageView {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var Border: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = Border
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
}

class JKView: UIView {
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var bottomBorder: CGFloat = 0.0 {
        didSet {
            DispatchQueue.main.async {
                let border = CALayer()
                let width = self.bottomBorder
                border.borderColor = UIColor.darkGray.cgColor
                border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
                border.borderWidth = width
                self.layer.addSublayer(border)
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var Border: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = Border
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

class textFieldProperties: UITextField {
    @IBInspectable var dropShadow: Bool = false {
        didSet {
            let shadowPath = UIBezierPath(rect: bounds)
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            layer.shadowOpacity = 0.5
            layer.shadowPath = shadowPath.cgPath
        }
    }
    
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var Border: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = Border
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    @IBInspectable var LeftSpace: CGFloat = 0 {
        didSet {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: LeftSpace, height: self.frame.size.height))
            view.backgroundColor = UIColor.clear
            self.leftView = view
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var LeftImage: UIImage? {
        didSet {
            let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height))
            iv.image = LeftImage
            iv.contentMode = .center
            self.leftView = iv
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var RightSpace: CGFloat = 0 {
        didSet {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: RightSpace, height: self.frame.size.height))
            view.backgroundColor = UIColor.clear
            self.rightView = view
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable var RightImage: UIImage? {
        didSet {
            let vw = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 25))
            let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            iv.image = RightImage
            iv.contentMode = .center
            vw.addSubview(iv)
            self.rightView = vw
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: placeHolderColor!])
        }
    }
    
    @IBInspectable var bottomBorder:CGFloat = 0 {
        didSet {
            DispatchQueue.main.async {
                let border = CALayer()
                let width = self.bottomBorder
                border.borderColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1.0).cgColor
                border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
                border.borderWidth = width
                self.layer.addSublayer(border)
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var RightLabel: String? {
        didSet {
            let vw = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 25))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 25))
            label.text = RightLabel
            label.textColor = #colorLiteral(red: 0.4745098039, green: 0.4745098039, blue: 0.4745098039, alpha: 1)
            label.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 14.0)
            vw.addSubview(label)
            self.rightView = vw
            self.rightViewMode = .always
        }
    }
}

class customTextView : KMPlaceholderTextView{
    @IBInspectable var Border: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = Border
        }
    }
    
    @IBInspectable var BorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    @IBInspectable var Radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = Radius
            self.layer.masksToBounds = true
        }
    }
}

class ChartStringTimeFormatter: NSObject, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        var strAxisValue = ""
        if (value != 0.0) {
            if "\(value)".contains("."){
                
                let tempValue = String(format:"%.2f",value)
                let tempData = tempValue.split(separator: ".")
                
                let minutes = String(tempData[0])
                let seconds = String(tempData[1])
                
                var min = 0, sec = 0
                if !minutes.isEmpty {
                    min = Int(minutes)!
                }
                
                if !seconds.isEmpty {
                    min = min + Int(seconds)! / 60
                    sec = Int(seconds)! % 60
                }
                
                strAxisValue = String(format: "%02dm %02ds", min, sec)
            }else {
                strAxisValue = ""
            }
        } else {
            strAxisValue = ""
        }
        return strAxisValue
    }
}

class ChartStringTimeWiseDistanceFormatter: NSObject, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        var strAxisValue = ""
        if (value != 0.0) {
            if "\(value)".contains("."){
                
                let tempValue = String(format:"%.2f",value)
                let tempData = tempValue.split(separator: ".")
                
                let minutes = String(tempData[0])
                let seconds = String(tempData[1])
                
                strAxisValue = "\(minutes):\(seconds)" + " min/\(UserModel.sharedInstance().selectedDistanceUnit == "MI" ? "mi" : "km")"
            }else {
                strAxisValue = ""
            }
        } else {
            strAxisValue = ""
        }
        return strAxisValue
    }
}

class ChartStringDistanceFormatter: NSObject, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if value != 0.0 {
            return "\(String(format:"%.2f",value)) \(UserModel.sharedInstance().selectedDistanceUnit == "MI" ? "mi" : "km")"
        }else{
            return ""
        }
    }
}

class ChartStringSpeedFormatter: NSObject, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if value != 0.0 {
            return "\(String(format:"%.2f",value)) \(UserModel.sharedInstance().selectedDistanceUnit == "MI" ? "mi/h" : "km/h")"
        }else{
            return ""
        }
    }
}

class ChartStringHRFormatter: NSObject, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if value != 0.0{
            return "\(String(format:"%.0f",value)) bpm"
        }else{
            return ""
        }
    }
} 

class ChartStringRRFormatter: NSObject, IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if value != 0.0{
            return "\(String(format:"%.0f",value)) brm"
        }else{
            return ""
        }
    }
}

class CustomChartFormatter: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let min = Int(value / 60)
        let sec = value.truncatingRemainder(dividingBy: 60)
        return "\(min)m\(String(format:"%.0f", sec))s"
    }
}

class LineChartFormatter: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        
        if value <= 60 {
            return "\(Int(value))s"
        }else {
            let min = Int(value / 60)
            if min < 6 {
                let sec = value.truncatingRemainder(dividingBy: 60)
                return "\(min)m\(String(format:"%.0f", sec))s"
            }else {
                return "\(min)min"
            }
        }
        
    }
}

class LineChartFormatter1: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if cntSessionDuration > 960 {
            let dummyValue = (cntSessionDuration-960) + Int(value)
            
            if dummyValue >= 0 {
                if dummyValue < 60 {
                    return "\(Int(dummyValue))s"
                }else {
                    let min = Int(dummyValue / 60)
                    return "\(min)min"
                }
            }else {
                return ""
            }
        }else {
            if value >= 0 && !(value.isNaN || value.isInfinite) {
                if value < 60 {
                    return "\(Int(value))s"
                }else {
                    let min = Int(value / 60)
                    return "\(min)min"
                }
            }else {
                return ""
            }
        }
        
    }
}

class LineChartFormatterRR: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value >= 0 && !(value.isNaN || value.isInfinite){
            if value < 60 {
                return "\(Int(value))s"
            }else {
                let min = Int(value / 60)
                return "\(min)min"
            }
        }else {
            return ""
        }
    }
    
}
