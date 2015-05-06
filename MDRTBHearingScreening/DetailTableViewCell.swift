//
//  DetailTableViewCell.swift
//  MRTBHearingScreening
//
//  Created by Laura Greisman on 3/29/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    var key: String!
    var value: String!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var switchControl: UISwitch!
    
    @IBOutlet weak var button: UIButton!
    

}
