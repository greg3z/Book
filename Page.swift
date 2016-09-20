//
//  Page.swift
//  Book
//
//  Created by Grégoire Lhotellier on 30/11/2015.
//  Copyright © 2015 Grégoire Lhotellier. All rights reserved.
//

import Foundation

public struct Page<Element>: Collection {
    
    public var sections: [Section<Element>]
    public var startIndex: PageIndex {
        return PageIndex(sectionsSize: sectionsSize(), currentIndex: (0, 0))
    }
    public var endIndex: PageIndex {
        return PageIndex(sectionsSize: sectionsSize(), currentIndex: (sections.count, 0))
    }
    
    public func makeIterator() -> AnyIterator<Element> {
        var index = PageIndex(sectionsSize: sectionsSize(), currentIndex: (0, 0))
        return AnyIterator { () -> Element? in
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
    
    public mutating func removeAtIndex(_ index: PageIndex) -> Element {
        let element = self[index]
        sections[index.currentIndex.section].removeAtIndex(index.currentIndex.element)
        return element
    }
    
    fileprivate func sectionsSize() -> [Int] {
        var sectionsSize = [Int]()
        for section in sections {
            sectionsSize.append(section.count)
        }
        return sectionsSize
    }
    
}

public struct PageIndex: Comparable {
    
    let sectionsSize: [Int]
    let currentIndex: (section: Int, element: Int)
    
    public func successor() -> PageIndex {
        let currentSectionMax = sectionsSize[currentIndex.section]
        let newIndex: (Int, Int)
        if currentIndex.element < currentSectionMax - 1 {
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
