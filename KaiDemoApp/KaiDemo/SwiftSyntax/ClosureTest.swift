//
//  ClosureTest.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/10.
//

import Foundation

// 注意闭包强引用导致内存泄露
fileprivate class A {
    var completionHandlers: [() -> Void] = []
    var closure: (() -> Void)? //可能循环引用
    
    func function() {
        print("invoke function")
    }
    func function2() {
        print("invoke function2")
    }
    init() {
        print("memory leak class init")
        closure = function//析构方法未调用，无输出
//下面这种方式也是一样的结果，因为不能改变对function是强引用的事实
//weak let weakSelf = self
//closure = weakSelf?.function
        
        closure = { [weak self] in
            self?.function()
        }
    }
    deinit {
        print("memory leak class deinit")
    }
    func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
//                            completionHandlers.append(completionHandler)
//                            closure = completionHandler
        DispatchQueue.main.async {
            completionHandler()
        }
    }
    func someFunctionWithNonescapingClosure(closure: () -> Void) {
        closure()
    }
}

private class SomeClass {
    var x = 10
    func doSomething() {
        let a = A()
        a.someFunctionWithEscapingClosure { [weak self] in
            //实测加weak随即释放，不加直到async执行完成才释放
            print("\nClosureTest.swift inEscapingClosure x=\(self?.x ?? -1)");
            self?.x = 100
        } //Reference to property 'x' in closure requires explicit use of 'self' to make capture semantics explicit
        a.someFunctionWithNonescapingClosure {
            print("inNone escapingClosure x=\(x)");
            x = 200
        }
    }
    func serve(run: Bool, customer customerProvider: @autoclosure () -> String) {
        if (run) {
            print("Now run closure, serving I(customerProvider())!")
        } else {
            print("no run closure")
        }
    }
    deinit {
        print("SomeClass @escaping deinit")
    }
}

class Chessboard {
    var testValue: Int = 100
    var testValue2: Int = 1000
//如果你使用闭包来初始化属性，请记住在闭包执行时，实例的其它部分都还没有初始化。
//这意味着你不能在闭包里访问其它属性，即使这些属性有默认值。
//同样，你也不能使用隐式的self 属性，或者调用任何实例方法。
    let boardColors: [Bool] = {
        var temporaryBoard: [Bool] = []
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
//                    print(self.testValue) // Cannot find 'self' in scope
//                    print(testValue) // Cannot use instance member 'testValue' within property initializer; property initializers run before 'self' is available
        return temporaryBoard
    }() // ()执行闭包
    
    lazy var xxxTest: String = {
        testValue += 1
        return String(testValue)
    }() //闭包初始化属性未强引用self
    
    lazy var xxxTest2 = { [unowned self] in
        self.testValue2 += 1
        return String(self.testValue2)
    }
    
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        boardColors[(row * 8) + column]
    }
    deinit {
        print("Chessboard deinit xxxTest=\(xxxTest)")
    }
}

class ClosureTest {
    static func entry() {
        print("\n----------    in Closure Test    ----------")
        let a = A()
        a.closure?()
//        a.closure = a.function2 // 析构方法未调用，无输出
        a.closure = { [weak a] in
            a?.function2()
        }
        a.closure?()
        
        let b = SomeClass()
        b.doSomething()
        
        var customersInLine = ["kai1", "kai2", "kai3"]
        let beforeCount = customersInLine.count
        b.serve(run: true, customer: customersInLine.remove(at: 0))
        b.serve(run: false, customer: customersInLine.remove(at: 0))
        print("customersInLine beforeCount=\(beforeCount) count=\(customersInLine.count)")
        
        let board = Chessboard()
        print(board.squareIsBlackAt(row: 0, column: 1)) // true
        print(board.squareIsBlackAt(row: 7, column: 7)) // false
        print(board.xxxTest2())
        print(board.xxxTest2())
        let _ = board.testValue
        
        var stepSize = 10
        func increment(_ number: inout Int) {
            number += stepSize
        }
        func increment2(_ number: inout Int) {
            let xx = stepSize / 2//即使拆成2句也访问冲突crash
            number += xx
        }

//crash: Simultaneous accesses to 0x600000flac70, but modification requires exclusive access.
        increment(&stepSize)
    }
}


















