//
//  YPGenViewController.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 12/9/25.
//

import UIKit

class YPGenViewController: UIViewController {
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var newYearDate: UIDatePicker!
    @IBOutlet var monthsView: MonthsSettingView!
    @IBOutlet var leapMonthTextField: UITextField!
    @IBOutlet var leapMonthFullSwitch: UISwitch!
    @IBOutlet var resultTextField: UITextField!
    
    var year: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let calendar = Calendar.current
        let comps = calendar.dateComponents([.day, .month, .year], from: Date())
        yearTextField.text = "\(comps.year ?? 0)"
    }
    
    func generateYearParameter(offsetOfTet: Int, leapMonth: Int, leapMonthFull: Bool, regularMonths: [LunarMonth]) -> Int {
        var parameter: Int = leapMonth
        if leapMonthFull {
            parameter |= 0x1 << 16
        }
        parameter |= offsetOfTet << 17

        var regularMonthLengths: Int = 0
        for i in 0..<12 {
            let month = regularMonths[i]
            if (month.monthLength >= 30) {
                regularMonthLengths |= 1 << (11 - i)
            }
        }
        parameter |= regularMonthLengths << 4
        
        return parameter
    }
    
    // MARK: -
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func onTapLoadButton(_ sender: Any) {
        view.endEditing(true)
        
        let tool =  VietnameseLunar()
        let year = Int(yearTextField.text ?? "") ?? 0
        let parameter = tool.getYearParameter(year)
        if parameter == 0 {
            self.year = 0
            return
        }
        
        self.year = year
        
        let calendar = Calendar.current
        let minDate = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let maxDate = calendar.date(from: DateComponents(year: year, month: 5, day: 31))!
        newYearDate.minimumDate = minDate
        newYearDate.maximumDate = maxDate
        
        let allMonths = tool.decodeLunarYear(year: year, parameter: parameter)
        var leapMonth = 0
        var leapMonthLength = 0
        var regularMonths: [LunarMonth] = []
        for month in allMonths {
            if !month.leapMonth {
                regularMonths.append(month)
            } else {
                leapMonth = month.month
                leapMonthLength = month.monthLength
            }
        }
        let jdLunarNY = regularMonths.first!.days.first!.julius
        let lunarNewYearDate = tool.jdToDate(jdLunarNY)
        
        newYearDate.date = lunarNewYearDate
        monthsView.loadMonths(regularMonths)
        leapMonthTextField.text = "\(leapMonth)"
        leapMonthFullSwitch.isOn = (leapMonthLength >= 30)
        
        let hexParameter = String(format: "0x%06x", parameter)
        resultTextField.text = hexParameter
    }
    
    @IBAction func onTapGenerateButton(_ sender: Any) {
        view.endEditing(true)
        
        let leapMonth = Int(leapMonthTextField.text ?? "0") ?? 0
        let months = monthsView.months
        guard (leapMonth >= 0) && (leapMonth <= 12) && (months.count == 12) else { return }
        if (leapMonth == 0) {
            leapMonthFullSwitch.isOn = false
        }
        let calendar = newYearDate.calendar!
        let solarNY = calendar.date(from: DateComponents(year: self.year, month: 1, day: 1))!
        let offsetOfTet = Int(floor(newYearDate.date.timeIntervalSince(solarNY) / 86400))
        
        let parameter = generateYearParameter(offsetOfTet: offsetOfTet, leapMonth: leapMonth, leapMonthFull: leapMonthFullSwitch.isOn, regularMonths: monthsView.months)
        let hexParameter = String(format: "0x%06x", parameter)
        resultTextField.text = hexParameter
    }
}
