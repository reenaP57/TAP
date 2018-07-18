//
//  SelectLocationTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 11/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SelectLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var lblLocationName : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
