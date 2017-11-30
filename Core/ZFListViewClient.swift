//
//  ZFListClient.swift
//  Guitar
//
//  Created by zhifei on 2017/11/4.
//  Copyright © 2017年 (zhifei - qiuzhifei521@gmail.com). All rights reserved.
//

import Foundation

open class ZFListClient<T>: NSObject {
  
  open func loadTop(page: Int, handler: (([T], Error?)->())?) {
    //
  }
  
  open func loadMore(page: Int, handler: (([T], Error?)->())?) {
    //
  }

}
