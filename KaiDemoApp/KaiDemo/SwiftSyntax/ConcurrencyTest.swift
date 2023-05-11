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
    print("in ConcurrencyTest.swift \(greeting)")
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
//          print("lookKai end Task2: \(result)")
        } else {
            // Fallback on earlier versions
        }

//        async let firstPhoto = downloadPhoto(named: photoNames[0])
//        async let secondPhoto = downloadPhoto(named: photoNames[1])
//        async let thirdPhoto = downloadPhoto(named: photoNames[2])
//        let photos = await [firstPhoto, secondPhoto, thirdPhoto]
//        show(photos)
    
    }
}
