//
//  ReSwift_TODOTests.swift
//  ReSwift-TODOTests
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import XCTest
@testable import ReSwift_TODO

class ReSwift_TODOTests: XCTestCase {
    
    let cache = Cache(name: "test")

    func testCacheInsertExample() throws {
        
        let date = Date()
        let todo: TODO = .init(title: "test", message: "test message", date: date)
        
        cache.insert(todo) {
            
            let todo = self.cache.todos.first!
            
            XCTAssertEqual(todo.title, "test")
            XCTAssertEqual(todo.message, "test message")
            XCTAssertEqual(todo.date, date)
        }
    }
}
