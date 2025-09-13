//
//  LunarMonth.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 11/9/25.
//

import UIKit

class LunarMonth: NSObject {
    var year: Int = 1
    var month: Int = 1
    var leapMonth: Bool = false
    var monthLength: Int = 30
    
    var days: [LunarDate] = []
    
    public override init() {
        super.init()
    }
    
    public init(fisrtDay: LunarDate, monthLength: Int) {
        super.init()
        
        self.monthLength = monthLength
        self.month = fisrtDay.month
        self.year = fisrtDay.year
        self.leapMonth = fisrtDay.leapMonth
        self.days.append(fisrtDay)
    }
    
    public func generateFullMonthData() {
        if let first = days.first {
            self.days.removeAll()
            self.days.append(first)
            if monthLength > 2 {
                for i in 2..<monthLength {
                    let obj = LunarDate(day: first.day + i, month: first.month, year: first.year, julius: first.julius + Double(i), leapMonth: first.leapMonth)
                    self.days.append(obj)
                }
            }
        }
    }
}
