//
//  Stack.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import Foundation

struct Stack<T> {
    private var content = [T]()
    
    var isEmpty: Bool { content.isEmpty }
    
    mutating func push(_ element: T) {
        content.append(element)
    }
    
    mutating func pop() -> T? {
        isEmpty ? nil : content.removeLast()
    }
}

extension Stack: CustomStringConvertible {
    var description: String {
         """
        (TOP)
        \(content.map { "\($0)" }.reversed().joined(separator:"\n"))
        (BOTTOM)
        """
    }
}
