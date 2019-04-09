//
//  ReusableCell.swift
//  ReusableCell
//
//  Created by 陈乐辉 on 2019/4/9.
//  Copyright © 2019年 CLH. All rights reserved.
//

import Foundation
import UIKit

public protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    public static var identifier: String {
        return "\(self)"
    }
}

extension UITableViewCell: ReusableCell {}
extension UITableViewHeaderFooterView: ReusableCell {}
extension UICollectionReusableView: ReusableCell {}

private var tableViewIdentifierKey: Void?

extension RCWrapper where Base: UITableView {
    
    private var identifiers: Set<String> {
        get {
            if let ids = getStrongObject(&tableViewIdentifierKey) as? Set<String> {
                return ids
            } else {
                let ids = Set<String>()
                setStrongObject(&tableViewIdentifierKey, ids)
                return ids
            }
        }
        set {
            setStrongObject(&tableViewIdentifierKey, newValue)
        }
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, configure: (T) -> Void) -> UITableViewCell  {
        if !identifiers.contains(T.identifier) {
            base.register(type, forCellReuseIdentifier: T.identifier)
            identifiers.insert(T.identifier)
        }
        if let cell = base.dequeueReusableCell(withIdentifier: T.identifier) as? T {
            configure(cell)
            return cell
        }
        return UITableViewCell()
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath, configure: (T) -> Void) -> UITableViewCell {
        if !identifiers.contains(T.identifier) {
            base.register(type, forCellReuseIdentifier: T.identifier)
            identifiers.insert(T.identifier)
        }
        let reusableCell = base.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath)
        guard let cell = reusableCell as? T else { return reusableCell }
        configure(cell)
        return cell
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(with type: T.Type, configure: (T) -> Void) -> UITableViewHeaderFooterView  {
        if !identifiers.contains(T.identifier) {
            base.register(type, forHeaderFooterViewReuseIdentifier: T.identifier)
            identifiers.insert(T.identifier)
        }
        if let rv = base.dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T {
            configure(rv)
            return rv
        }
        return UITableViewHeaderFooterView()
    }
}

private var collectionViewIdentifierKey: Void?

extension RCWrapper where Base: UICollectionView {
    
    private var identifiers: Set<String> {
        get {
            if let ids = getStrongObject(&collectionViewIdentifierKey) as? Set<String> {
                return ids
            } else {
                let ids = Set<String>()
                setStrongObject(&collectionViewIdentifierKey, ids)
                return ids
            }
        }
        set {
            setStrongObject(&collectionViewIdentifierKey, newValue)
        }
    }
    
    public enum ElementKind {
        case header
        case footer
        
        public var value: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath, configure: (T) -> Void) -> UICollectionViewCell {
        if !identifiers.contains(T.identifier) {
            base.register(type, forCellWithReuseIdentifier: T.identifier)
            identifiers.insert(T.identifier)
        }
        let cell = base.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath)
        if let cell = cell as? T {
            configure(cell)
        }
        return cell
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(of elementKind: ElementKind, with type: T.Type, for indexPath: IndexPath, configure: (T) -> Void) -> UICollectionReusableView {
        if !identifiers.contains(T.identifier) {
            base.register(type, forSupplementaryViewOfKind: elementKind.value, withReuseIdentifier: T.identifier)
            identifiers.insert(T.identifier)
        }
        let view = base.dequeueReusableSupplementaryView(ofKind: elementKind.value, withReuseIdentifier: T.identifier, for: indexPath)
        if let view = view as? T {
            configure(view)
        }
        return view
    }
}

