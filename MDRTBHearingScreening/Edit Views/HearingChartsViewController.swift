//
//  HearingChartsViewController.swift
//  MDRTBHearingScreening
//
//  Created by GHC on 1/10/16.
//  Copyright © 2016 Miguel Clark. All rights reserved.
//

import UIKit
import Charts

class HearingChartsViewController: UIViewController, ChartViewDelegate {

    var test: Test!

    @IBOutlet weak var rightEarChartView: LineChartView!
    @IBOutlet weak var leftEarChartView: LineChartView!
    
    func goNext() {
        performSegueWithIdentifier("goNext", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hearing Test Charts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Summary", style: .Plain, target: self, action: "goNext")
        
        rightEarChartView.delegate = self
        rightEarChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        rightEarChartView.descriptionText = ""
        rightEarChartView.leftAxis.inverted = true
        rightEarChartView.leftAxis.labelCount = 20
        rightEarChartView.leftAxis.customAxisMax = 100
        //rightEarChartView.leftAxis.labelFont = UIFont.systemFontOfSize(14.0)
        rightEarChartView.rightAxis.inverted = true
        rightEarChartView.rightAxis.labelCount = 20
        rightEarChartView.rightAxis.customAxisMax = 100
        //rightEarChartView.rightAxis.labelFont = UIFont.systemFontOfSize(14.0)

        leftEarChartView.delegate = self
        leftEarChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        leftEarChartView.descriptionText = ""
        leftEarChartView.leftAxis.inverted = true
        leftEarChartView.leftAxis.labelCount = 20
        leftEarChartView.leftAxis.customAxisMax = 100
        leftEarChartView.rightAxis.inverted = true
        leftEarChartView.rightAxis.labelCount = 20
        leftEarChartView.rightAxis.customAxisMax = 100
        
        if let patientId = self.test.patient_id {
            if let tests = Test.getAllTests(self.test.managedObjectContext!, patientId: patientId) {
                let colors = [UIColor.blackColor(),
                    UIColor.greenColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.blueColor(),
                     UIColor.greenColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.blueColor()]
                let xLabels = ["125Hz","250Hz","500Hz","1000Hz","2000Hz","4000Hz","8000Hz"]
                
                var leftDataSets = [LineChartDataSet]()
                var rightDataSets = [LineChartDataSet]()
                for var i = 0; i < tests.count; i++ {
                    let t = tests[i]
                    let testData = genTestData(t)
                    
                    var label = "Test \(i)"
                    if let testId = t.test_id?.componentsSeparatedByString("-").last {
                        label = "Test \(testId)"
                    }
                    if let rightData = testData["right"] {
                        let d = LineChartDataSet(yVals: rightData, label: label)
                        d.setColor(colors[i])
                        d.setCircleColor(colors[i])
                        d.drawCircleHoleEnabled = false
                        d.drawValuesEnabled = false
                        d.lineWidth = 1.5;
                        d.circleRadius = 5.0;
                        rightDataSets.append(d)
                    }
                    
                    if let leftData = testData["left"] {
                        let d = LineChartDataSet(yVals: leftData, label: label)
                        d.setColor(colors[i])
                        d.setCircleColor(colors[i])
                        d.drawCircleHoleEnabled = false
                        d.drawValuesEnabled = false
                        d.lineWidth = 1.5;
                        d.circleRadius = 5.0;
                        leftDataSets.append(d)
                    }
                }
                
                rightEarChartView.data = LineChartData(xVals: xLabels, dataSets: rightDataSets)
                leftEarChartView.data = LineChartData(xVals: xLabels, dataSets: leftDataSets)
            }
        }
        
    }
    
    func genTestData(t:Test) -> [String:[ChartDataEntry]] {
        let right = [
            ChartDataEntry(value: Double(t.right_125 ?? "0") ?? 0.0, xIndex: 0),
            ChartDataEntry(value: Double(t.right_250 ?? "0") ?? 0.0, xIndex: 1),
            ChartDataEntry(value: Double(t.right_500 ?? "0") ?? 0.0, xIndex: 2),
            ChartDataEntry(value: Double(t.right_1000 ?? "0") ?? 0.0, xIndex: 3),
            ChartDataEntry(value: Double(t.right_2000 ?? "0") ?? 0.0, xIndex: 4),
            ChartDataEntry(value: Double(t.right_4000 ?? "0") ?? 0.0, xIndex: 5),
            ChartDataEntry(value: Double(t.right_8000 ?? "0") ?? 0.0, xIndex: 6)
        ]
        let left = [
            ChartDataEntry(value: Double(t.left_125 ?? "0") ?? 0.0, xIndex: 0),
            ChartDataEntry(value: Double(t.left_250 ?? "0") ?? 0.0, xIndex: 1),
            ChartDataEntry(value: Double(t.left_500 ?? "0") ?? 0.0, xIndex: 2),
            ChartDataEntry(value: Double(t.left_1000 ?? "0") ?? 0.0, xIndex: 3),
            ChartDataEntry(value: Double(t.left_2000 ?? "0") ?? 0.0, xIndex: 4),
            ChartDataEntry(value: Double(t.left_4000 ?? "0") ?? 0.0, xIndex: 5),
            ChartDataEntry(value: Double(t.left_8000 ?? "0") ?? 0.0, xIndex: 6)
        ]
        return [
            "right":right,
            "left":left
        ]
    }
    
    func genRandomChartData(count:Int) -> [ChartDataEntry] {
        var data = [ChartDataEntry]()
        for var i = 0; i < count; i++ {
            let val:Double = Double(arc4random_uniform(UInt32(100)))
            data.append(ChartDataEntry(value: val, xIndex: i))
        }
        return data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goNext") {
            if let destinationController = segue.destinationViewController as? DetailTableViewController {
                destinationController.test = test
            }
        }
    }
}
