//
//  ControlFlowEntry.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/11.
//

import Foundation

class ControlFlowEntry : NSObject {
    
    @objc static func entry() {
        GenericsTest.entry()
        print("\nbefore ConcurrencyTest.entry()")
        ConcurrencyTest.entry()
        print("\nend ConcurrencyTest.entry()")
        DispatchQueue.main.async {
            ControlFlowEntry.entry2()
        }
    }
    
    static private func entry2() {
        ClosureTest.entry()
        if #available(iOS 13.0, *) {
            let make1 = makeTrapezoid(type: 0)
            print("make1", make1)
        }
        let make2 = makeTrapezoid2(type: 1)
        print("make2=\(make2)")
        ProtocolTest.entry()
        
        DispatchQueue.main.async {
            ControlFlowEntry.entry3()
        }
    }
    
    static private func entry3() {
        SnakeAndLadderGame.entry()
        ResultBuilderTest.entry()
        TypeSelfTest.entry()
    }
}
