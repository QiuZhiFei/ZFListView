//
//  ZFListViewRefresh.swift
//  GuitarNotes
//
//  Created by ZhiFei on 2017/11/10.
//  Copyright © 2017年 ZhiFei. All rights reserved.
//

import Foundation
import UIKit

public protocol ZFListViewRefresh {

  var tableView: UITableView { get }
  
  init(_ tableview: UITableView)
  
  func startTopRefreshing()
  
  func stopAllLoading()
  
  func noticeNoMoreData()
  
  func addTopPullToRefreshIfNeeded(handler: (()->())?)
  
  func removeTopPullToRefreshIfNeeded()
  
  func addBottomPullToRefreshIfNeeded(handler: (()->())?)
  
  func removeBottomPullToRefreshIfNeeded()
  
  
}
