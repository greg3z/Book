//
//  Page.swift
//  Book
//
//  Created by Grégoire Lhotellier on 30/11/2015.
//  Copyright © 2015 Grégoire Lhotellier. All rights reserved.
//

import Foundation

public struct Page<Element>: CollectionType {
    
    public let sections: [Section<Element>]
    public var startIndex: Int {
        return 0
    }
    public var endIndex: Int {
        return sections.count
    }
    
    public func generate() -> AnyGenerator<Section<Element>> {
        var currentIndex = 0
        return anyGenerator { () -> Section<Element>? in
            if currentIndex < self.sections.count {
                return self.sections[currentIndex++]
            }
            return nil
        }
    }
    
    public subscript(index: Int) -> Section<Element> {
        return sections[index]
    }
    
}
