//
//  TestsTableViewCell.swift
//  MDRTBHearingScreening
//
//  Created by GHC on 1/17/16.
//  Copyright © 2016 Miguel Clark. All rights reserved.
//

import UIKit

class TestsTableViewCell: UITableViewCell {

    @IBOutlet weak var flag: DesignableLabel!
    @IBOutlet weak var test_id: DesignableLabel!
    @IBOutlet weak var detail: DesignableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
