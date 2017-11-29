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
  
  fileprivate let tableView = UITableView(frame: .zero, style: .plain)
  fileprivate let client = ZFHomeClient()
  
  fileprivate var listView: ZFListView<String>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let refresh = ZFListViewRefreshNormal(tableView)
    listView = ZFListView(frame: .zero, refresh: refresh, client: client)
    
    listView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    listView.cellForRowHandler = {
      (tableView, indexPath, data) in
      let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
      cell.textLabel?.text = data
      return cell
    }
    listView.didSelectRowHandler = {
      (tableView, indexPath, data) in
      debugPrint("did select \(data)")
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
