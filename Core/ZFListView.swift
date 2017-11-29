//
//  ZFListView.swift
//  Guitar
//
//  Created by zhifei on 2017/11/4.
//  Copyright © 2017年 (zhifei - qiuzhifei521@gmail.com). All rights reserved.
//

import Foundation
import UIKit

@objc public enum ZFListViewType: Int {
  case normal
  case empty
  case networkErr
}

open class ZFListView<T>: UIView {
  
  open var tableView: UITableView  {
    get {
      return self.refresh.tableView
    }
  }
  internal fileprivate(set) var refresh: ZFListViewRefresh!
  
  open var displayTypeHandler: ((ZFListViewType)->())?
  
  open var cellForRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath, _ data: T)->(UITableViewCell?))?
  open var heightForRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath)->(CGFloat))?
  open var didSelectRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath, _ data: T)->())?
  
  fileprivate var client: ZFListClient<T>!
  fileprivate let dataSource = ZFListViewDataSource()
  
  public init(frame: CGRect, refresh: ZFListViewRefresh, client: ZFListClient<T>) {
    super.init(frame: frame)
    self.client = client
    self.refresh = refresh
    setup()
    
    self.tableView.delegate = dataSource
    self.tableView.dataSource = dataSource
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

fileprivate extension ZFListView {
  
  func setup() {
    addSubview(tableView)
    addTableViewToSuperViewEdge(attribute: .top, multiplier: 1, constant: 0)
    addTableViewToSuperViewEdge(attribute: .left, multiplier: 1, constant: 0)
    addTableViewToSuperViewEdge(attribute: .bottom, multiplier: 1, constant: 0)
    addTableViewToSuperViewEdge(attribute: .right, multiplier: 1, constant: 0)
    
    refresh.addTopPullToRefreshIfNeeded {
      [weak self] in
      guard let `self` = self else { return }
      self.client.loadTop()
    }
    refresh.addBottomPullToRefreshIfNeeded {
      [weak self] in
      guard let `self` = self else { return }
      self.client.loadMore()
    }
    
    client.loadSuccess = {
      [weak self] (items) in
      guard let `self` = self else { return }
      self.refresh.stopAllLoading()
      if items.count == 0 {
        self.refresh.noticeNoMoreData()
      }
      if self.client.list.count == 0 {
        self.displayType(type: .empty)
      } else {
        self.displayType(type: .normal)
      }
      self.tableView.reloadData()
    }
    client.loadFailture = {
      [weak self] (items) in
      guard let `self` = self else { return }
      self.refresh.stopAllLoading()
      if self.client.list.count != 0 {
        //
      } else {
        self.displayType(type: .networkErr)
      }
    }
    
    dataSource.numberOfSectionsHandler = {
      (_) in
      return 1
    }
    dataSource.numberOfRowsHandler = {
      [weak self] (tableView, section) in
      guard let `self` = self else { return 0}
      return self.client.list.count
    }
    dataSource.heightForRowHandler = {
      [weak self] (tableView, indexPath) in
      guard let `self` = self else { return 44 }
      if let handler = self.heightForRowHandler {
        return handler(tableView, indexPath)
      }
      return 44
    }
    dataSource.cellForRowHandler = {
      [weak self] (tableView, indexPath) in
      guard let `self` = self else { return nil }
      if let handler = self.cellForRowHandler {
        let data = self.getData(indexPath: indexPath)
        return handler(tableView, indexPath, data)
      }
      return nil
    }
    dataSource.didSelectRowHandler = {
      [weak self] (tableView, indexPath) in
      guard let `self` = self else { return }
      tableView.deselectRow(at: indexPath, animated: true)
      if let handler = self.didSelectRowHandler {
        let data = self.getData(indexPath: indexPath)
        return handler(tableView, indexPath, data)
      }
    }
  }
  
  func getData(indexPath: IndexPath) -> T {
    return self.client.list[indexPath.row]
  }
  
  func displayType(type: ZFListViewType) {
    if let handler = self.displayTypeHandler {
      handler(type)
    }
  }
  
  func addTableViewToSuperViewEdge(attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    let layout = NSLayoutConstraint(item: tableView, attribute: attribute, relatedBy: .equal, toItem: tableView.superview!, attribute: attribute, multiplier: multiplier, constant: constant)
    tableView.superview?.addConstraint(layout)
  }
  
}
