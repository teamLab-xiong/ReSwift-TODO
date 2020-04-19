//
//  Cache.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation

struct TODOS {
    var todos: [TODO]
}
extension TODOS: Codable {}

final class Cache {
    static let shared = Cache()
    
    let ioQueue = DispatchQueue(label: "todo.cache.label")
    let callbackQueue = DispatchQueue.main
    
    private lazy var directory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    private init() {
        
    }
    
    var todos: [TODO] {
        guard let data = try? Data(contentsOf: self.directory.appendingPathComponent(.cacheFile)),
            let todos = try? JSONDecoder().decode(TODOS.self, from: data) else {
                return []
        }
        
        return todos.todos
    }
    
    func todos(_ callback: @escaping (([TODO]) -> Void)) {
        ioQueue.async {
            guard let data = try? Data(contentsOf: self.directory.appendingPathComponent(.cacheFile)),
                let todos = try? JSONDecoder().decode(TODOS.self, from: data) else {
                    self.callbackQueue.async { callback([]) }
                    return
            }
                
            self.callbackQueue.async {
                callback(todos.todos)
            }
        }
    }
    
    func insert(_ todo: TODO) {
        todos { results in
            var todos = results
            todos.append(todo)
            self.store(.init(todos: todos))
        }
    }
    
    func remove(_ todo: TODO) {
        todos { results in
            var todos = results
            todos.removeAll { $0 == todo }
            self.store(.init(todos: todos))
        }
    }
    
    func store(_ todos: TODOS) {
        ioQueue.async {
            if let data = try? JSONEncoder().encode(todos) {
                try! data.write(to: self.directory.appendingPathComponent(.cacheFile))
            }
        }
    }
    
    func clear() {
        try? FileManager.default.removeItem(at: directory.appendingPathComponent(.cacheFile))
    }
}

extension String {
    static let cacheFile = "cache.json"
}