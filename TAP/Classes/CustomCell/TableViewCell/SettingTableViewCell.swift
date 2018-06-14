//
//  SettingTableViewCell.swift
//  TAP
//
//  Created by mac-00017 on 13/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var switchNotiy : UISwitch!
    @IBOutlet weak var imgVArrow : UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
