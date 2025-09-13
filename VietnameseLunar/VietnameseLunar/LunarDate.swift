//
//  LunarDate.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 11/9/25.
//

import UIKit

class LunarDate: NSObject {
    public var day: Int = 1
    public var month: Int = 1
    public var leapMonth: Bool = false
    public var year: Int = 0
    
    public var julius: Double = 0.0
    
    // MARK: -
    public override init() {
        super.init()
    }
    
    public init(day: Int, month: Int, year: Int, julius: Double, leapMonth: Bool = false) {
        super.init()
        self.day = day
        self.month = month
        self.year = year
        self.julius = julius
        self.leapMonth = leapMonth
    }
    
    // MARK: -
    public var year_can: String {
        let modCan = year % 10
        return getYearCanName(modCan)
    }
    
    public var year_chi: String {
        let modChi = year % 12
        return getYearChiName(modChi)
    }
    
    public var year_name: String {
        return "\(year_can) \(year_chi)"
    }
    
    // MARK: -
    private func getYearCanName(_ modCan: Int) -> String {
        switch modCan {
        case 0:
            return "Canh"
        case 1:
            return "Tân"
        case 2:
            return "Nhâm"
        case 3:
            return "Quý"
        case 4:
            return "Giáp"
        case 5:
            return "Ất"
        case 6:
            return "Bính"
        case 7:
            return "Đinh"
        case 8:
            return "Mậu"
        case 9:
            return "Kỷ"
        default:
            return ""
        }
    }
    
    private func getYearChiName(_ modChi: Int) -> String {
        switch modChi {
        case 0:
            return "Thân"
        case 1:
            return "Dậu"
        case 2:
            return "Tuất"
        case 3:
            return "Hợi"
        case 4:
            return "Tý"
        case 5:
            return "Sửu"
        case 6:
            return "Dần"
        case 7:
            return "Mão"
        case 8:
            return "Thìn"
        case 9:
            return "Tỵ"
        case 10:
            return "Ngọ"
        case 11:
            return "Mùi"
        default:
            return ""
        }
    }
}
