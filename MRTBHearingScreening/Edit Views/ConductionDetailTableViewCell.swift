//
//  ConductionDetailTableViewCell.swift
//  MRTBHearingScreening
//
//  Created by Miguel Clark on 4/3/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit


class ConductionDetailTableViewCell: UITableViewCell {

    var delegate : ConductionDetailTableViewCellDelegate!
    
    @IBOutlet weak var Frequency: UILabel!
    @IBOutlet weak var DbLevelsA: UISegmentedControl!
    @IBOutlet weak var DbLevelsB: UISegmentedControl!
    
    @IBAction func dBLevelsAValueChanged(sender: UISegmentedControl) {
        DbLevelsB.selectedSegmentIndex = UISegmentedControlNoSegment
        let newDbLevel: Int = sender.selectedSegmentIndex*10
        delegate.dbLevelUpdated(self, newDbLevel:newDbLevel)
    }
    @IBAction func dBLevelsBValueChanged(sender: UISegmentedControl) {
        DbLevelsA.selectedSegmentIndex = UISegmentedControlNoSegment
        let newDbLevel: Int = sender.selectedSegmentIndex*10 + 5
        delegate.dbLevelUpdated(self,newDbLevel:newDbLevel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
protocol ConductionDetailTableViewCellDelegate {
    func dbLevelUpdated(cell: UITableViewCell, newDbLevel : Int) -> ()
}
