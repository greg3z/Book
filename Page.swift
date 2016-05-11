//
//  Page.swift
//  Book
//
//  Created by Grégoire Lhotellier on 30/11/2015.
//  Copyright © 2015 Grégoire Lhotellier. All rights reserved.
//

import Foundation

public struct Page<Element> {
    
    public var sections: [Section<Element>]

    public init(sections: [Section<Element>]) {
        self.sections = sections
    }
    
    public init(_ elements: [Element]) {
        let section = Section(elements)
        self.init(sections: [section])
    }
    
}

extension Page: CollectionType {
    
    public var startIndex: PageIndex {
        return PageIndex(sectionsSize: sectionsSize(), currentIndex: (0, 0))
    }
    public var endIndex: PageIndex {
        return PageIndex(sectionsSize: sectionsSize(), currentIndex: (sections.count, 0))
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
    
    public func generate() -> AnyGenerator<Element> {
        var index = PageIndex(sectionsSize: sectionsSize(), currentIndex: (0, 0))
        return AnyGenerator { () -> Element? in
            guard let element = self[safe: index] else {
                return nil
            }
            index = index.successor()
            return element
        }
    }
    
    public mutating func removeAtIndex(index: PageIndex) -> Element {
        let element = self[index]
        sections[index.currentIndex.section].removeAtIndex(index.currentIndex.element)
        return element
    }
    
    private func sectionsSize() -> [Int] {
        var sectionsSize = [Int]()
        for section in sections {
            sectionsSize.append(section.count)
        }
        return sectionsSize
    }
    
}

extension Page: ArrayLiteralConvertible {
    
    public init(arrayLiteral elements: Element...) {
        let section = Section(title: "", elements: elements)
        self.init(sections: [section])
    }
    
}

public struct PageIndex: ForwardIndexType {
    
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
