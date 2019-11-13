//
//  LKSummaryVC.swift
//  LKHomeCost
//
//  Created by Lalji on 23/09/19.
//  Copyright © 2019 Lalji. All rights reserved.
//

import UIKit

class LKSummaryVC: UIViewController {

    @IBOutlet weak var btnToDay: UIButton!
    @IBOutlet weak var btnDay: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var btnCustom: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnMenuTapped(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    @IBAction func btnFilterTypeTapped(_ sender: UIButton) {
        deselectAllFilterButton()
        sender.isSelected = true
    }
    func deselectAllFilterButton() {
        btnToDay.isSelected = false
        btnDay.isSelected = false
        btnMonth.isSelected = false
        btnYear.isSelected = false
        btnCustom.isSelected = false
    }
}
