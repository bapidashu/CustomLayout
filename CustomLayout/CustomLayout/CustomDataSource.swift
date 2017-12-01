//
//  CustomDataSource.swift
//  CustomLayout
//
//  Created by duzhe on 2017/12/1.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

typealias CellConfig<T: UICollectionViewCell , U> = (_ cell: T ,_ indexPath: IndexPath ,_ model: U) -> Void
typealias HeaderViewConfig<T: UICollectionReusableView> = (_ headerView: T ,_ kind: String ,_ indexPath: IndexPath) -> Void

class CustomDataSource: NSObject , UICollectionViewDataSource {
  
  var headerConfig: HeaderViewConfig<HeaderView>?
  var cellConfig: CellConfig<EventCell,Event>?
  var events: [Event] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.generateSampleData()
  }
  
  func generateSampleData() {
    var tmp: [Event] = []
    for i in 0..<20 {
      
      let event = Event(title: "事项\(i)", day: i%7 + 1, startHour: i , durationInHours: i%4)
      tmp.append(event)
    }
    self.events = tmp
  }
  
  // 根据 day和hour 计算 indexPaths
  func indexPathsOfEventsBetween(minDayIndex: Int , maxDayIndex: Int, minStartHour: Int , maxStartHour: Int) -> [IndexPath]{
    var indexPaths: [IndexPath] = []
    for (index,event) in self.events.enumerated() {
      if event.day >= minDayIndex && event.day <= maxDayIndex && event.startHour >= minStartHour && event.startHour <= maxStartHour {
        let indexPath = IndexPath(item: index, section: 0)
        indexPaths.append(indexPath)
      }
    }
    return indexPaths
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return events.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let event = self.events[indexPath.item]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseID, for: indexPath) as! EventCell
    cellConfig?(cell,indexPath,event)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
    headerConfig?(headerView,kind,indexPath)
    return headerView
  }
  
}






