//
//  ViewController.swift
//  CustomLayout
//
//  Created by duzhe on 2017/12/1.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var customDataSource: CustomDataSource!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.register(UINib(nibName: EventCell.reuseID , bundle: Bundle.main), forCellWithReuseIdentifier: EventCell.reuseID)
    let headerViewNib = UINib(nibName: "HeaderView", bundle: nil)
    self.collectionView.register(headerViewNib, forSupplementaryViewOfKind: "DayHeaderView", withReuseIdentifier: "HeaderView")
    self.collectionView.register(headerViewNib, forSupplementaryViewOfKind: "HourHeaderView", withReuseIdentifier: "HeaderView")
    
    customDataSource.cellConfig = { cell , indexPath , event in
      cell.titleLabel.text = event.title
    }
    customDataSource.headerConfig = { headerView, kind , indexPath in
      if kind == "DayHeaderView" {
        headerView.titleLabel.text = "Day \(indexPath.item + 1)"
      }else if kind == "HourHeaderView" {
        headerView.titleLabel.text = String(format: "%2d:00", indexPath.item + 1)
      }
    }
  }

}

