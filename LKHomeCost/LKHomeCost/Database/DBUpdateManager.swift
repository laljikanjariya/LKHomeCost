//
//  DMUpdateManager.swift
//  LKHomeCost
//
//  Created by Lalji on 23/09/19.
//  Copyright © 2019 Lalji. All rights reserved.
//

import UIKit
import CoreData
struct DateCompData {
    var day: Int!
    var month: Int!
    var year: Int!
}
class DBUpdateManager: NSObject {
    
    class func createPrivateMOC(_ moc:NSManagedObjectContext) -> NSManagedObjectContext{
        let privateMOC : NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = moc;
        return privateMOC
    }
    class func saveMOC(_ moc:NSManagedObjectContext?) {
        if let saveMOC = moc {
            if saveMOC.parent == nil {
                saveMOC.perform {
                    save(Context: saveMOC)
                }
            }
            else{
                saveMOC.performAndWait {
                    save(Context: saveMOC)
                }
            }
        }
    }
    private class func save(Context moc:NSManagedObjectContext) {
        do {
            try moc.save()
        } catch {
        }
        saveMOC(moc.parent)
    }
    class func fetchData(entityName entity:String, requestPredicate predicate:NSPredicate?, withMOC moc:NSManagedObjectContext) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        return fetchData(withFetchRequest: fetchRequest, withMOC: moc) as! [NSManagedObject]
    }
    class func fetchData(withFetchRequest fetchRequest:NSFetchRequest<NSFetchRequestResult>, withMOC moc:NSManagedObjectContext) -> [Any] {
        var result:[Any] = []
        do {
            try result = moc.fetch(fetchRequest)
        } catch {
        }
        return result
    }
    class func insertData(entityName entity:String, withMOC moc:NSManagedObjectContext) -> NSManagedObject!{
        return NSEntityDescription.insertNewObject(forEntityName: entity, into: moc) as NSManagedObject
    }
    
    class func linkTransectionWithDateComponents(_ transection:Transection, withMOC moc:NSManagedObjectContext) {
        
        let dateCom: DateComponents = getTransectionDate(tranDate: transection.dateTran!, withMOC: moc)
        transection.tranDateComp = dateCom;
        dateCom.addToTranDate(transection)
    }
    class func getTransectionDate(tranDate date:Date, withMOC moc:NSManagedObjectContext) -> DateComponents{
        let dateComp = getDateCopmData(fromDate: date)!
        let predicate = NSPredicate(format: "day = %d AND month = %d AND year = %d",dateComp.day,dateComp.month,dateComp.year)

        if let dateCom = fetchData(entityName: "DateComponents", requestPredicate: predicate, withMOC: moc).first as? DateComponents {
            return dateCom
        } else {
            let dateCom = insertData(entityName: "DateComponents", withMOC: moc) as! DateComponents
            dateCom.day = Int64(dateComp.day)
            dateCom.month = Int64(dateComp.month)
            dateCom.year = Int64(dateComp.year)
            return dateCom
        }
    }
    class func getDateCopmData(fromDate date:Date) -> DateCompData!{
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day , .month , .year], from: date)
        return DateCompData(day: components.day!, month: components.month!, year: components.year!)
    }
}
