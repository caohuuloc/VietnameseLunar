//
//  Lunar2SolarViewController.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 12/9/25.
//

import UIKit

class Lunar2SolarViewController: UIViewController {
    @IBOutlet var dayTextField: UITextField!
    @IBOutlet var monthTextField: UITextField!
    @IBOutlet var leapMonthSwitch: UISwitch!
    @IBOutlet var yearTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tool = VietnameseLunar()
        let date = Date()
        if let lunar = tool.convertSolar2Lunar(solarDate: date) {
            dayTextField.text = "\(lunar.day)"
            monthTextField.text = "\(lunar.month)"
            yearTextField.text = "\(lunar.year)"
            leapMonthSwitch.isOn = lunar.leapMonth
        }
    }
    
    // MARK: -
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func onTapConvertButton(_ sender: Any) {
        view.endEditing(true)
        
        let dd = Int(dayTextField.text ?? "") ?? 0
        let mm = Int(monthTextField.text ?? "") ?? 0
        let yyyy = Int(yearTextField.text ?? "") ?? 0
        let leapMonth = leapMonthSwitch.isOn
        
        let lunar = LunarDate(day: dd, month: mm, year: yyyy, julius: 0, leapMonth: leapMonth)
        let tool = VietnameseLunar()
        if let solar = tool.convertLunar2Solar(lunarDate: lunar) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            resultLabel.text = formatter.string(from: solar)
        } else {
            resultLabel.text = "Invalid date"
        }
    }
}
