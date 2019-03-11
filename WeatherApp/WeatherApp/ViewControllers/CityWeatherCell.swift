//
//  CityWeatherCell.swift
//  WeatherApp
//
//  Created by Dennis Mostajo on 3/11/19.
//  Copyright © 2019 Dennis Mostajo. All rights reserved.
//

import UIKit

class CityWeatherCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var temperature: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
