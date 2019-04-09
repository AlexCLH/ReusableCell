//
//  RC.swift
//  ReusableCell
//
//  Created by 陈乐辉 on 2019/4/9.
//  Copyright © 2019年 CLH. All rights reserved.
//

import Foundation
import UIKit

public final class RCWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol RCCompatible { }

extension RCCompatible {
    public var rc: RCWrapper<Self> {
        get { return RCWrapper(self) }
        set { }
    }
}

extension UITableView: RCCompatible {}
extension UICollectionView: RCCompatible {}

extension RCWrapper {
    
    func getStrongObject(_ key: UnsafeRawPointer) -> Any! {
        return objc_getAssociatedObject(base, key)
    }
    
    func setStrongObject(_ key: UnsafeRawPointer, _ value: Any!) -> Void {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
