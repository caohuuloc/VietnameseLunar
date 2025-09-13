//
//  VietnameseLunar.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 11/9/25.
//

import UIKit

class VietnameseLunar: NSObject {
    let JD_JAN_1_1970_0000GMT = 2440587.5
    
    let firstValidDayComponents: DateComponents = DateComponents(year: 1800, month: 1, day: 25)
    let lastValidDayComponents: DateComponents = DateComponents(year: 2199, month: 12, day: 31)
    
    private var _firstValidJD: Double?
    var firstValidJD: Double {
        if (_firstValidJD == nil) {
            _firstValidJD = jdn(day: firstValidDayComponents.day!, month: firstValidDayComponents.month!, year: firstValidDayComponents.year!)
        }
        return _firstValidJD!
    }
    
    private var _lastValidJD: Double?
    var lastValidJD: Double {
        if (_lastValidJD == nil) {
            _lastValidJD = jdn(day: lastValidDayComponents.day!, month: lastValidDayComponents.month!, year: lastValidDayComponents.year!)
        }
        return _lastValidJD!
    }
    
    // MARK: - Decode/convert methods
    
    // Chỉ quan tâm (dd, MM, yyyy)
    // Không quan tâm timezone (lấy timezone GMT+0)
    func jdn(components: DateComponents) -> Double {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = calendar.date(from: components)!
        return JD_JAN_1_1970_0000GMT + date.timeIntervalSince1970 / 86400.0
    }
    
    // (Lấy GMT+0 làm gốc)
    func jdn(day: Int, month: Int, year: Int) -> Double {
        let comps = DateComponents(year: year, month: month, day: day)
        return jdn(components: comps)
    }
    
    // Lấy timzone hiện tại của device, để tính đúng giá trị (dd, MM, yyyy) của ngày tính theo device
    // -> Để làm tham số tính julius
    func jdn(date: Date) -> Double {
        let calendar = Calendar.current // Lấy canlendar hiện tại của device để trích xuất đúng (dd, MM, yyyy)
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        return jdn(components: comps)
    }
    
    // Chỉ quan tâm trả về giá trị (dd, MM, yyyy)
    // Không quan tâm timezone của device (lấy GMT+0 làm gốc)
    func jdToDateComponents(jd: Double) -> DateComponents {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = Date(timeIntervalSince1970: (jd - JD_JAN_1_1970_0000GMT) * 86400.0)
        return calendar.dateComponents([.year, .month, .day], from: date)
    }
    
    // Trả về (dd, MM, yyyy) được tính toán từ julius (không tính timezone, lấy GMT+0 làm gốc),
    // sau đó trả về Date có tính theo timezone của devie
    // -> Để trả về ngày có thể hiển thị đúng (dd, MM, yyyy) trên device
    func jdToDate(_ jd: Double) -> Date {
        let comps = jdToDateComponents(jd: jd)
        let calendar = Calendar.current
        return calendar.date(from: comps)!
    }
    
    // MARK: -
    
    // Lấy tham số cho năm âm lịch được chọn
    func getYearParameter(_ year: Int) -> Int {
        if (year < firstValidDayComponents.year!) || (year > lastValidDayComponents.year!) {
            return 0
        }
        
        if (year < 1900) {
            return YearParameter.TK19[year - 1800]
        } else if (year < 2000) {
            return YearParameter.TK20[year - 1900]
        } else if (year < 2100) {
            return YearParameter.TK21[year - 2000]
        } else if (year < 2200) {
            return YearParameter.TK22[year - 2100]
        }
        return 0
    }
    
    // Trả về 12 objects (hoặc 13 objects nếu là năm âm lịch nhuận)
    // Mỗi object là 1 LunarMonth, chỉ chứa ngày đầu tiên của tháng
    // (là ngày mùng 1 âm lịch của tháng)
    func decodeLunarYear(year: Int, parameter: Int) -> [LunarMonth] {
        var ly: [LunarMonth] = []
        let monthLengths: [Int] = [29, 30]
        var regularMonths: [Int] = Array(repeating: 0, count: 12)
        let offsetOfTet: Int = parameter >> 17
        let leapMonth: Int = parameter & 0xf
        let leapMonthLength: Int = monthLengths[parameter >> 16 & 0x1]
        let solarNY = jdn(day: 1, month: 1, year: year)
        var currentJD = solarNY + Double(offsetOfTet)
        var j: Int = parameter >> 4
        
        for i in 0..<12 {
            regularMonths[12 - i - 1] = monthLengths[j & 0x1]
            j >>= 1
        }
        if leapMonth == 0 {
            // Nếu năm thường ko phải năm nhuận, có 12 tháng
            for mm in 1...12 {
                let lunarDate = LunarDate()
                lunarDate.day = 1
                lunarDate.month = mm
                lunarDate.year = year
                lunarDate.julius = currentJD
                let lunarMonth = LunarMonth(fisrtDay: lunarDate, monthLength: regularMonths[mm - 1])
                ly.append(lunarMonth)
                currentJD += Double(regularMonths[mm - 1])
            }
        } else {
            // Nếu năm nhuận, có 13 tháng
            for mm in 1...leapMonth {
                let lunarDate = LunarDate()
                lunarDate.day = 1
                lunarDate.month = mm
                lunarDate.year = year
                lunarDate.julius = currentJD
                let lunarMonth = LunarMonth(fisrtDay: lunarDate, monthLength: regularMonths[mm - 1])
                ly.append(lunarMonth)
                currentJD += Double(regularMonths[mm - 1])
            }
            
            // Chèn tháng nhuận
            let lunarDateLeap = LunarDate()
            lunarDateLeap.day = 1
            lunarDateLeap.month = leapMonth
            lunarDateLeap.leapMonth = true
            lunarDateLeap.year = year
            lunarDateLeap.julius = currentJD
            let lunarMonthLeap = LunarMonth(fisrtDay: lunarDateLeap, monthLength: leapMonthLength)
            ly.append(lunarMonthLeap)
            currentJD += Double(leapMonthLength)
            
            for mm in (leapMonth + 1)...12 {
                let lunarDate = LunarDate()
                lunarDate.day = 1
                lunarDate.month = mm
                lunarDate.year = year
                lunarDate.julius = currentJD
                let lunarMonth = LunarMonth(fisrtDay: lunarDate, monthLength: regularMonths[mm - 1])
                ly.append(lunarMonth)
                currentJD += Double(regularMonths[mm - 1])
            }
        }
        
        return ly
    }
    
