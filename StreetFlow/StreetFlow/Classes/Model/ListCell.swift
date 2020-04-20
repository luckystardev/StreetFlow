//
//  ListCell.swift
//  StreetFlow
//
//  Created by Alex on 3/13/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var bgView: RoundView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var streetLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.addShadowEffect()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
