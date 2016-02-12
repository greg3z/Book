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
    public var startIndex: PageIndex {
        return PageIndex(sectionsSize: sectionsSize(), currentIndex: (0, 0))
    }
    public var endIndex: PageIndex {
        let lastSectionIndex = sections.count - 1
        let lastIndex = (lastSectionIndex, sections[lastSectionIndex].count - 1)
        return PageIndex(sectionsSize: sectionsSize(), currentIndex: lastIndex)
    }
    
    public func generate() -> AnyGenerator<Element> {
        var index = PageIndex(sectionsSize: sectionsSize(), currentIndex: (0, 0))
        return anyGenerator { () -> Element? in
            guard let element = self[safe: index] else {
                return nil
            }
            index = index.successor()
            return element
        }
    }
    
    public subscript(index: PageIndex) -> Element {
        return sections[index.currentIndex.section][index.currentIndex.element]
    }
    
    public subscript(safe index: PageIndex) -> Element? {
        let sectionIndex = index.currentIndex.section
        let elementIndex = index.currentIndex.element
        guard sectionIndex < sections.count && elementIndex < sections[sectionIndex].count else {
            return nil
        }
        return self[index]
    }
    
    private func sectionsSize() -> [Int] {
        var sectionsSize = [Int]()
        for section in sections {
            sectionsSize.append(section.count)
        }
        return sectionsSize
    }
    
}

public struct PageIndex: ForwardIndexType {
    
    let sectionsSize: [Int]
    let currentIndex: (section: Int, element: Int)
    
    public func successor() -> PageIndex {
        let currentSectionMax = sectionsSize[currentIndex.section]
        let newIndex: (Int, Int)
        if currentIndex.element < currentSectionMax {
            newIndex = (currentIndex.section, currentIndex.element + 1)
        }
        else {
            newIndex = (currentIndex.section + 1, 0)
        }
        return PageIndex(sectionsSize: sectionsSize, currentIndex: newIndex)
    }
    
}

public func ==(lhs: PageIndex, rhs: PageIndex) -> Bool {
    return lhs.sectionsSize == rhs.sectionsSize && lhs.currentIndex.section == rhs.currentIndex.section && lhs.currentIndex.element == rhs.currentIndex.element
}