    // Tìm và trả về LunarDate (ngày âm lịch được convert thành công) từ ngày julius
    // Nếu ngày nằm ngoài vùng support (quá lâu hoặc quá xa), trả về nil
    func findLunarDate(jd: Double, firstMonthLunarDates: [LunarDate]) -> LunarDate? {
        if (jd < firstValidJD) || (jd > lastValidJD) || (firstMonthLunarDates[0].julius > jd) {
            return nil
        }
        var i = firstMonthLunarDates.count - 1
        while (i >= 0) {
            if (firstMonthLunarDates[i].julius <= jd) {
                break
            }
            i -= 1
        }
        let off = jd - firstMonthLunarDates[i].julius
        
        let ret = LunarDate()
        ret.day = firstMonthLunarDates[i].day + Int(floor(off))
        ret.month = firstMonthLunarDates[i].month
        ret.year = firstMonthLunarDates[i].year
        ret.leapMonth = firstMonthLunarDates[i].leapMonth
        ret.julius = jd
        
        return ret
    }
    
    // Trả về object kiểu LunarMonth, chỉ chứa ngày đầu tiên (ngày mùng 1 của tháng)
    // Nếu tháng không hợp lệ (tháng nhuận không tồn tại), trả về nil
    func getLunarMonth(month: Int, year: Int, isLeapMonth: Bool = false) -> LunarMonth? {
        let parameter = getYearParameter(year)
        let leapMonthNumber: Int = parameter & 0xf
        if (isLeapMonth && (leapMonthNumber != month)) {
            return nil
        }
        
        let months = decodeLunarYear(year: year, parameter: parameter)
        var monthIndex: Int = month - 1
        if leapMonthNumber > 0 {
            if isLeapMonth {
                monthIndex = leapMonthNumber
            } else if month > leapMonthNumber {
                monthIndex += 1
            }
        }
        let lunarMonth = months[monthIndex]
        return lunarMonth
    }
    
    // MARK: - Public methods
    public func convertSolar2Lunar(day: Int, month: Int, year: Int) -> LunarDate? {
        var months = decodeLunarYear(year: year, parameter: getYearParameter(year))
        if months.isEmpty {
            return nil
        }

        let jd = jdn(day: day, month: month, year: year)
        if (jd < months[0].days[0].julius) {
            months = decodeLunarYear(year: year - 1, parameter: getYearParameter(year - 1))
            if months.isEmpty {
                return nil
            }
        }
        
        if let days = months.compactMap({ $0.days[0] }) as? [LunarDate] {
            let lunar = findLunarDate(jd: jd, firstMonthLunarDates: days)
            return lunar
        }
        return nil
    }

    public func convertSolar2Lunar(solarDate: Date) -> LunarDate? {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.day, .month, .year], from: solarDate)
        guard let day = comps.day, let month = comps.month, let year = comps.year else {
            return nil
        }
        return convertSolar2Lunar(day: day, month: month, year: year)
    }
    
    // MARK: -
    public func convertLunar2SolarComponents(lunarDate: LunarDate) -> DateComponents? {
        guard let lunarMonth = getLunarMonth(month: lunarDate.month, year: lunarDate.year, isLeapMonth: lunarDate.leapMonth) else {
            return nil
        }
        if lunarDate.day > lunarMonth.monthLength {
            return nil
        }
        let jd = lunarMonth.days[0].julius + Double(lunarDate.day - 1)
        let comps = jdToDateComponents(jd: jd)
        return comps
    }
    
    public func convertLunar2Solar(lunarDate: LunarDate) -> Date? {
        guard let comps = convertLunar2SolarComponents(lunarDate: lunarDate) else {
            return nil
        }
        let calendar = Calendar.current
        return calendar.date(from: comps)!
    }
}
