//
//  LKAddUpdateTranVC.swift
//  LKHomeCost
//
//  Created by Lalji on 24/09/19.
//  Copyright © 2019 Lalji. All rights reserved.
//

import UIKit
import CoreData

class LKAddUpdateTranVC: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var segPaymentType: UISegmentedControl!
    @IBOutlet weak var btnDateInput: UIButton!
    @IBOutlet weak var btnMemberSelect: UIButton!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnSaveData: UIButton!
    public var objTransection:Transection!
    public var privateMOC:NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 38.0/255, green: 186.0/255, blue: 72.0/255, alpha: 1)], for: .normal)
        if objTransection.isCredit {
            lblTitle.text = "Income"
        }
        else {
            lblTitle.text = "Expense"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    func updateView() {
        txtMessage.text = objTransection.message
        txtAmount.text = String(objTransection.amount)
        if let member = objTransection.member {
            btnMemberSelect.setTitle(member.name, for: .normal)
        }
        else{
            btnMemberSelect.setTitle("Select Member", for: .normal)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        btnDateInput.setTitle(dateFormatter.string(from: objTransection.dateTran!), for: .normal)
        updateSaveButton()
    }
    @IBAction func payMentTypeSelectionChanged(_ sender: UISegmentedControl) {
        objTransection.pyamentType = Int64(sender.selectedSegmentIndex)
    }
    func updateSaveButton() {
        btnSaveData.isEnabled = objTransection.message!.count > 0 && objTransection.member != nil && objTransection.amount > 0
    }
    @IBAction func btnSaveDataTapped(_ sender: Any) {
        DBUpdateManager.linkTransectionWithDateComponents(objTransection, withMOC: privateMOC)
        DBUpdateManager.saveMOC(privateMOC)
        btnBackTapped(sender)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectMember" {
            let destination = segue.destination as! LKSelectMemberVC
            destination.completionBlock = { member in
                let objectID = member.objectID
                self.objTransection.member = (self.privateMOC.object(with: objectID) as! Member)
                self.updateSaveButton()
            }
        }
    }
}
extension LKAddUpdateTranVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            objTransection.message = textField.text
        }
        else if textField.tag == 2 {
            objTransection.amount = (textField.text! as NSString).floatValue
        }
        updateView()
    }
}
