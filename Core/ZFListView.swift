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
    return self.refresh.tableView
  }
  
  open var listChangedHandler: (([T])->())?
  open var displayTypeHandler: ((ZFListViewType)->())?
  open var list: [T] {
    return self.client.list
  }
  
  open fileprivate(set) var topRefreshEnabled: Bool = true
  open fileprivate(set) var moreRefreshEnabled: Bool = true
  
  fileprivate var client: ZFListClientHandler<T>!
  fileprivate var refresh: ZFListViewRefresh!
  
  public init(frame: CGRect, refresh: ZFListViewRefresh, client: ZFListClient<T>) {
    super.init(frame: frame)
    self.client = ZFListClientHandler(client: client)
    self.refresh = refresh
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

public extension ZFListView {
  
  func configure(topRefreshEnabled: Bool) {
    self.topRefreshEnabled = topRefreshEnabled
    
    if topRefreshEnabled {
      refresh.addTopPullToRefreshIfNeeded {
        [weak self] in
        guard let `self` = self else { return }
        self.client.loadTop()
      }
      return
    }
    refresh.removeTopPullToRefreshIfNeeded()
  }
  
  func configure(moreRefreshEnabled: Bool) {
    self.moreRefreshEnabled = moreRefreshEnabled
    
    if moreRefreshEnabled {
      refresh.addBottomPullToRefreshIfNeeded {
        [weak self] in
        guard let `self` = self else { return }
        self.client.loadMore()
      }
      return
    }
    refresh.removeBottomPullToRefreshIfNeeded()
  }
  
}

fileprivate extension ZFListView {
  
  func setup() {
    addSubview(tableView)
    addTableViewToSuperViewEdge(attribute: .top, multiplier: 1, constant: 0)
    addTableViewToSuperViewEdge(attribute: .left, multiplier: 1, constant: 0)
    addTableViewToSuperViewEdge(attribute: .bottom, multiplier: 1, constant: 0)
    addTableViewToSuperViewEdge(attribute: .right, multiplier: 1, constant: 0)
    
    client.listChangedHandler = {
      [weak self] (items) in
      guard let `self` = self else { return }
      if let handler = self.listChangedHandler {
        handler(items)
      }
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
    }
    client.loadFailture = {
      [weak self] (error) in
      guard let `self` = self else { return }
      self.refresh.stopAllLoading()
      if self.client.list.count != 0 {
        //
      } else {
        self.displayType(type: .networkErr)
      }
    }
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
