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
    public var elements: [Element]
    public var startIndex: Int {
        return 0
    }
    public var endIndex: Int {
        return elements.count
    }
    
    public init(title: String, elements: [Element]) {
        self.title = title
        self.elements = elements
    }
    
    public init(_ elements: [Element]) {
        self.init(title: "", elements: elements)
    }
    
    public subscript(index: Int) -> Element {
        return elements[index]
    }
    
    public func generate() -> AnyGenerator<Element> {
        var currentIndex = 0
        return AnyGenerator { () -> Element? in
            if currentIndex < self.elements.count {
                let index = currentIndex
                currentIndex += 1
                return self.elements[index]
            }
            return nil
        }
    }
    
    public mutating func removeAtIndex(index: Int) -> Element {
        let element = self[index]
        elements.removeAtIndex(index)
        return element
    }
    
}

extension Section: ArrayLiteralConvertible {
    
    public init(arrayLiteral elements: Element...) {
        self.init(title: "", elements: elements)
    }
    
}

public func ==<T: Equatable>(a: Section<T>, b: Section<T>) -> Bool {
    return a.title == b.title && a.elements == b.elements
}
