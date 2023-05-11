//
//  TypeSelfTest.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/11.
//

import Foundation

fileprivate protocol MyProtocol {
}

struct MyType : MyProtocol {
}

protocol ContentCell {
    var value: Any { get }
}

class IntCell : ContentCell {
    var value: Any
    required init(value: Int) {
//    super.init(frame: CGRect.zero)
        self.value = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StringCell : ContentCell {
    var value: Any
    
    required init(value: String) {
        //super.init(frame: CGRect.zero)
        self.value = value
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func createCell1(type: ContentCell.Type) -> ContentCell? {
    if let intCell = type as? IntCell.Type {
        return intCell.init(value: 5)
    } else if let stringCell = type as? StringCell.Type {
        return stringCell.init(value: "xx")
    }
    return nil
}

func createCell2<T : ContentCell>() -> T? {
    if let intCell = T.self as? IntCell.Type {
        return intCell.init(value: 5) as? T
    } else if let stringCell = T.self as? StringCell.Type {
        return stringCell.init(value: "xx") as? T
    }
    return nil
}

class TypeSelfTest {
    
    static func entry() {
        
        //理解Swift中的元类型：.Type与.self
        // https://juejin.cn/post/6844903725199261710
        let intMetatype: Int.Type = Int.self
        let instanceMetaType: String.Type = type(of: "string")
        let staticMetaType: String.Type = String.self
        var myNum: Any = 1
        let numlType = type(of: myNum) // Int.type
        myNum = 1.2
        let num2Type = type(of: myNum) // Double.type
        
        // Cannot convert value of type '(any MyProtocol).Type' to specified type 'any MyProtocol.Type'
        //let metatype1: MyProtocol.Type = MyProtocol.self
        let metatype2: MyProtocol.Type = MyType.self
        let protocolMetatype: MyProtocol.Protocol = MyProtocol.self
        
        let intCell = createCell1(type: IntCell.self)
        let stringCell: StringCell? = createCell2()
        print("intMetatype:", intMetatype, "instanceMetaType:", instanceMetaType, "staticMetaType:", staticMetaType
                , "num1Type:", numlType, "num2Type:", num2Type, "metatype2:", metatype2, "protocolMetatype:", protocolMetatype
                , "intCell:", intCell as Any, "intCell Value=", intCell?.value as Any
                , "stringCell:", stringCell as Any, "stringCell value=", stringCell?.value as Any)
    }
}


