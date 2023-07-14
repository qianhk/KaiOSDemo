//
// Created by KaiKai on 2023/7/14.
//

import Foundation

struct Vector2D : CustomStringConvertible {
    var x = 0.0, y = 0.0
    
    var description: String {
        "Vector2D(x: \(x), y: \(y))"
    }
}

extension Vector2D {
    static func +(left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}

extension Vector2D {
    static prefix func -(vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

extension Vector2D {
    static func +=(left: inout Vector2D, right: Vector2D) {
//        left = left + right
        left.x += right.x
        left.y += right.y
    }
}

extension Vector2D : Equatable {
    static func ==(left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
}

class AdvancedOperatorTest {
    
    static func entry() {
        print("\n----------    in Advanced Operator Test    ----------")
        
        var vector = Vector2D(x: 3.0, y: 1.0)
        let anotherVector = Vector2D(x: 2.0, y: 4.0)
        let combinedVector = vector + anotherVector
        print("operator + : \(combinedVector)")
        
        let negative = -vector
        print("prefix operator - : \(negative)");
        
        vector += anotherVector
        print("operator += : \(vector)");
        
        let twoThree = Vector2D(x: 2.0, y: 3.0)
        let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
        if twoThree == anotherTwoThree {
            print("These two vectors are equivalent.")
        } else {
            print("These two vectors not equivalent.")
        }
    }
}
