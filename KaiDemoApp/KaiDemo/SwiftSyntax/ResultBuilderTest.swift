//
//  ResultBuilderTest.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/11.
//

import Foundation

protocol Drawable {
    func draw() -> String
}

struct Line : Drawable {
    var elements: [Drawable]
    func draw() -> String {
        return elements.map { $0.draw() }.joined(separator: "")
    }
}

struct Text : Drawable {
    var content: String
    init(_ content: String) {
        self.content = content
    }
    func draw() -> String {
        return content
    }
}

struct Space : Drawable {
    func draw() -> String {
        return " "
    }
}

struct Stars : Drawable {
    var length: Int
    func draw() -> String {
        return String(repeating: "*", count: length)
    }
}

struct AllCaps : Drawable {
    var content: Drawable
    func draw() -> String {
        return content.draw().uppercased()
    }
}

@resultBuilder
struct DrawingBuilder {
    static func buildBlock(_ components: Drawable...) -> Drawable {
        return Line(elements: components)
    }
    static func buildEither(first: Drawable) -> Drawable {
        return first
    }
    static func buildEither(second: Drawable) -> Drawable {
        return second
    }
}

func draw(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return content()
}

func caps(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return AllCaps(content: content())
}

func makeGreeting(for name: String? = nil) -> Drawable {
    let greeting = draw {
        Stars(length: 3)
        Text("Hello")
        Space()
        caps {
            if let name = name {
                Text(name + "!")
            } else {
                Text("World!")
            }
        }
        Stars(length: 2)
    }
    return greeting
}

extension DrawingBuilder {
    static func buildArray(_ components: [Drawable]) -> Drawable {
        return Line(elements: components)
    }
}

class ResultBuilderTest {
    
    static func entry() {
        print("\n-----------    in ResultBuilder Test   ----------")
        let name: String? = "Ravi Patel"
        let manualDrawing = Line(elements: [
            Stars(length: 3),
            Text("Hello"),
            Space(),
            AllCaps(content: Text((name ?? "World") + "!")),
            Stars(length: 2),
        ])
        print("draw1:", manualDrawing.draw()) //draw1: ***Hello RAVI PATEL!**
        
        let genericGreeting = makeGreeting()
        print("draw2:", genericGreeting.draw()) //打印"***Hello WORLD!**"
        
        let personalGreeting = makeGreeting(for: "Ravi Patel")
        print("draw3:", personalGreeting.draw())// 打印"***Hello RAVI PATEL!**"
        
        let manyStars = draw {
            Text("Stars:")
            for length in 1...3 {
                Space()
                Stars(length: length)
            }
        }
        print("draw4:", manyStars.draw()) // draw4: Stars: * ** ***
    }
}

