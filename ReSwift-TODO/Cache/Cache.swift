//
//  Cache.swift
//  ReSwift-TODO
//
//  Created by Xiong Ju 熊炬 on 2020/4/19.
//  Copyright © 2020 Xiong Ju 熊炬. All rights reserved.
//

import Foundation

final class Cache {
    static let shared = Cache(name: "default")
    
    let ioQueue = DispatchQueue(label: "todo.cache.label")
    let callbackQueue = DispatchQueue.main
    
    private lazy var directory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    private var cacheFileName: String
    
    init(name: String) {
        cacheFileName = name + "-" + .cacheFile
    }
    
    var todos: [TODO] {
        guard let data = try? Data(contentsOf: self.directory.appendingPathComponent(cacheFileName)),
            let todos = try? JSONDecoder().decode(TODOS.self, from: data) else {
                return []
        }
        
        return todos.todos.sorted { $0.date > $1.date}
    }
    
    private func todos(_ callback: @escaping (([TODO]) -> Void)) {
        ioQueue.async {
            guard let data = try? Data(contentsOf: self.directory.appendingPathComponent(self.cacheFileName)),
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
            self.store(todos)
        }
    }
    
    func remove(_ todo: TODO) {
        todos { results in
            var todos = results
            todos.removeAll { $0 == todo }
            self.store(todos)
        }
    }
    
    func store(_ todos: [TODO]) {
        let tobeStored = TODOS(todos: todos)
        ioQueue.async {
            if let data = try? JSONEncoder().encode(tobeStored) {
                try! data.write(to: self.directory.appendingPathComponent(self.cacheFileName))
            }
        }
    }
    
    func clear() {
        try? FileManager.default.removeItem(at: directory.appendingPathComponent(cacheFileName))
    }
}

extension String {
    static let cacheFile = "cache.json"
}

fileprivate struct TODOS {
    var todos: [TODO]
}
extension TODOS: Codable {}
