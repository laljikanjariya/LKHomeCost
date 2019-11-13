//
//  LKTimeLineVC.swift
//  LKHomeCost
//
//  Created by Lalji on 23/09/19.
//  Copyright © 2019 Lalji. All rights reserved.
//

import UIKit
import CoreData

class LKTimeLineVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnMenuTapped(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    @IBAction func btnFilterTapped(_ sender: UIButton) {

//        let noAction = LKAlertAction.getAlertActionNormal(title: "No")
//        let deleteAction = LKAlertAction.getAlertActionDelete(title: "Delete") { (UIAlertAction) in
//            print("Delete")
//        }
//        LKAlertAction.showAlert(title: "Testing T", message: "Testing Message", alertAction: [noAction,deleteAction], displayViewController: self)
    }
    //    @IBAction func btnAddIncome(_ sender: Any) {
//
//        DBUpdateManager.addTransection(description: "Lalji", Amount: Int64(10.12), isCreditTran: true, MemberID: 0, tranDate: Date())
//        insertDate("23092019")
//        insertDate("22092019")
//        insertDate("22082019")
//        insertDate("22082018")
//        insertDate("22072018")
//        insertDate("22102018")
//        insertDate("22012018")
//        DBManager.shared.saveContext()
//        fetchData()
//    }
//    func insertDate(_ strDate:String) {
//        DBUpdateManager.getTransectionDate(tranDate: date(FromString: strDate), withMOC: DBManager.shared.managedObjectContext)
//    }
//    func fetchData() {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DateComponents")
//        fetchRequest.resultType = .dictionaryResultType
//        fetchRequest.returnsDistinctResults = true;
//        let sortDescriptorMonth = NSSortDescriptor(key: "month", ascending: true)
//        let sortDescriptorYear = NSSortDescriptor(key: "year", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptorYear,sortDescriptorMonth]
//        fetchRequest.propertiesToFetch = ["month","year"]
//        let data = DBUpdateManager.fetchData(withFetchRequest: fetchRequest, withMOC: DBManager.shared.managedObjectContext)
//        for name in data {
//            print("Hello, \(name)!")
//        }
//    }
//    func date(FromString strDate:String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "ddMMyyyy"
//        dateFormatter.timeZone = NSTimeZone.local
//        return dateFormatter.date(from:strDate)!
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TransactionList" {
            
        }
        else {
            let mocPrivate = DBUpdateManager.createPrivateMOC(DBManager.shared.managedObjectContext)
            let objTransection:Transection = DBUpdateManager.insertData(entityName: "Transection", withMOC: mocPrivate) as! Transection
            let destination = segue.destination as! LKAddUpdateTranVC
            destination.privateMOC = mocPrivate
            destination.objTransection = mocPrivate.object(with: objTransection.objectID) as? Transection
            destination.objTransection.dateTran = Date()
            if segue.identifier == "AddITransaction" {
                objTransection.isCredit = true
            }
            else if segue.identifier == "AddETransaction" {
                objTransection.isCredit = false
            }
        }
    }
    
}
