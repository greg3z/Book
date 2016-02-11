//
//  Book.swift
//  Book
//
//  Created by Grégoire Lhotellier on 30/11/2015.
//  Copyright © 2015 Grégoire Lhotellier. All rights reserved.
//

import Foundation

public struct Book<Element>: CollectionType {
    
    public let pages: [Page<Element>]
    public var startIndex: Int {
        return 0
    }
    public var endIndex: Int {
        return pages.count
    }
    
    public func generate() -> AnyGenerator<Page<Element>> {
        var currentIndex = 0
        return anyGenerator { () -> Page<Element>? in
            if currentIndex < self.pages.count {
                return self.pages[currentIndex++]
            }
            return nil
        }
    }
    
    public subscript(index: Int) -> Page<Element> {
        return pages[index]
    }
    
}
