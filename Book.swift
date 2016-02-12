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
    public var startIndex: BookIndex {
        return BookIndex(sectionsSize: sectionsSize(), currentIndex: (0, 0, 0))
    }
    public var endIndex: BookIndex {
        let lastPageIndex = pages.count - 1
        let lastSectionIndex = pages[lastPageIndex].sections.count - 1
        let lastElementIndex = pages[lastPageIndex].sections[lastSectionIndex].count - 1
        let lastIndex = (lastPageIndex, lastSectionIndex, lastElementIndex)
        return BookIndex(sectionsSize: sectionsSize(), currentIndex: lastIndex)
    }
    
    public func generate() -> AnyGenerator<Element> {
        var currentIndex = startIndex
        return anyGenerator { () -> Element? in
            if let element = self[safe: currentIndex] {
                currentIndex = currentIndex.successor()
                return element
            }
            return nil
        }
    }
    
    public subscript(index: BookIndex) -> Element {
        let currentIndex = index.currentIndex
        return pages[currentIndex.page].sections[currentIndex.section][currentIndex.element]
    }
    
    public subscript(safe index: BookIndex) -> Element? {
        let pageIndex = index.currentIndex.page
        let sectionIndex = index.currentIndex.section
        let elementIndex = index.currentIndex.element
        guard pageIndex < pages.count && sectionIndex < pages[pageIndex].sections.count && elementIndex < pages[pageIndex].sections[sectionIndex].count else {
            return nil
        }
        return self[index]
    }
    
    private func sectionsSize() -> [[Int]] {
        var sectionsSize = [[Int]]()
        for page in pages {
            var pagesSize = [Int]()
            for section in page.sections {
                pagesSize.append(section.count)
            }
            sectionsSize.append(pagesSize)
        }
        return sectionsSize
    }
    
}

public struct BookIndex: ForwardIndexType {
    
    let sectionsSize: [[Int]]
    let currentIndex: (page: Int, section: Int, element: Int)
    
    public func successor() -> BookIndex {
        let currentSectionMax = sectionsSize[currentIndex.page][currentIndex.section]
        let newIndex: (Int, Int, Int)
        if currentIndex.element < currentSectionMax {
            newIndex = (currentIndex.page, currentIndex.section, currentIndex.element + 1)
        }
        else {
            let currentPageMax = sectionsSize[currentIndex.page].count
            if currentIndex.section < currentPageMax {
                newIndex = (currentIndex.page, currentIndex.section + 1, 0)
            }
            else {
                newIndex = (currentIndex.page + 1, 0, 0)
            }
        }
        return BookIndex(sectionsSize: sectionsSize, currentIndex: newIndex)
    }
    
}

public func ==(lhs: BookIndex, rhs: BookIndex) -> Bool {
    return lhs.sectionsSize == rhs.sectionsSize && lhs.currentIndex.page == rhs.currentIndex.page && lhs.currentIndex.section == rhs.currentIndex.section && lhs.currentIndex.element == rhs.currentIndex.element
}
