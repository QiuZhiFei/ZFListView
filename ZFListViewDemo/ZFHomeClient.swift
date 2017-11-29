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
  
  override func loadTop() {
    super.loadTop()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
      [weak self] in
      guard let `self` = self else { return }
      self.finishData(page: self.page, items: self.getData(page: self.page))
    }
  }
  
  override func loadMore() {
    super.loadMore()
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
      [weak self] in
      guard let `self` = self else { return }
      if self.page > 1 {
        self.finishData(page: self.page + 1, items: [])
      } else {
        self.finishData(page: self.page + 1, items: self.getData(page: self.page  + 1))
      }
    }
  }
  
}

fileprivate extension ZFHomeClient {
  
  func loadData() {
    
  }
  
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
