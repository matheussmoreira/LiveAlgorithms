//
//  Queue.swift
//  
//
//  Created by Matheus S. Moreira on 31/03/23.
//

import Foundation

struct Queue<T> {
    private var content = [T]()
    
    var isEmpty: Bool { content.isEmpty }
    
    mutating func enqueue(_ element: T) {
        content.append(element)
    }
    
    mutating func dequeue() -> T? {
        isEmpty ? nil : content.removeFirst()
    }
}

extension Queue: CustomStringConvertible {
    var description: String {
        String(describing: content)
    }
}
