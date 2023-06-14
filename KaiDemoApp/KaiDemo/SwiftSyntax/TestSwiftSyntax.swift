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
        print("\n----------   in Swift Syntax Test    ----------")
        let anInt = 98765
        let sub = anInt[1]
        var ocData = OCTestData()
        let arrayTest = ocData.arrayTest
        ocData.name = "KaiKai"
        ocData.index = 123
        ocData.arrayTest = ["V1", 666];
        print("lookKai inSwift ocData1=\(ocData.description) sub=\(sub)")
        ocData.otherStr = "otherStrInSwift"
        //        ocData.otherDic = {"k1": "v1", "k2": "888"}
        let nums = [1, 7, 3, 6, 5, 6]
        let total = nums.reduce(0) { $0 + $1  }
        var leftSum: Int = 0
        var sameIdx = -1
        for (idx, n) in nums.enumerated() {
            if leftSum + n + leftSum == total {
                sameIdx = idx
                break
            }
            leftSum += n
        }
        
        print("lookKai inSwift ocData2=\(ocData) total=\(total) sameIdx=\(sameIdx)")
        
        let s = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~  abcdefghijklmnopqrstuvwxyzABCD"
        let t = "\"bcdefg&ijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!a#$%h'()*+,-./:;<=> @[\\]^_`{|}~?\"bcdefg&ijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!a#$%h'()*+,-./:;<=> @[\\]^_`{|}~?\"bcdefg&ijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!a#$%h'()*+,-./:;<=> @[\\]^_`{|}~?\"bcdefg&ijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!a#$%h'()*+,-./:;<=>  @[\\]^_`{|}~?\"bcdefg&ijklmnopqrstuvwxyzA@CD"
        print("leetCode205 \(leetCode205("egg", "add"))  \(leetCode205("kaa", "gxy"))  \(leetCode205("kai", "gxx"))")
        //        print("leetCode205 \(leetCode205(s, t)) ")
        print("leetCode205 2 \(leetCode205_2("egg", "add"))  \(leetCode205_2("kaa", "gxy"))  \(leetCode205("kai", "gxx"))")
        //        print("leetCode205 2 \(leetCode205_2(s, t)) ") // 在leetCode上两种方法均会 超出时间限制    }
    }
    
    func leetCode205(_ s:String, _ t:String) -> Int {
        var s2tDic:[Character:Character] = [:]
        var t2sDic:[Character:Character] = [:]
        var result = 0
        for (idx, c1) in s.enumerated() {
            let c2 = t[t.index(t.startIndex, offsetBy: idx)]
            let xxx = s2tDic[c1]
            if (xxx != nil && xxx != c2 ) {
                result = 1
                break
            }
            if (t2sDic[c2] != nil && t2sDic[c2] != c1) {
                result = 2
                break
            }
            if (xxx == nil) {
                s2tDic[c1] = c2
                t2sDic[c2] = c1
            }
        }
        return result
    }
    
    func leetCode205_2(_ s:String, _ t:String) -> Int {
        var ss:[Int] = Array(repeating: 0, count: 128)
        var tt:[Int] = Array(repeating: 0, count: 128)
        var tIndex = t.startIndex
        var result = 0
        for (idx, c1) in s.enumerated() {
            tIndex = t.index(t.startIndex, offsetBy: idx)
            let si = Int(c1.asciiValue!)
            let ti = Int(t[tIndex].asciiValue!)
            if (ss[si] != 0 && ss[si] != ti) {
                result = 1
                break
            }
            if (tt[ti] != 0 && tt[ti] != si) {
                result = 2
                break
            }
            ss[si] = ti
            tt[ti] = si
        }
        return result
    }
}
