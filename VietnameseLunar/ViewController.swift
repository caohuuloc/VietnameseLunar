//
//  ViewController.swift
//  VietnameseLunar
//
//  Created by Cao Huu Loc on 11/9/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: -
    @IBAction func onTapSolar2Lunar(_ sender: Any) {
        let vc = Solar2LunarViewController(nibName: "Solar2LunarViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTapLunar2Solar(_ sender: Any) {
        let vc = Lunar2SolarViewController(nibName: "Lunar2SolarViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTapYPGenerator(_ sender: Any) {
        let vc = YPGenViewController(nibName: "YPGenViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}
