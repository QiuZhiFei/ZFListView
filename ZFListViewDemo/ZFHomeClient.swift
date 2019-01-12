//
//  ZFHomeClient.swift
//  ZFListViewDemo
//
//  Created by ZhiFei on 2017/11/29.
//  Copyright © 2017年 ZhiFei. All rights reserved.
//

import Foundation
import ZFListView

class ZFHomeClient: ZFListClient<String> {
  
  override var defaultTopPage: Int {
    return 1
  }
  
  override func loadTop(page: Int, handler: (([String], Error?) -> ())?) {
    super.loadTop(page: page, handler: handler)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
      [weak self] in
      guard let `self` = self else { return }
      if let handler = handler {
        handler(self.getData(page: page), nil)
      }
    }
  }
  
  override func loadMore(page: Int, handler: (([String], Error?) -> ())?) {
    super.loadMore(page: page, handler: handler)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
      [weak self] in
      guard let `self` = self else { return }
      if page > 2 {
        if let handler = handler {
          // 没有更多
          handler([], nil)
        }
        return
      }
      if let handler = handler {
        handler(self.getData(page: page), nil)
      }
    }
  }
  
}

fileprivate extension ZFHomeClient {
  
  func getData(page: Int) -> [String] {
    var data: [String] = []
    var index = 0
    repeat {
      data.append("\(index + page * 10)")
      index = index + 1
    } while index < 10
    return data
  }
  
}
