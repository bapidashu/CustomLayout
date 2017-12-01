//
//  CustomLayout.swift
//  CustomLayout
//
//  Created by duzhe on 2017/12/1.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewLayout {
  
  struct Constant {
    static let daysPerWeek: CGFloat = 7
    static let hoursPerDay: CGFloat = 24
    static let horizontalSpacing: CGFloat = 10
    static let heightPerHour: CGFloat = 50
    static let dayHeaderHeight: CGFloat = 40
    static let hourHeaderWidth: CGFloat = 50
  }
  
  override var collectionViewContentSize: CGSize {
    let contentWidth = self.collectionView!.bounds.size.width
    let contentHeight = Constant.dayHeaderHeight + ( Constant.heightPerHour * Constant.hoursPerDay )
    let contentSize = CGSize(width: contentWidth, height: contentHeight)
    return contentSize
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    // 可见区域的 indexPaths
    let visibleIndexPaths = self.indexPathsOfItems(in: rect)
    
    for indexPath in visibleIndexPaths {
      if let attributes = self.layoutAttributesForItem(at: indexPath) {
        layoutAttributes.append(attributes)
      }
    }
    // supplementary views
    let dayHeaderViewIndexPaths = self.indexPathsOfDayHeaderViews(in: rect)
    for indexPath in dayHeaderViewIndexPaths {
      if let attributes = self.layoutAttributesForSupplementaryView(ofKind: "DayHeaderView", at: indexPath){
        layoutAttributes.append(attributes)
      }
    }
    
    let hourHeaderViewIndexPaths = self.indexPathsOfHourHeaderViews(in: rect)
    for indexPath in hourHeaderViewIndexPaths {
      if let attributes = self.layoutAttributesForSupplementaryView(ofKind: "HourHeaderView", at: indexPath){
        layoutAttributes.append(attributes)
      }
    }
    
    return layoutAttributes
  }
  
  
  
  // 每个indexpath的布局属性
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let dataSource = self.collectionView?.dataSource as? CustomDataSource else {
      return nil
    }
    let event = dataSource.events[indexPath.item]
    let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    attribute.frame = self.frameFor(event)
    return attribute
  }
  
  override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    
    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
    let totalWidth = self.collectionViewContentSize.width
    if elementKind == "DayHeaderView" {
      let availableWidth = totalWidth - Constant.hourHeaderWidth
      let widthPerDay = availableWidth / Constant.daysPerWeek
      attributes.frame = CGRect(x: Constant.hourHeaderWidth + ( widthPerDay * CGFloat(indexPath.item) ), y: 0, width: widthPerDay, height: Constant.dayHeaderHeight)
      attributes.zIndex = -10
    }else if elementKind == "HourHeaderView" {
      attributes.frame = CGRect(x: 0, y: Constant.dayHeaderHeight + Constant.heightPerHour * CGFloat(indexPath.item) , width: totalWidth, height: Constant.heightPerHour)
      attributes.zIndex = -10
    }
    return attributes
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    let oldBounds = self.collectionView!.bounds
    if newBounds.width != oldBounds.width {
      return true
    }
    return false
  }
  
  //MARK: - Helpers
  func indexPathsOfItems(in rect: CGRect) -> [IndexPath]{
    let minVisibleDay = self.dayIndexFromXCoordinate(x: rect.minX)
    let maxVisibleDay = self.dayIndexFromXCoordinate(x: rect.maxX)
    let minVisibleHour = self.hourIndexFromYCoordinate(y: rect.minY)
    let maxVisibleHour = self.hourIndexFromYCoordinate(y: rect.maxY)
    
    if let dataSource = self.collectionView!.dataSource as? CustomDataSource{
      let indexPaths = dataSource.indexPathsOfEventsBetween(minDayIndex: minVisibleDay, maxDayIndex: maxVisibleDay, minStartHour: minVisibleHour, maxStartHour: maxVisibleHour)
      return indexPaths
    }
    return []
  }
  
  func dayIndexFromXCoordinate(x: CGFloat)->Int{
    let contentWidth = self.collectionViewContentSize.width - Constant.hourHeaderWidth
    let widthPerDay = contentWidth / Constant.daysPerWeek
    let dayIndex = max(0, (x-Constant.hourHeaderWidth)/widthPerDay)
    return Int(dayIndex)
  }
  
  func hourIndexFromYCoordinate(y: CGFloat) ->Int{
    let hourIndex = max(0, (y - Constant.dayHeaderHeight)/Constant.heightPerHour)
    return Int(hourIndex)
  }
  
  
  //MARK: - supplementary views
  func indexPathsOfDayHeaderViews(in rect: CGRect) -> [IndexPath]{
    if rect.minY > Constant.dayHeaderHeight {
      return []
    }
    let minDayIndex = self.dayIndexFromXCoordinate(x: rect.minX)
    let maxDayIndex = self.dayIndexFromXCoordinate(x: rect.maxX)
    var indexPaths: [IndexPath] = []
    
    for idx in minDayIndex...maxDayIndex {
      let indexPath = IndexPath(item: idx, section: 0)
      indexPaths.append(indexPath)
    }
    return indexPaths
  }
  
  func indexPathsOfHourHeaderViews(in rect: CGRect) -> [IndexPath] {
    if rect.minX > Constant.hourHeaderWidth {
      return []
    }
    let minHourIndex = self.hourIndexFromYCoordinate(y: rect.minY)
    let maxHourIndex = self.hourIndexFromYCoordinate(y: rect.maxY)
    var indexPaths: [IndexPath] = []
    for idx in  minHourIndex...maxHourIndex{
      let indexPath = IndexPath(item: idx, section: 0)
      indexPaths.append(indexPath)
    }
    return indexPaths
  }
  
  func frameFor(_ event: Event) -> CGRect {
    let totalWidth = self.collectionViewContentSize.width - Constant.hourHeaderWidth
    let widthPerDay = totalWidth/Constant.daysPerWeek
    var frame = CGRect.zero
    frame.origin.x = Constant.hourHeaderWidth + widthPerDay * CGFloat(event.day)
    frame.origin.y = Constant.dayHeaderHeight + Constant.heightPerHour * CGFloat(event.startHour)
    frame.size.width = widthPerDay
    frame.size.height = CGFloat(event.durationInHours) * Constant.heightPerHour
    return frame
  }

}
