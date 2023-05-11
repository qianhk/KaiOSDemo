//
//  ProtocolTest.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/10.
//

import Foundation

protocol ExampleProtocol {
    init(_ no: Int)
    init(no: Int)
    var simpleDescription: String { get }
    mutating func adjust() //只给类使用不需要mutating，加了能让结构体方法修改结构体自身属性
}

protocol Protocol4Class : AnyObject {
}

struct SimpleStruct : ExampleProtocol {
    init(_ no: Int) {
    }
    init(no: Int) {
    }
    var simpleDescription: String = "kai"
    mutating func adjust() {
        simpleDescription += "_adjusted"
    }
}

class SimpleClass : ExampleProtocol, Protocol4Class {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 666
    required init(_ no: Int) {
        anotherProperty = no
    }
    required init(no: Int) {
        anotherProperty = no
    }
    func adjust() {
        simpleDescription += " Now 100% adjusted."
    }
    var readonlyCalcProperty: Int {
        anotherProperty + 1
    }
}

protocol Stname {
    var name: String { get }
}

protocol Stage {
    var age: Int { get }
}

struct Person : Stname, Stage {
    var name: String
    var age: Int
}

func show(celebrator: Stname & Stage) {
    print("\(celebrator.name) is \(celebrator.age) years old")
}

protocol AProtocol {
    func methodInProtocol();
}

extension AProtocol {
    func methodInProtocol() {
        print("methodInProtocol at protocol")
    }
    func methodNotInProtocol() {
        print("methodNotInProtocol at protocol")
    }
}

class AClass : AProtocol {
    func methodInProtocol() {
        print("methodInProtocol at AClass")
    }
    func methodNotInProtocol() {
        print("methodNotInProtocol at class")
    }
}

class ProtocolTest {
    static func entry() {
        print("\n----------   in Protocol Test    ----------")
        _ = SimpleClass(6)
        var a = SimpleClass(no: 7)
        a.adjust()
        let aDescription = a.simpleDescription
        let protocolValue: ExampleProtocol = a
        print("looKKai protocol \(protocolValue.simpleDescription) readOnly=\(a.readonlyCalcProperty)")
        var array: [AnyObject] = []
        array.append(a)
        let ttsc = TestTwoSampleClass()
        let person = Person(name: "Kai", age: 83)
        show(celebrator: person)
        let aa = AClass()
        aa.methodNotInProtocol() //输出 class（不在协议中的方法静态派发）
        (aa as AProtocol).methodNotInProtocol() //输出 protocol（不在协议中的方法静态派发）
        aa.methodInProtocol()// class（在协议中的方法动态派发）
        (aa as AProtocol).methodInProtocol() // 还是class （在协议中的方法动态派发）
    }
}

//不加fileprivate会编译失败：Invalid redeclaration of'TestTwoSampleClass'
// 加了fileprivate后能编译通过但变成了类似这种：TtC7KaiDemoP33_E1010346B919F4DFCE42853BE578AB1D18TestTwoSampleClass
fileprivate class TestTwoSampleClass {
    func testFunInProtocolTestFile() -> Void {
    }
}
