//
//  Solar2LunarViewController.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 11/9/25.
//

import UIKit

class Solar2LunarViewController: UIViewController {
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: -
    @IBAction func onTapConvertButton(_ sender: Any) {
        let tool = VietnameseLunar()
        
        let calendar = Calendar.current
        let components: Set = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]
        let calendarComps = calendar.dateComponents(components, from: datePicker.date)
        
        if let lunar = tool.convertSolar2Lunar(day: calendarComps.day ?? 0, month: calendarComps.month ?? 0, year: calendarComps.year ?? 0) {
            var s: String = ""
            s += "Ngày \(lunar.day) "
            s += "Tháng \(lunar.month) "
            if lunar.leapMonth {
                s += "(Nhuận)"
            }
            s += ", Năm \(lunar.year)"
            s += "\nTên năm: \(lunar.year_name)"
            resultLabel.text = s
        } else {
            resultLabel.text = "Invalid date"
        }
    }
}
