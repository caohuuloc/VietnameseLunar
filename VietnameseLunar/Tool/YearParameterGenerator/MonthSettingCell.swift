//
//  MonthSettingCell.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 12/9/25.
//

import UIKit

class MonthSettingCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var fullDaysSwitch: UISwitch!
    @IBOutlet var noteFullDaysLabel: UILabel!
    
    var month: LunarMonth?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(_ data: LunarMonth) {
        self.month = data
        
        let fullMonth = (data.monthLength >= 30)
        nameLabel.text = "Tháng \(data.month) (\(data.monthLength) ngày)"
        fullDaysSwitch.isOn = fullMonth
        noteFullDaysLabel.text = fullMonth ? "Đủ" : "Thiếu"
    }
    
    // MARK: -
    @IBAction func switchValueChanged(_ sender: Any) {
        month?.monthLength = fullDaysSwitch.isOn ? 30 : 29
    }
}
