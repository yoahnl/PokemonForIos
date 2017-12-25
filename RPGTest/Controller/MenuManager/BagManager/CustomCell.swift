//
//  CustomCell.swift
//  RPGTest
//
//  Created by Yoahn on 22/12/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var First: UILabel!
    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var ItemImage: UIImageView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
