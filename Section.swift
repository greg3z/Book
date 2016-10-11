//
//  Section.swift
//  Book
//
//  Created by Grégoire Lhotellier on 28/09/2015.
//  Copyright © 2015 Kawet. All rights reserved.
//

import Foundation

public struct Section<Element>: Collection {
    
    public let title: String
    public var elements: [Element]
    public var startIndex: Int {
        return 0
    }
    public var endIndex: Int {
        return elements.count
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public subscript(index: Int) -> Element {
        return elements[index]
    }
    
    public func makeIterator() -> AnyIterator<Element> {
        var currentIndex = 0
        return AnyIterator { () -> Element? in
            if currentIndex < self.elements.count {
                let element = self.elements[currentIndex]
                currentIndex += 1
                return element
            }
            return nil
        }
    }
    
    public mutating func removeAtIndex(_ index: Int) -> Element {
        let element = self[index]
        elements.remove(at: index)
        return element
    }
    
}

public func ==<T: Equatable>(a: Section<T>, b: Section<T>) -> Bool {
    return a.title == b.title && a.elements == b.elements
}
