//
//  ViewController.swift
//  ZFListViewDemo
//
//  Created by ZhiFei on 2017/11/29.
//  Copyright © 2017年 ZhiFei. All rights reserved.
//

import UIKit
import ZFListView

fileprivate let cellReuseIdentifier = "cellReuseIdentifier"

class ViewController: UIViewController {
  
  fileprivate let dataSource = ZFListViewNormalDataSource<String>()
  
  fileprivate var listView: ZFListView<String>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tableView = UITableView(frame: .zero, style: .plain)
    // 拆分刷新
    let refresh = ZFListViewRefreshNormal(tableView)
    // 拆分网络加载
    let client = ZFHomeClient()
    
    listView = ZFListView(frame: .zero, refresh: refresh, client: client)
    
    // 配置刷新
    listView.configure(topRefreshEnabled: true)
    listView.configure(moreRefreshEnabled: true)
    
    // 配置UI
    listView.tableView.delegate = dataSource
    listView.tableView.dataSource = dataSource
    listView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    
    listView.listChangedHandler = {
      [weak self] (items) in
      guard let `self` = self else { return }
      self.dataSource.configure(list: items)
      self.listView.tableView.reloadData()
    }
    dataSource.heightForRowHandler = {
      [weak self] (tableView, indexPath) in
      guard let _ = self else { return 0 }
      return 44
    }
    dataSource.cellForRowHandler = {
      (tableView, indexPath, data) in
      let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
      cell.textLabel?.text = data
      return cell
    }
    dataSource.didSelectRowHandler = {
      (tableView, indexPath, data) in
      debugPrint("did select \(data ?? "data")")
    }
    
    view.addSubview(listView)
    listView.zf_addLayoutToSuperViewEdge(attribute: .top, multiplier: 1, constant: 0)
    listView.zf_addLayoutToSuperViewEdge(attribute: .left, multiplier: 1, constant: 0)
    listView.zf_addLayoutToSuperViewEdge(attribute: .bottom, multiplier: 1, constant: 0)
    listView.zf_addLayoutToSuperViewEdge(attribute: .right, multiplier: 1, constant: 0)
    
    refresh.startTopRefreshing()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    
  }
  
  
}

extension UIView {
  
  func zf_addLayoutToSuperViewEdge(attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
    guard let superview = self.superview else {
      debugPrint("add layout need superView")
      return
    }
    self.translatesAutoresizingMaskIntoConstraints = false
    let layout = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: superview, attribute: attribute, multiplier: multiplier, constant: constant)
    superview.addConstraint(layout)
  }
  
}
