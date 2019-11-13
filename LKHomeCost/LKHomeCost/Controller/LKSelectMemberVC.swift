//
//  LKSelectMemberVC.swift
//  LKHomeCost
//
//  Created by Lalji on 25/09/19.
//  Copyright © 2019 Lalji. All rights reserved.
//

import UIKit
import CoreData
typealias LKSelectMemberVCCompletionBlock = (Member) -> Void
class LKSelectMemberVC: UIViewController {
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var tblMemberList: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var mainMOC : NSManagedObjectContext = DBManager.shared.managedObjectContext
    var completionBlock:LKSelectMemberVCCompletionBlock?
    
    var selectedMember : Member?
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadFetchRequestData()
        btnSelect.isEnabled = (selectedMember != nil)
        // Do any additional setup after loading the view.
    }
    @IBAction func btnSelectDataTapped(_ sender: Any) {
        if let response = completionBlock {
            response(selectedMember!)
        }
        btnBackTapped(sender)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func reloadFetchRequestData(){
        if txtSearch.text!.count > 0 {
            memberListRC.fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", txtSearch.text!,txtSearch.text! )
        }
        do {
            try memberListRC.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        tblMemberList.reloadData()
    }
    
    /// transaction list result controller
    fileprivate lazy var memberListRC: NSFetchedResultsController<Member> = {
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        var entity = NSEntityDescription.entity(forEntityName: "Member", in: mainMOC)
        fetchRequest.entity = entity
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainMOC, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController as! NSFetchedResultsController<Member>
    }()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddMember" {
            let mocPrivate = DBUpdateManager.createPrivateMOC(mainMOC)
            let objMember:Member = DBUpdateManager.insertData(entityName: "Member", withMOC: mocPrivate) as! Member
            let destination = segue.destination as! LKAddMemberVC
            destination.moc = mocPrivate
            destination.objMember = mocPrivate.object(with: objMember.objectID) as? Member
        }
    }
}
extension LKSelectMemberVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        reloadFetchRequestData()
    }
}
extension LKSelectMemberVC: UITableViewDelegate,UITableViewDataSource {
    /// number of row for section
    ///
    /// - Parameters:
    ///   - tableView: department list table view
    ///   - section: section
    /// - Returns: number of row in given section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = memberListRC.sections
        let sectionInfo = sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    /// configure department list cell
    ///
    /// - Parameters:
    ///   - tableView: department list table view
    ///   - indexPath: index path
    /// - Returns: department display cell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LKSelectMemberCell
        cell.configureCell(withMember: memberListRC.object(at: indexPath))
        return cell
    }
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMember = memberListRC.object(at: indexPath)
        btnSelect.isEnabled = true
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
}
extension LKSelectMemberVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblMemberList.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tblMemberList.insertRows(at: [indexPath], with: .automatic)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tblMemberList.deleteRows(at: [indexPath], with: .automatic)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                tblMemberList.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case .move:
            if let newIndexPath = newIndexPath {
                if let indexPath = indexPath {
                    tblMemberList.deleteRows(at: [indexPath], with: .automatic)
                    tblMemberList.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
            break;
        default: break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblMemberList.endUpdates()
    }
}
class LKSelectMemberCell: UITableViewCell {
    @IBOutlet weak var lblMemaberName: UILabel?
    @IBOutlet weak var lblMemaberNO: UILabel?
    @IBOutlet weak var lblMemaberEmail: UILabel?
    func configureCell(withMember member:Member) {
        lblMemaberName?.text = member.name
        lblMemaberNO?.text = member.mobileNo
        lblMemaberEmail?.text = member.email
    }
}

