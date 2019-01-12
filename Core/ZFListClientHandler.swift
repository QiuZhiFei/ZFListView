//
//  ZFListClientHandlerHandler.swift
//  Pods
//
//  Created by ZhiFei on 2017/11/30.
//

import UIKit

class ZFListClientHandler<T>: NSObject {
  
  fileprivate(set) var page: Int
  fileprivate(set) var list: [T] = []
  
  fileprivate var client: ZFListClient<T>
  
  var loadSuccess: (([T])->())?
  var loadFailture: ((Error?)->())?
  var listChangedHandler: (([T])->())?
  
  public init(client: ZFListClient<T>) {
    self.client = client
    self.page = self.client.defaultTopPage
    super.init()
  }
  
  func loadTop() {
    resetData()

    let page = self.page
    client.loadTop(page: page) {
      [weak self] (items, error) in
      guard let `self` = self else { return }
      self.handleData(page: page, items: items, error: error)
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
    self.page = self.client.defaultTopPage
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
    self.list.append(contentsOf: items)
    self.handleListChange()
    
    if let handler = self.loadSuccess {
      handler(items)
    }
  }
  
  func handleListChange() {
    if let handler = self.listChangedHandler {
      handler(self.list)
    }
  }
  
}
