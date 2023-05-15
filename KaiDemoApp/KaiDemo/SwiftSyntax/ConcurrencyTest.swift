//
//  ConcurrencyTest.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/10.
//

import Foundation

// Concurrency is only available in iOS 13.0.0 or newer
@available(iOS 13.0, *)
private func fetchUserID(from server: String) async -> Int {
    if server == "primary" {
        return 97
    }
    
    for char in server.unicodeScalars {
    }
    return 501
}

@available(iOS 13.0, *)
func fetchUsername(from server: String) async -> String {
    let userID = await fetchUserID(from: server)
    if userID == 501 {
        return "KaiKai"
    }
    return "Guest"
}

@available(iOS 13.0, *)
func connectUser(to server: String) async -> String {
    async let userID = fetchUserID(from: server)
    async let username = fetchUsername(from: server)
    let greeting = await "Hello \(username), user ID \(userID)"
    print("in ConcurrencyTest.swift \(greeting) tid=\(Thread.current)")
    return greeting
}

class ConcurrencyTest : NSObject {
    
    static func entry() {
        print("\n----------    in Concurrency Test    ----------")
        if #available(iOS 13.0, *) {
            print("lookKai before Task {}")
            let task = Task { // 'Task' is only available in i0S 13.0 or newer
                return await connectUser(to: "KaiKai")
            }
            print("lookKai end Task \(task)")
//          let result = wait task.value
            
            print("lookKai before Task2, thread=", Thread.current)
            Task {
                print("lookKai before Task2 in task")
                let _result = await connectUser(to: "primary")
                print("lookKai end Task2 in task, result=", _result, Thread.current)
                
                // 如果无await 为何错误提示： Expression is 'async' but is not marked with 'await'
                // 也许swift 5.x语法修改过了？
                await ConcurrencyTest.afterTaskFlushUI()
                await ConcurrencyTest().afterTaskFlushUI2()
            }
            print("lookKai end Task2")
        } else {
            // Fallback on earlier versions
        }

//        async let firstPhoto = downloadPhoto(named: photoNames[0])
//        async let secondPhoto = downloadPhoto(named: photoNames[1])
//        async let thirdPhoto = downloadPhoto(named: photoNames[2])
//        let photos = await [firstPhoto, secondPhoto, thirdPhoto]
//        show(photos)
    }
    
    @MainActor
    static func afterTaskFlushUI() {
        print("lookKai in ConcurrencyTest.swift  afterTaskFlushUI, thread=", Thread.current)
    }
    
    @MainActor
    func afterTaskFlushUI2() {
        print("lookKai in ConcurrencyTest.swift  afterTaskFlushUI2, thread=", Thread.current)
    }
}
