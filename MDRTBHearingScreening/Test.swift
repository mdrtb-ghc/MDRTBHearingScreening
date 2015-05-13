//
//  Test.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 3/31/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Test)
class Test: NSManagedObject {

    // get string equivalents from propeties file
    lazy var customAppProperties : NSDictionary = {
        let customPlistUrl = NSBundle.mainBundle().URLForResource("MDRTBHearingScreening", withExtension: "plist")!
        return NSDictionary(contentsOfURL: customPlistUrl)!
    }()
    
    lazy var dateFormatter : NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm.ss z"
        return formatter
    }()
    
    
    lazy var baseline_test : Test? = {
        if(self.patient_id != nil && self.test_date != nil) {
            println("Looking up Baseline test for patient id = \(self.patient_id!)")
            let context = self.managedObjectContext!
            let fetchRequest = NSFetchRequest(entityName:"Test")
            let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
            let predicate = NSPredicate(format: "patient_id == %@ && test_type == \"0\" && test_date < %@", argumentArray: [self.patient_id!, self.test_date!])
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.predicate = predicate
            
            // Execute the fetch request
            var err : NSError?
            if let results = context.executeFetchRequest(fetchRequest, error: &err) as! [Test]? {
                return results.first
            }
        }
        return nil
    }()
    
    class func importFromFile(url: NSURL, context: NSManagedObjectContext?) -> Void {
        // parse file into array dictionary and create Test managed object
        let importedString = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
        var importedArray = [String]()
        
        importedString?.enumerateLinesUsingBlock({ (line,a) -> Void in
            importedArray.append(line)
        })
        
        
        let keyString = importedArray.first
        if keyString != nil {
            if let keys = keyString?.componentsSeparatedByString(",") {
                let importStart = NSDate()
                println("Started importing \(importedArray.count-1) items at \(importStart)")
                for var i = 1; i < importedArray.count; i++ {
                    let valueString = importedArray[i]
                    let values = valueString.componentsSeparatedByString(",")
                    let test = NSEntityDescription.insertNewObjectForEntityForName("Test", inManagedObjectContext: context!) as! Test
                    for var j = 0; j < keys.count; j++ {
                        // assume all imported values are String
                        test.setValue(values[j], forKey: keys[j])
                    }
                }
                let importTimeInterval = importStart.timeIntervalSinceNow
                
                // save context
                println("saving context")
                if let moc = context {
                    var error: NSError? = nil
                    if moc.hasChanges && !moc.save(&error) {
                        NSLog("Unresolved error \(error), \(error!.userInfo)")
                    }
                }
                
                println("Finished importing \(importedArray.count-1) items at \(importTimeInterval)")
                
            }
        }
    }

    
    func getString(field: String) -> String? {
        if let value = self.valueForKey(field) as? String {
            return value
        }
        return nil
    }
    
    class func getStringFromDate(date:NSDate,includeTime:Bool = false) -> String {
        let formatter = NSDateFormatter()
        if includeTime {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        } else {
            formatter.dateFormat = "yyyy-MM-dd"
        }
        return formatter.stringFromDate(date)
    }
    
    func getDate(field: String) -> NSDate? {
        if let value = self.valueForKey(field) as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm.ss z"
            if let date = formatter.dateFromString(value) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd HH:mm z"
            if let date = formatter.dateFromString(value) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let date = formatter.dateFromString(value) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.dateFromString(value) {
                return date
            }
            formatter.dateFormat = "dd/MM/yyyy"
            if let date = formatter.dateFromString(value) {
                return date
            }
            formatter.dateFormat = "MM/dd/yyyy"
            if let date = formatter.dateFromString(value) {
                return date
            }
            return nil
        }
        return nil
    }
    
    func isEligible() -> String {
        if(self.patient_age?.toInt() < 18) {
            return "No"
        }
        if(self.baseline_ag_dose_gt_3 == "1") {
            return "No"
        }
        if(self.patient_consent == "0") {
            return "No"
        }
        return "Yes"
    }
    
    func hasConsent() -> String {
        if(self.patient_consent == "1") {
            return "Yes"
        }
        return "No"
    }
    
    class func csvHeaders(entity: NSEntityDescription) -> [String]? {
        if let attributes = entity.attributesByName as? [NSObject:NSAttributeDescription] {
            var headers = [String]()
            for a in attributes {
                headers.append(a.1.name)
            }
            let sortedHeaders = sorted(headers) {$0 < $1}
            return sortedHeaders
        }
        return nil
    }
    
    func toCSVString(seperator: String = ",") -> String {
        return seperator.join(self.toStringDict().values.array)
    }
    
    func toStringValueArray() -> [String] {
        return self.toStringDict().values.array
    }
    
    func toStringDict() -> [String:String] {
        var dict = [String:String]()
        let attributes = self.entity.attributesByName as! [NSObject:NSAttributeDescription]
        for a in attributes {
            let value = self.toStringValue(a.1)
            dict[a.1.name] = value
        }
        return dict
    }
    
    func toStringValue(attribute: NSAttributeDescription) -> String {
        return self.valueForKey(attribute.name)?.description ?? ""
    }
    
    func getOption(listName:String,index:String?) -> String {
        if index != nil && index != ""{
            if let list = customAppProperties[listName] as? [String:String] {
                return list[index!] ?? ""
            } else if let list = customAppProperties[listName] as? [String] {
                if let indexInt = index?.toInt() {
                    if indexInt >= 0 {
                        return list[indexInt]
                    }
                }
            }
        }
        return ""
    }
    
    func getLocation() -> String {
        return self.getOption("locations",index:self.test_location)
    }
    func getType() -> String {
        return self.getOption("types",index:self.test_type)
    }
    
    func mediumDateString(date: NSDate?) -> String {
        if (date != nil) {
            // format date for display
            let formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            return formatter.stringFromDate(date!)
        }
        return ""
    }
    
    func mediumTimeString(date: NSDate?) -> String {
        if (date != nil) {
            let formatter: NSDateFormatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            return formatter.stringFromDate(date!)
        }
        return ""
    }
    
    func stringFromIndex(index: NSNumber?,strings: [String]) -> String {
        if let index = index as? Int {
            if (index >= 0 && index < strings.count) {
                return strings[index]
            }
        }
        return ""
    }
    
    // System
    @NSManaged var date_created: String?
    @NSManaged var date_modified: String?
    @NSManaged var device_name: String?
    
    // Test Details
    @NSManaged var test_id: String?
    @NSManaged var test_date: String?
    @NSManaged var test_location: String?
    @NSManaged var test_type: String?
    
    // Patient Details
    @NSManaged var patient_id: String?
    @NSManaged var patient_age: String?
    @NSManaged var patient_dob: String?
    @NSManaged var patient_gender: String?
    @NSManaged var patient_consent: String?
    @NSManaged var patient_eligible: String?
    
    // History Data
    @NSManaged var history: String?
    @NSManaged var history_ear: String?
    @NSManaged var history_timing: String?
    @NSManaged var history_ringing: String?
    
    // Baseline Data
    @NSManaged var baseline_creatinine: String?
    @NSManaged var baseline_ag_start_date: String?
    @NSManaged var baseline_streptomycin: String?
    @NSManaged var baseline_capreomycin: String?
    @NSManaged var baseline_kanamicin: String?
    @NSManaged var baseline_amikacin: String?
    @NSManaged var baseline_ag_dose_gt_3: String?
    
    // Monthly Data
    @NSManaged var monthly_ag_dose: String?
    @NSManaged var monthly_ag_frequency: String?
    @NSManaged var monthly_ag_type: String?
    @NSManaged var monthly_creatinine_level: String?
    @NSManaged var monthly_furosemide: String?
    
    @NSManaged var left_normal: String?
    @NSManaged var left_wax: String?
    @NSManaged var left_infection: String?
    @NSManaged var left_perforated: String?
    @NSManaged var left_fluid: String?
    @NSManaged var left_notes: String?
    
    @NSManaged var right_normal: String?
    @NSManaged var right_wax: String?
    @NSManaged var right_infection: String?
    @NSManaged var right_perforated: String?
    @NSManaged var right_fluid: String?
    @NSManaged var right_notes: String?
    
    @NSManaged var left_125: String?
    @NSManaged var left_250: String?
    @NSManaged var left_500: String?
    @NSManaged var left_1000: String?
    @NSManaged var left_2000: String?
    @NSManaged var left_4000: String?
    @NSManaged var left_8000: String?
    
    @NSManaged var right_125: String?
    @NSManaged var right_250: String?
    @NSManaged var right_500: String?
    @NSManaged var right_1000: String?
    @NSManaged var right_2000: String?
    @NSManaged var right_4000: String?
    @NSManaged var right_8000: String?
    
    @NSManaged var outcome_hearingloss: String?
    @NSManaged var outcome_hearingloss_ag: String?
    @NSManaged var outcome_plan: String?
    @NSManaged var outcome_comments: String?
    

    class func newTest(context : NSManagedObjectContext, patientId: String) -> Test {
        let test = NSEntityDescription.insertNewObjectForEntityForName("Test", inManagedObjectContext: context) as! Test
        let now = NSDate()
        test.device_name = UIDevice.currentDevice().name
        test.date_created = Test.getStringFromDate(now, includeTime: true)
        test.date_modified = Test.getStringFromDate(now, includeTime: true)
        test.test_date = Test.getStringFromDate(now, includeTime: true)
        test.patient_id = patientId
        test.test_id = Test.getNextTestId(context, patientId: patientId)
        
        // get patient and baseline data from previous baseline test
        if let baselinetest = test.baseline_test {
            test.patient_dob = baselinetest.patient_dob
            test.patient_age = baselinetest.patient_age
            test.patient_gender = baselinetest.patient_gender
            test.patient_consent = baselinetest.patient_consent
            test.patient_eligible = baselinetest.patient_eligible
            
            test.baseline_creatinine = baselinetest.baseline_creatinine
            test.baseline_ag_start_date = baselinetest.baseline_ag_start_date
            test.baseline_streptomycin = baselinetest.baseline_streptomycin
            test.baseline_capreomycin = baselinetest.baseline_capreomycin
            test.baseline_kanamicin = baselinetest.baseline_kanamicin
            test.baseline_amikacin = baselinetest.baseline_amikacin
            test.baseline_ag_dose_gt_3 = baselinetest.baseline_ag_dose_gt_3
        }
    
        var err: NSError?
        if !context.save(&err) {
            println("Could not save \(err), \(err?.userInfo)")
        }
        
        return test
     }
    
    class func deleteTest(test: Test) {
        if let context = test.managedObjectContext {
            context.deleteObject(test)
            
            var err: NSError?
            if !context.save(&err) {
                println("Could not delete \(err), \(err?.userInfo)")
            }
        }
    }
    
    class func getNextTestId(context: NSManagedObjectContext, patientId: String) -> String {
        
        var newTestId = 0
        let fr = NSFetchRequest(entityName: "Test")
        let sd = NSSortDescriptor(key: "test_id", ascending: false)
        fr.sortDescriptors = [sd]
        let predicate = NSPredicate(format: "patient_id == %@",argumentArray: [patientId])
        fr.predicate = predicate
        
        var err: NSError?
        if let tests = context.executeFetchRequest(fr, error: &err) as? [Test] {
            if let test = tests.first {
                newTestId = (test.test_id?.componentsSeparatedByString("-").last?.toInt() ?? -1) + 1
            }
        }
        let numberFormatter = NSNumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        
        return "\(patientId)-\(numberFormatter.stringFromNumber(newTestId)!)"
    }
    
    func saveTestContext() {
        if let moc = self.managedObjectContext {
            moc.performBlock({ () -> Void in
                let start = NSDate()
                println("saving context with \(moc.registeredObjects.count) objects")
                var error: NSError? = nil
                if moc.hasChanges && !moc.save(&error) {
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                }
                let timeInterval = -start.timeIntervalSinceNow
                println("saving context took :: \(timeInterval)")
            })
        }
    }

    class func exportAllTests(progressView: UIProgressView) -> NSURL?{
        return exportTests(studyOnly: false,progressView: progressView)
    }
    class func exportStudyTests(progressView: UIProgressView) -> NSURL? {
        return exportTests(studyOnly: true,progressView: progressView)
    }
    
    class private func exportTests(studyOnly: Bool = false,progressView: UIProgressView) -> NSURL? {
        let start = NSDate()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext!
        let exportDateString = Test.getStringFromDate(start, includeTime: true)
        let exportFileUrl = appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent("export-\(exportDateString).csv")
        
        // create fetchrequest
        let fr = NSFetchRequest(entityName: "Test")
        let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
        fr.sortDescriptors = [sortDescriptor]
        if studyOnly {
            let predicate = NSPredicate(format: "patient_consent == \"1\"", argumentArray: nil)
            fr.predicate = predicate
        }
        
        if let tests = moc.executeFetchRequest(fr, error: nil) as? [Test] {
            var csvString = NSMutableString()
            
            if let entity = NSEntityDescription.entityForName("Test", inManagedObjectContext: moc) {
                if let headers = Test.csvHeaders(entity) {
                    csvString.appendString(",".join(headers)+"\n")
                    var count = 0
                    for t in tests {
                        count++
                        let percentDone = (count*100)/tests.count
                        //progressindicator.setProgress(Float(percentDone), animated: true)
                        var values = [String]()
                        for h in headers {
                            values.append(t.valueForKey(h)?.description ?? "")
                        }
                        csvString.appendString(",".join(values)+"\n")
                    }
                }
            }
            
            var error: NSError?
            csvString.writeToURL(exportFileUrl, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
            let timeInterval = -start.timeIntervalSinceNow
            println("export completed. Time inteval :: \(timeInterval)")
            return exportFileUrl
        }
        return nil
    }
}
