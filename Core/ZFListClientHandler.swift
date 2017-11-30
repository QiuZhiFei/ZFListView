//
//  ZFListClientHandlerHandler.swift
//  Pods
//
//  Created by ZhiFei on 2017/11/30.
//

import UIKit

private let defaultTopPage = 0

class ZFListClientHandler<T>: NSObject {
  
  fileprivate(set) var page: Int = defaultTopPage
  fileprivate(set) var list: [T] = []
  
  fileprivate var client: ZFListClient<T>!
  
  var loadSuccess: (([T])->())?
  var loadFailture: ((Error?)->())?
  
  public init(client: ZFListClient<T>) {
    super.init()
    self.client = client
  }
  
  func loadTop() {
    resetData()

    client.loadTop(page: page) {
      [weak self] (items, error) in
      guard let `self` = self else { return }
      self.handleData(page: defaultTopPage, items: items, error: error)
    }
  }
  
  func loadMore() {
    let newPage = page + 1
    client.loadMore(page: newPage) {
      [weak self] (items, error) in
      guard let `self` = self else { return }
      self.handleData(page: newPage, items: items, error: error)
    }
  }
  
  func resetData() {
    self.page = defaultTopPage
    self.list = []
  }
  
}

fileprivate extension ZFListClientHandler {
  
  func handleData(page: Int, items: [T], error: Error?) {
    if let error = error {
      if let handler = self.loadFailture {
        handler(error)
      }
      return
    }
    
    self.page = page
    if let handler = self.loadSuccess {
      self.list.append(contentsOf: items)
      handler(items)
    }
  }
  
}
