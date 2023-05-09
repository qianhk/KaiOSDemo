//
//  TestSwiftSyntax.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/9.
//

import Foundation

public class TestSwiftSyntax : NSObject {
    
    var index: Int
    @objc
    var name: String {
        willSet {
            other = newValue
        }
    }
    var age: Int
//    @objc
//    var age2: Int? // Property cannot be marked @objc because its type cannot be represented in Objective-C
    @objc
    var other: String?
    
    public override init() {
        self.index = 0
        name = "defaultName"
        age = 0
    }
    
    deinit {
    }
    
    @objc
    func simpleDescription() -> String {
        return "TestSwiftSyntax={index=\(index) name=\(name) age=\(age) other=\(other ?? "emtpy")}"
    }
    
    @objc
    var nextYearAge: Int {
        get {
            return age + 1
        }
        set {
            age = newValue - 1
        }
    }
    
    @objc
    func demoEntryFunction() {
        
        var ocData = OCTestData()
        let arrayTest = ocData.arrayTest
        ocData.name = "KaiKai"
        ocData.index = 123
        ocData.arrayTest = ["V1", 666];
        print("lookKai inSwift ocDat1a=\(ocData.description)")
        ocData.otherStr = "otherStrInSwift"
//        ocData.otherDic = {"k1": "v1", "k2": "888"}
        print("lookKai inSwift ocData2=\(ocData)")
    }
}
