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
    
    // MARK: - Variables
    
    // System
    @NSManaged var date_created: String?
    @NSManaged var date_modified: String?
    @NSManaged var device_name: String?
    
    // Test Details
    @NSManaged var test_id: String?
    @NSManaged var test_date: String?
    @NSManaged var test_location: String?
    @NSManaged var test_type: String?
    @NSManaged var test_visitnext: String?
    
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
    
    
    var _baseline_test:Test?
    var baseline_test:Test? {
        get {
            if(_baseline_test == nil) {
                if(self.patient_id != nil && self.test_date != nil) {
                    print("Looking up Baseline test for patient id = \(self.patient_id!)")
                    let context = self.managedObjectContext!
                    let fetchRequest = NSFetchRequest(entityName:"Test")
                    let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
                    let predicate = NSPredicate(format: "patient_id == %@ && test_type == \"0\" && test_date < %@", argumentArray: [self.patient_id!, self.test_date!])
                    fetchRequest.sortDescriptors = [sortDescriptor]
                    fetchRequest.predicate = predicate
                    
                    // Execute the fetch request
                    do {
                        let results = try context.executeFetchRequest(fetchRequest) as! [Test]
                        _baseline_test = results.first
                    } catch let error as NSError {
                        print("Fetch failed: \(error.localizedDescription)")
                    }
                }
            }
            return _baseline_test
        }
    }
    
    
    // MARK: - Enums
    
    enum OutcomeHearingLoss {
        case No
        case Yes
    }
    enum OutcomeHearingLossAG {
        case No
        case Yes
    }
    enum OutcomePlan {
        case Other
        case StopDose
        case ChangeDose
        case FollowUp2Weeks
        case FollowUp4Weeks
        case Expired
    }
    
    // MARK: - Lazy Variables
    
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
    
    
    
    // MARK: - Functions
    
    func getString(field: String) -> String? {
        if let value = self.valueForKey(field) as? String {
            return value
        }
        return nil
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
        if(Int(self.patient_age ?? "") < 18) {
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
    
    func getLocation() -> String {
        return self.getOption("locations",index:self.test_location)
    }
    
    func getType() -> String {
        return self.getOption("types",index:self.test_type)
    }

    func toCSVString(seperator: String = ",") -> String {
        let array = self.toStringDict().values
        return array.joinWithSeparator(seperator)
    }
    
    func toStringDict() -> [String:String] {
        var dict = [String:String]()
        let attributes = self.entity.attributesByName
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
                if let indexInt = Int(index ?? "") {
                    if indexInt >= 0 {
                        return list[indexInt]
                    }
                }
            }
        }
        return ""
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
    
    func saveTestContext() {
        if let moc = self.managedObjectContext {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                let start = NSDate()
                var error: NSError? = nil
                if moc.hasChanges {
                    print("saving context with \(moc.registeredObjects.count) objects")
                    do {
                        try moc.save()
                    } catch let error1 as NSError {
                        error = error1
                        print("Unresolved error \(error), \(error!.userInfo)")
                    } catch {
                        fatalError()
                    }
                }
                let timeInterval = -start.timeIntervalSinceNow
                print("saving context took :: \(timeInterval)")
                return
            })
        }
    }
    
    // MARK: - Class Functions
    
    class func newTest(context : NSManagedObjectContext, patientId: String) -> Test {
        let test = NSEntityDescription.insertNewObjectForEntityForName("Test", inManagedObjectContext: context) as! Test
        let now = NSDate()
        test.device_name = UIDevice.currentDevice().name
        test.date_created = Test.getStringFromDate(now, includeTime: true)
        test.date_modified = Test.getStringFromDate(now, includeTime: true)
        test.test_date = Test.getStringFromDate(now, includeTime: true)
        test.patient_id = patientId
        test.test_id = Test.getNextTestId(context, patientId: patientId)
        test.test_type = "0"
        
        let settings = NSUserDefaults()
        if let defaultLocationSetting = settings.stringForKey("default_location") {
            print("defaultLocationSetting = \(defaultLocationSetting)")
            test.test_location = defaultLocationSetting
        }
        
        // get patient and baseline data from previous baseline test
        test._baseline_test = nil
        if let baselinetest = test.baseline_test {
            test.test_type = "1"
            test.patient_dob = baselinetest.patient_dob
            test.patient_age = baselinetest.patient_age
            test.patient_gender = baselinetest.patient_gender
            test.patient_consent = baselinetest.patient_consent
            
            test.baseline_creatinine = baselinetest.baseline_creatinine
            test.baseline_ag_start_date = baselinetest.baseline_ag_start_date
            test.baseline_streptomycin = baselinetest.baseline_streptomycin
            test.baseline_capreomycin = baselinetest.baseline_capreomycin
            test.baseline_kanamicin = baselinetest.baseline_kanamicin
            test.baseline_amikacin = baselinetest.baseline_amikacin
            test.baseline_ag_dose_gt_3 = baselinetest.baseline_ag_dose_gt_3
        }
        return test
    }
    
    class func getNextTestId(context: NSManagedObjectContext, patientId: String) -> String {
        var newTestId = 0
        let fr = NSFetchRequest(entityName: "Test")
        let sd = NSSortDescriptor(key: "test_id", ascending: false)
        fr.sortDescriptors = [sd]
        let predicate = NSPredicate(format: "patient_id == %@",argumentArray: [patientId])
        fr.predicate = predicate
        
        do {
            if let tests = try context.executeFetchRequest(fr) as? [Test] {
                if let test = tests.first {
                    if let a = test.test_id?.componentsSeparatedByString("-").last {
                        if let b = Int(a) {
                            newTestId = b + 1
                        }
                    }
                }
            }
            
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.minimumIntegerDigits = 2
        
        return "\(patientId)-\(numberFormatter.stringFromNumber(newTestId)!)"
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
    
    class func csvHeaders(entity: NSEntityDescription) -> [String]? {
        let attributes = entity.attributesByName
        var headers = [String]()
        for a in attributes {
            headers.append(a.1.name)
        }
        let sortedHeaders = headers.sort {$0 < $1}
        return sortedHeaders
    }
    
    class func deleteTest(test: Test) {
        if let context = test.managedObjectContext {
            context.deleteObject(test)
            test.saveTestContext()
        }
    }
    
    class func getChartTestsForPatient(context: NSManagedObjectContext, patientId: String, limit: Int) -> [Test]? {
        let fr = NSFetchRequest(entityName: "Test")
        let sd = NSSortDescriptor(key: "test_id", ascending: true)
        fr.sortDescriptors = [sd]
        let predicate = NSPredicate(format: "patient_id == %@",argumentArray: [patientId])
        fr.predicate = predicate
        
        do {
            if var alltests = try context.executeFetchRequest(fr) as? [Test] {
                if alltests.count > limit {
                    let i = alltests.count - limit + 1
                    let rangeToRemove = (1..<i)
                    alltests.removeRange(rangeToRemove)
                }
                return alltests
                
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return nil
        }
    }
    
    class func risk_lost_followup(patientid: String?) -> Bool {
        if let _patientid = patientid {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext!
            
            let fetchRequest = NSFetchRequest(entityName:"Test")
            let predicate = NSPredicate(format: "patient_id == %@", argumentArray: [_patientid])
            fetchRequest.predicate = predicate
            let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchLimit = 1
            
            do {
                let data = try context.executeFetchRequest(fetchRequest)
                if let test = data.first as? Test {
                    if let lasttestdate = test.getDate("test_date") {
                        // compare testdate to current date
                        
                        let calendar = NSCalendar.currentCalendar()
                        let components = calendar.components([.Month], fromDate: lasttestdate, toDate: NSDate(), options: [])
                        
                        let months = components.month

                        if months > 2 {
                            //print("#\(_patientid) at risk, last visit \(lasttestdate)")
                            return true
                        }
                        return false
                    }
                }
            } catch {
                print("error fetching grouped data")
            }
            
        }
        
        return false
    }
}
