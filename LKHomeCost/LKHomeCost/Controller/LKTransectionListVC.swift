//
//  LKTransectionListVC.swift
//  LKHomeCost
//
//  Created by Lalji on 24/09/19.
//  Copyright © 2019 Lalji. All rights reserved.
//

import UIKit
import CoreData

class LKTransectionListVC: UIViewController {
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var tblTranList: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var totalView: TotalSummaryV?
    var mainMOC : NSManagedObjectContext = DBManager.shared.managedObjectContext
    
    var filterPredidate:NSPredicate? {
        didSet{
            reloadFetchRequestData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadFetchRequestData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let updateTotal = totalView {

            let incomePredicate = NSPredicate(format: "isCredit = %d", 1)
            let arrayIncome:[Transection] = (transectionListRC.fetchedObjects! as NSArray).filtered(using: incomePredicate) as! [Transection]
            let totalIncome = arrayIncome.reduce(0.0) { $0 + ($1.amount ) }
            
            let expensePredicate = NSPredicate(format: "isCredit = %d", 0)
            let arrayExpense:[Transection] = (transectionListRC.fetchedObjects! as NSArray).filtered(using: expensePredicate) as! [Transection]
            let totalExpense = arrayExpense.reduce(0.0) { $0 + ($1.amount ) }
            
            updateTotal.lblTotalIncome.text = String(format: "%.2f", totalIncome)
            updateTotal.lblTotalExpense.text = String(format: "%.2f", totalExpense)
            updateTotal.lblTotalBalanse.text = String(format: "%.2f", (totalIncome - totalExpense))
        }
    }
    func reloadFetchRequestData(){
        if txtSearch.text!.count > 0 {
            var searchTextPredicates: [NSPredicate] = []
            searchTextPredicates.append(NSPredicate(format: "message contains[cd] %@ OR member.name contains[cd] %@", txtSearch.text!,txtSearch.text! ))
            if let prePredidate = filterPredidate {
                searchTextPredicates.append(prePredidate)
            }
            transectionListRC.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: searchTextPredicates)
        }
        else{
            transectionListRC.fetchRequest.predicate = filterPredidate
        }
        do {
            try transectionListRC.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        tblTranList.reloadData()
    }
    
    /// transaction list result controller
    fileprivate lazy var transectionListRC: NSFetchedResultsController<Transection> = {
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        var entity = NSEntityDescription.entity(forEntityName: "Transection", in: mainMOC)
        fetchRequest.entity = entity
        fetchRequest.predicate = filterPredidate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateTran", ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainMOC, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController as! NSFetchedResultsController<Transection>
    }()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateTransaction" {
            let  cell:LKTransectionListCell = sender as! LKTransectionListCell
            let indexPath:IndexPath = tblTranList.indexPath(for: cell)!
            let objTransection = transectionListRC.object(at: indexPath)
            let mocPrivate = DBUpdateManager.createPrivateMOC(mainMOC)
            let destination = segue.destination as! LKAddUpdateTranVC
            destination.privateMOC = mocPrivate
            destination.objTransection = mocPrivate.object(with: objTransection.objectID) as? Transection
        }
    }
}
extension LKTransectionListVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        reloadFetchRequestData()
    }
}
extension LKTransectionListVC: UITableViewDelegate,UITableViewDataSource {
    
    /// configure department list cell
    ///
    /// - Parameters:
    ///   - tableView: department list table view
    ///   - indexPath: index path
    /// - Returns: department display cell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LKTransectionListCell
        cell.configureCell(withTransection: transectionListRC.object(at: indexPath))
        return cell
    }
    
    /// number of row for section
    ///
    /// - Parameters:
    ///   - tableView: department list table view
    ///   - section: section
    /// - Returns: number of row in given section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = transectionListRC.sections
        let sectionInfo = sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }
}
extension LKTransectionListVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblTranList.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tblTranList.insertRows(at: [indexPath], with: .automatic)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tblTranList.deleteRows(at: [indexPath], with: .automatic)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                tblTranList.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case .move:
            if let newIndexPath = newIndexPath {
                if let indexPath = indexPath {
                    tblTranList.deleteRows(at: [indexPath], with: .automatic)
                    tblTranList.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
            break;
        default: break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblTranList.endUpdates()
    }
}
class LKTransectionListCell: UITableViewCell {
    @IBOutlet weak var lblMemaber: UILabel?
    @IBOutlet weak var lblAmount: UILabel?
    @IBOutlet weak var lblMessage: UILabel?
    @IBOutlet weak var lblDay: UILabel?
    func configureCell(withTransection transection:Transection) {
        lblMemaber?.text = transection.member?.name
        lblAmount?.text = String(format: "%@ - %.2f", transection.pyamentType == 1 ? "BANK" : "CASH",transection.amount)
        lblMessage?.text = transection.message
        self.contentView.backgroundColor = transection.isCredit ? UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.2) : UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.2)
    }
}
class TotalSummaryV: UIView {
    @IBOutlet weak var lblTotalIncome: UILabel!
    @IBOutlet weak var lblTotalExpense: UILabel!
    @IBOutlet weak var lblTotalBalanse: UILabel!
}
