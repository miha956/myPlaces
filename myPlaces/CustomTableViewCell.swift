//
//  CustomTableViewCell.swift
//  myPlaces
//
//  Created by Миша Вашкевич on 06.10.2021.
//
import Cosmos
import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var imageOfPlace: UIImageView! {
        didSet {
            
            imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
            imageOfPlace.clipsToBounds = true
        }
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    

}
