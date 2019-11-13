//
//  LKAddMemberVC.swift
//  LKHomeCost
//
//  Created by Lalji on 25/09/19.
//  Copyright © 2019 Lalji. All rights reserved.
//

import UIKit
import CoreData

class LKAddMemberVC: UIViewController {

    @IBOutlet weak var txtMemberName: UITextField!
    @IBOutlet weak var txtMoNumber: UITextField!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var btnSaveData: UIButton!
    @IBOutlet weak var segIsActive: UISegmentedControl!
    
    public var objMember:Member!
    public var moc:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    func updateView() {
        segIsActive.selectedSegmentIndex = NSNumber(value: objMember.isActive).intValue
        txtMemberName.text = objMember.name
        txtMoNumber.text = objMember.mobileNo
        txtEmailID.text = objMember.email
        updateSaveButton()
    }
    func updateSaveButton() {
        btnSaveData.isEnabled = objMember.name!.count > 0 && (objMember.mobileNo!.count > 0 || objMember.email!.count > 0)
    }
    @IBAction func memberActiveStatusChanged(_ sender: UISegmentedControl) {
    }
    @IBAction func btnSaveDataTapped(_ sender: Any) {
        DBUpdateManager.saveMOC(moc)
        btnBackTapped(sender)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension LKAddMemberVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            objMember.name = textField.text
        }
        else if textField.tag == 2 {
            objMember.mobileNo = textField.text
        }
        else if textField.tag == 3 {
            objMember.email = textField.text
        }
        updateView()
    }
}
