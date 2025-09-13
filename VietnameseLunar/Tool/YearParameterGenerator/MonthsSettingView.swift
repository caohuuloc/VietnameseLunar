//
//  MonthsSettingView.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 12/9/25.
//

import UIKit

class MonthsSettingView: UIView, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    
    var months: [LunarMonth] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        tableView = UITableView(frame: bounds, style: .plain)
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let nib = UINib(nibName: "MonthSettingCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MonthSettingCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
    }
    
    // MARK: -
    func loadMonths(_ months: [LunarMonth]) {
        self.months = months
        tableView.reloadData()
    }
    
    // MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthSettingCell", for: indexPath) as! MonthSettingCell
        cell.loadData(months[indexPath.row])
        return cell
    }
}
