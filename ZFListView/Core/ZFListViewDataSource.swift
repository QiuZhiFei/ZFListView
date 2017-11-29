//
//  ZFListViewDataSource.swift
//  GuitarNotes
//
//  Created by ZhiFei on 2017/11/10.
//  Copyright © 2017年 ZhiFei. All rights reserved.
//

import Foundation
import UIKit

class ZFListViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  public var numberOfSectionsHandler: ((_ tableView: UITableView)->(Int))?
  public var numberOfRowsHandler: ((_ tableView: UITableView, _ section: Int)->(Int))?
  
  public var heightForRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath)->(CGFloat))?
  public var cellForRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath)->(UITableViewCell?))?
  public var didSelectRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath)->())?
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    if let handler = numberOfSectionsHandler {
      return handler(tableView)
    }
    return 0
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let handler = numberOfRowsHandler {
      return handler(tableView, section)
    }
    return 0
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let handler = cellForRowHandler, let cell = handler(tableView, indexPath) {
      return cell
    }
    return UITableViewCell(style: .default, reuseIdentifier: "zf_placeholder")
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let handler = didSelectRowHandler {
      handler(tableView, indexPath)
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if let handler = heightForRowHandler {
      return handler(tableView, indexPath)
    }
    return 0
  }
  
}
