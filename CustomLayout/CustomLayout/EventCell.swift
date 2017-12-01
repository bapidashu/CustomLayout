//
//  EventCell.swift
//  CustomLayout
//
//  Created by duzhe on 2017/12/1.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
  
  static let reuseID = "EventCell"
  
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    titleLabel.numberOfLines = 0
    self.layer.cornerRadius = 10
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0.7, alpha: 1).cgColor
  }
  
}

