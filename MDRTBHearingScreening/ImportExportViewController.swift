//
//  ImportExportViewController.swift
//  MDRTBHearingScreening
//
//  Created by Miguel Clark on 5/10/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit
import CoreData


class ImportExportViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var progresslabel: UILabel!
    @IBOutlet weak var progressindicator: UIProgressView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var cancelbutton: UIButton!
    
    @IBAction func sharebutton_tapped(sender: UIButton) {
        presentSharingView(sender)
    }
    @IBAction func cancelbutton_tapped(sender: UIButton) {
        controllerdDismissed = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    enum Mode {
        case ImportFromCSV
        case ExportAllToCSV
        case ExportStudyOnlyToCSV
    }
    var currentMode: Mode!
    
    var importFileURL: NSURL?
    var exportFileURL: NSURL?
    var controllerdDismissed = false
    
    var documentInteractionController: UIDocumentInteractionController!
    
    func presentSharingView(sender:UIButton) {
        if let url = exportFileURL {
            documentInteractionController = UIDocumentInteractionController(URL: url)
            documentInteractionController.presentOptionsMenuFromRect(CGRect(x: sender.frame.width/2, y: 0, width: 1, height: 1), inView: sender, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityindicator.startAnimating()
        progressindicator.setProgress(0.0, animated: false)
        sharebutton.hidden = true
        
        if currentMode == Mode.ImportFromCSV {
            title = "Importing Tests From File"
            progresslabel.text = "Importing..."
        } else if currentMode == Mode.ExportAllToCSV {
            title = "Exporting All Tests to CSV"
            progresslabel.text = "Exporting..."
        } else if currentMode == Mode.ExportStudyOnlyToCSV {
            title = "Exporting Only Study Tests to CSV"
            progresslabel.text = "Exporting..."
        }
        
        let importBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, { () -> Void in
            if let url = self.importFileURL {
               self.importTests(url)
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityindicator.stopAnimating()
                    self.progressindicator.setProgress(1.0, animated: false)
                    self.progresslabel.text = "Import Complete"
                    self.sharebutton.hidden = true
                    self.cancelbutton.titleLabel?.text = "Close"
                    return
                })
                return
            }
        })
        let exportBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, { () -> Void in
            self.exportFileURL = self.exportTests(self.currentMode == Mode.ExportStudyOnlyToCSV)
            dispatch_async(dispatch_get_main_queue(), {
                self.activityindicator.stopAnimating()
                self.progressindicator.setProgress(1.0, animated: false)
                self.progresslabel.text = "Export Complete"
                self.sharebutton.hidden = false
                self.cancelbutton.setTitle("Close", forState: UIControlState.Normal)
                self.presentSharingView(self.sharebutton)
                return
            })
            return
        })
        
        if currentMode == Mode.ImportFromCSV {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), importBlock)
            /*
            if let url = self.importFileURL {
                self.importTests(url)
            }
            */
        } else if currentMode == Mode.ExportAllToCSV || currentMode == Mode.ExportStudyOnlyToCSV {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), exportBlock)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func importTests(url:NSURL) {
        
        // create a seperate MOC to handle imported objects
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let tempContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        tempContext.parentContext = appDelegate.managedObjectContext
        
        // parse file into array dictionary and create Test managed object
        let importedString = try? NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        var importedArray = [String]()
        
        tempContext.performBlock { () -> Void in
            
            importedString?.enumerateLinesUsingBlock({ (line,a) -> Void in
                importedArray.append(line)
            })
            
            if let keyString = importedArray.first {
                let keys = keyString.componentsSeparatedByString(",")
                for var i = 1; i < importedArray.count; i++ {
    
                    let line = importedArray[i]
                    var values:[String] = []
    
                    if line != "" {
                        // For a line with double quotes
                        // we use NSScanner to perform the parsing
                        if line.rangeOfString("\"") != nil {
                            var textToScan:String = line
                            var value:NSString?
                            var textScanner:NSScanner = NSScanner(string: textToScan)
                            while textScanner.string != "" {
                                if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                                    textScanner.scanLocation += 1
                                    textScanner.scanUpToString("\"", intoString: &value)
                                    textScanner.scanLocation += 1
                                } else {
                                    textScanner.scanUpToString(",", intoString: &value)
                                }
    
                                // Store the value into the values array
                                values.append(value as! String)
    
                                // Retrieve the unscanned remainder of the string
                                if textScanner.scanLocation < textScanner.string.characters.count {
                                    textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                                } else {
                                    textToScan = ""
                                }
                                textScanner = NSScanner(string: textToScan)
                            }
                        } else  {
                            values = line.componentsSeparatedByString(",")
                        }
                    }
                
                    let test = NSEntityDescription.insertNewObjectForEntityForName("Test", inManagedObjectContext: tempContext) as! Test
                    for var j = 0; j < keys.count; j++ {
                        // assume all imported values are String
                        test.setValue(values[j], forKey: keys[j])
                    }
    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.progresslabel.text = "\(i) of \(importedArray.count-1) imported"
                        self.progressindicator.setProgress(Float(100*i/importedArray.count-1)/100, animated: true)
                        return
                    })
    
                    if self.controllerdDismissed {
                        print("controllerdDismissed block cancelled")
                        return
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.progresslabel.text = "Saving context..."
                    self.progressindicator.setProgress(0.9, animated: true)
                    self.cancelbutton.titleLabel?.text = "Close"
                    return
                })
                
                // save temp context up to parent
                print("saving tempContext")
                do {
                    try tempContext.save()
                } catch {
                    print("error saving context")
                }
                
                // save main context to persistant store
                if let mainContext = appDelegate.managedObjectContext {
                    mainContext.performBlock({ () -> Void in
                        print("saving mainContext")
                        do {
                            try mainContext.save()
                        } catch {
                            print("error saving context")
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.progresslabel.text = "Import Complete"
                            self.progressindicator.setProgress(1.0, animated: true)
                            self.activityindicator.stopAnimating()
                            self.cancelbutton.setTitle("Close", forState: UIControlState.Normal)
                            return
                        })
                        
                    })
                }
            }
        }
        
        
        
        // delete file from inbox
        print("deleting \(url)")
        do {
            try NSFileManager.defaultManager().removeItemAtURL(url)
        } catch _ {
        }
        
        return
    }
    
    func exportTests(studyOnly:Bool = false) -> NSURL? {
        let start = NSDate()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext!
        let exportDateString = Test.getStringFromDate(start, includeTime: false)
        let exportFileName = (studyOnly) ? "export-study-\(exportDateString).csv" : "export-all-\(exportDateString).csv"
        let exportFileUrl = appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent(exportFileName)

        // create fetchrequest
        let fr = NSFetchRequest(entityName: "Test")
        let sortDescriptor = NSSortDescriptor(key: "test_date", ascending: false)
        fr.sortDescriptors = [sortDescriptor]
        if studyOnly {
            let predicate = NSPredicate(format: "patient_consent == \"1\"", argumentArray: nil)
            fr.predicate = predicate
        }
        
        if let tests = (try? moc.executeFetchRequest(fr)) as? [Test] {
            let csvString = NSMutableString()
            
            if let entity = NSEntityDescription.entityForName("Test", inManagedObjectContext: moc) {
                if let headers = Test.csvHeaders(entity) {
                    csvString.appendString(headers.joinWithSeparator(",")+"\n")
                    var count = 0
                    for test in tests {
                        var values = [String]()
                        for key in headers {
                            let value = test.valueForKey(key) as? String ?? ""
                            values.append("\"\(value)\"")
                        }
                        csvString.appendString(values.joinWithSeparator(",")+"\n")
                        
                        count++
                        dispatch_async(dispatch_get_main_queue(), {
                            self.progressindicator.setProgress(Float(count*100/tests.count)/100, animated: true)
                            self.progresslabel.text = "\(count) of \(tests.count) exported"
                        })
                        if count%100 == 0 {
                            print("\(count) exported")
                        }
                        if controllerdDismissed {
                            print("controllerdDismissed block cancelled")
                            return nil
                        }
                    }
                }
            }
            
            do {
                try csvString.writeToURL(exportFileUrl, atomically: true, encoding: NSUTF8StringEncoding)
                let timeInterval = -start.timeIntervalSinceNow
                print("export completed. Time inteval :: \(timeInterval)")
                return exportFileUrl
            } catch {
                print("problem saving to file")
                return nil
            }
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
