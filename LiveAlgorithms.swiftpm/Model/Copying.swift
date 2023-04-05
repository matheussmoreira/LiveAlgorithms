//
//  Copying.swift
//  
//
//  Created by Matheus S. Moreira on 05/04/23.
//

import Foundation

public protocol Copying: AnyObject {
    init(_ prototype: Self)
}

extension Copying {
    public func copy() -> Self {
        return type(of: self).init(self)
    }
}
