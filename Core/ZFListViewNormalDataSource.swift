//
//  ZFListViewNormalDataSource.swift
//  MJRefresh
//
//  Created by ZhiFei on 2018/4/9.
//

import Foundation
import UIKit

open class ZFListViewNormalDataSource<T>: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  public var heightForRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath)->(CGFloat))?
  public var cellForRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath, _ data: T?)->(UITableViewCell?))?
  public var didSelectRowHandler: ((_ tableView: UITableView, _ indexPath: IndexPath, _ data: T?)->())?
  
  public fileprivate(set) var list: [T] = []
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.list.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let handler = cellForRowHandler, let cell = handler(tableView, indexPath, getData(indexPath)) {
      return cell
    }
    return UITableViewCell(style: .default, reuseIdentifier: "zf_placeholder")
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let handler = didSelectRowHandler {
      handler(tableView, indexPath, getData(indexPath))
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if let handler = heightForRowHandler {
      return handler(tableView, indexPath)
    }
    return 0
  }
  
}

public extension ZFListViewNormalDataSource {
  
  func configure(list: [T]) {
    self.list = list
  }
  
}

fileprivate extension ZFListViewNormalDataSource {
  
  func getData(_ indexPath: IndexPath) -> T? {
    let index = indexPath.row
    if index < self.list.count {
      return self.list[index]
    }
    return nil
  }
  
}

