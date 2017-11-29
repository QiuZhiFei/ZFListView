//
//  ZFListClient.swift
//  Guitar
//
//  Created by zhifei on 2017/11/4.
//  Copyright © 2017年 (zhifei - qiuzhifei521@gmail.com). All rights reserved.
//

import Foundation

private let defaultTopPage = 0

open class ZFListClient<T>: NSObject {

  open fileprivate(set) var page: Int = defaultTopPage
  open fileprivate(set) var list: [T] = []
  
  open var loadSuccess: (([T])->())?
  open var loadFailture: (([T])->())?
  
  open func loadTop() {
    resetData()
    //
  }
  
  open func loadMore() {
    //
  }
  
  func resetData() {
    self.page = defaultTopPage
    self.list = []
  }
  
  open func finishData(page: Int, items: [T]) {
    self.page = page
    self.list.append(contentsOf: items)
    if let loadSuccess = loadSuccess {
      loadSuccess(items)
    }
  }
  
}
