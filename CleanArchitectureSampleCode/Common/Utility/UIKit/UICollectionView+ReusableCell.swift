//
//  UICollectionView+ReusableCell.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/3/12.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell<T>(withIdentifier identifier: String = String(describing: T.self),
                                type: T.Type, indexPath: IndexPath) -> T  {
        
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
}


