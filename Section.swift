//
//  Section.swift
//  Book
//
//  Created by Grégoire Lhotellier on 28/09/2015.
//  Copyright © 2015 Kawet. All rights reserved.
//

import Foundation

public struct Section<Element>: CollectionType {
    
    public let title: String
    public let elements: [Element]
    public var startIndex: Int {
        return 0
    }
    public var endIndex: Int {
        return elements.count
    }
    
    public subscript(index: Int) -> Element {
        return elements[index]
    }
    
    public func generate() -> AnyGenerator<Element> {
        var currentIndex = 0
        return anyGenerator { () -> Element? in
            if currentIndex < self.elements.count {
                return self.elements[currentIndex++]
            }
            return nil
        }
    }
    
}

public func ==<T: Equatable>(a: Section<T>, b: Section<T>) -> Bool {
    return a.title == b.title && a.elements == b.elements
}
