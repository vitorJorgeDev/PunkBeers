//
//  BeerTableViewCell.swift
//  PUNKBeers
//
//  Created by Vitor Cesar Hideo Jorge on 03/07/17.
//  Copyright © 2017 Vitor Cesar Hideo Jorge RM 31624. All rights reserved.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    @IBOutlet weak var ivBeerImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAbv: UILabel!
    @IBOutlet weak var act: UIActivityIndicatorView!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
