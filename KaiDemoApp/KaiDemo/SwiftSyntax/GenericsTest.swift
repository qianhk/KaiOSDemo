//
//  GenericsTest.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/10.
//

import Foundation

struct Stack<E> {
    var items: [E] = []
    mutating func push(_ item: E) {
        items.append(item)
    }
    mutating func pop() -> E {
        items.removeLast()
    }
}

fileprivate protocol Container {
    associatedtype ItemType
    associatedtype ItemType2 : Equatable

//添加一个新元素到容器里
    mutating func append(_ item: ItemType)

//获取容器中元素的数
    var count: Int { get }

//通过索引值类型为 Int的下标检索到容器中的每一个元素
    subscript(i: Int) -> ItemType { get }
}

class Stack2<E, E2 : Equatable> : Container {
    var items: [E] = []
    func push(_ item: E) {
        items.append(item)
    }
    func pop() -> E {
        items.removeLast()
    }

// Container 协议的实现部分
    typealias ItemType = E
    typealias ItemType2 = E2
    func append(_ item: E) {
        push(item)
    }
    var count: Int {
        items.count
    }
    subscript(i: Int) -> E {
        items[i]
    }
}

private func makeOneContainer(type: Int) -> any Container {
    if (type == 0) {
        return Stack2<Int, String>()
    } else {
        return Array<String>()
    }
}

extension Array : Container {
    typealias ItemType = Element
    typealias ItemType2 = Int
}

private func allItemsMatch<C1 : Container, C2 : Container>
        (_ someContainer: C1, _ anotherContainer: C2) -> Bool
        where C1.ItemType == C2.ItemType, C1.ItemType : Equatable {
//检查两个容器含有相同数量的元素
    if someContainer.count != anotherContainer.count {
        return false
    }
// 检查每一对元素是否相等
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
//所有元素都匹配，返回 true
    return true
}

extension Stack {
    var topItem: E? {
        items.isEmpty ? nil : items[items.count - 1]
    }
}

extension Stack where E : Equatable {
    func isTop(_ item: E) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

protocol Shape {
    func draw() -> String
}

private struct Triangle : Shape {
    var size: Int
    func draw() -> String {
        var result: [String] = []
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}

private struct Square : Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

private struct JoinedShape<T : Shape, U : Shape> : Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        top.draw() + "\n" + bottom.draw()
    }
}

// 'some' return types are only available in iOS 13.0.0 or newer
@available(iOS 13.0, *)
func makeTrapezoid(type: Int) -> some Shape {
    JoinedShape(top: Triangle(size: 2), bottom: Square(size: 2))
}

func makeTrapezoid2(type: Int) -> any Shape {
    if (type == 0) {
        return JoinedShape(top: Triangle(size: 2), bottom: Square(size: 2))
    } else {
        return JoinedShape(top: Square(size: 2), bottom: Square(size: 2))
    }
}

@available(iOS 13.0, *)
func makeTrapezoid3(type: Int) -> some Shape {
    if (type == 0) {
        return JoinedShape(top: Triangle(size: 2), bottom: Square(size: 2))
    } else {
        return JoinedShape(top: Triangle(size: 3), bottom: Square(size: 2))
    }
}

internal class GenericsTest {
    static func entry() {
        print("\n----------    in Generics Test    ----------")
        var stackOfStrings = Stack<String>()
        print("字符串元素栈：")
        stackOfStrings.push("google")
        stackOfStrings.push("runoob")
        print(stackOfStrings.items)
        
        let _ = stackOfStrings.isTop("g")
        
        let deletetos = stackOfStrings.pop()
        let top = stackOfStrings.topItem
        print("出栈元素：" + deletetos, "top", top)
        
        var stackOfInts = Stack2<Int, Int>()
        print("整数元素栈：")
        stackOfInts.push(1)
        stackOfInts.push(2)
        print(stackOfInts.items);
        
        var tos = Stack2<String, Int>()
        tos.push("google")
        tos.push("runoob")
        tos.push("taobao")
        
        let aos = ["google", "runoob", "taobao"]
        if allItemsMatch(tos, aos) {
            print("allItemsMatch1：匹配所有元素")
        } else {
            print("allItemsMatch1:元素不匹配")
        }
        let aosInt = [1, 1]
        if allItemsMatch(stackOfInts, aosInt) {
            print("al1ItemsMatch2:匹配所有元素")
        } else {
            print("allItemsMatch2：元素不匹配")
        }
        
        struct NotEquatable {
        }
        
        var notEquatableStack = Stack<NotEquatable>()
        let notEquatableValue = NotEquatable()
        notEquatableStack.push(notEquatableValue)
//报错 Referencing instance method'isTop'on‘Stack'requires that‘NotEquatable' conform to 'Equatable'
//        notEquatableStack.isTop(notEquatableValue)
    }
}

//不加fileprivate会编译失败：Invalid redeclaration of 'TestTwoSampleClass
// 加了fileprivate后能编译通过但变成了：TtC9KaiOSDemoP33_945A96B1B1C50605B3CB3D88571F188318TestTwoSampleClass
fileprivate class TestTwoSampleClass {
    func testFunInGenericsTestFile() -> Void {
    }
}
