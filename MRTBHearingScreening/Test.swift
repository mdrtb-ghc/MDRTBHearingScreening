//
//  Test.swift
//  MRTBHearingScreening
//
//  Created by Miguel Clark on 3/31/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import Foundation
import CoreData

@objc(Test)
class Test: NSManagedObject {

    // get string equivalents from propeties file
    lazy var customAppProperties : NSDictionary = {
        let customPlistUrl = NSBundle.mainBundle().URLForResource("MRTBHearingScreening", withExtension: "plist")!
        return NSDictionary(contentsOfURL: customPlistUrl)!
    }()
    
    
    class func csvHeaderString(context: NSManagedObjectContext,seperator: String = ",") -> String {
        if let entity = NSEntityDescription.entityForName("Test", inManagedObjectContext: context) {
            let attributes = entity.attributesByName as! [NSObject:NSAttributeDescription]
            var headers = [String]()
            for a in attributes {
                headers.append(a.1.name)
            }
            return seperator.join(headers)
        }
        return ""
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
        if index != nil {
            if let list = customAppProperties[listName] as? NSDictionary {
                return list[index!] as? String ?? ""
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
            //formatter.dateFormat = "yyyy-MM-dd"
            formatter.dateStyle = .MediumStyle
            return formatter.stringFromDate(date!)
        }
        return ""
    }
    
    func mediumTimeString(date: NSDate?) -> String {
        if (date != nil) {
            let formatter: NSDateFormatter = NSDateFormatter()
            //formatter.dateFormat = "h:mm"
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
    
    // Test Details
    @NSManaged var test_id: String?
    @NSManaged var test_date: NSDate?
    @NSManaged var test_location: String?
    @NSManaged var test_type: String?
    
    // Patient Details
    @NSManaged var patient_id: String?
    @NSManaged var patient_age: String?
    @NSManaged var patient_dob: NSDate?
    @NSManaged var patient_gender: String?
    
    // History Data
    @NSManaged var history: String?
    @NSManaged var history_ear: String?
    @NSManaged var history_timing: String?
    @NSManaged var history_ringing: String?
    
    // Baseline Data
    @NSManaged var baseline_creatinine: String?
    @NSManaged var baseline_ag_start_date: NSDate?
    @NSManaged var baseline_streptomycin: String?
    
    // Monthly Data
    @NSManaged var monthly_ag_dose: String?
    @NSManaged var monthly_ag_frequency: String?
    @NSManaged var monthly_ag_level: String?
    @NSManaged var monthly_ag_route: String?
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
    
    @NSManaged var outcome_hearing: String?
    @NSManaged var outcome_recomendation: String?
    @NSManaged var outcome_plan: String?
    @NSManaged var outcome_comment: String?

    class func addTest(context : NSManagedObjectContext) -> Test {
        // TODO : - init test object
        // generate default test id/number
        // select default test type
        
        // generate unique test id
        var nextTestId = Test.getNextUniqueTestId(context)
        
        let test = NSEntityDescription.insertNewObjectForEntityForName("Test", inManagedObjectContext: context) as! Test
        test.test_id = nextTestId
        test.test_date = NSDate()
        
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
    
    class func getNextUniqueTestId(context: NSManagedObjectContext) -> String {
        
        let fr = NSFetchRequest(entityName: "Test")
        let sd = NSSortDescriptor(key: "test_id", ascending: false)
        fr.sortDescriptors = [sd]
        var err: NSError?
        if let tests = context.executeFetchRequest(fr, error: &err) as? [Test] {
            if let test = tests.first {
                println(test.test_id)
                let newTestId = (test.test_id?.toInt() ?? -1) + 1
                return "\(newTestId)"
            }
        }
        return "\(0)"
    }

}
