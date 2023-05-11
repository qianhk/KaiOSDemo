//
//  SnakeAndLadderGame.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/5/11.
//

import Foundation

class SnakeAndLadderGame {
    let finalSquare = 25
    var board: [Int]
    
    static func entry() {
        print("\n----------- SnakeAndLadderGame test   ----------")
        SnakeAndLadderGame().go()
        SnakeAndLadderGame().go2()
    }
    
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    
    private func go() {
        var square = 0
        var diceRoll = 0
        while square < finalSquare {
            //掷骰子
            diceRoll += 1
            if diceRoll >= 7 { diceRoll = 1 }
            //根据点数移动
            square += diceRoll
            if square < board.count {
                //如果玩家还在棋盘上，顺着梯子爬上去或者顺着蛇滑下去
                let oldSquare = square
                square += board[square]
                print("Gaming square=\(oldSquare) board[square]=\(board[oldSquare]) amendSquare=\(square)")
            }
        }
        print("Game over with square=\(square)")
    }
    
    private func go2() {
        var square = 0
        var diceRoll = 0
        gameLoop: while square != finalSquare {
            diceRoll += 1
            if diceRoll == 7 { diceRoll = 1 }
            switch square + diceRoll {
            case finalSquare:
                //骰子数刚好使玩家移动到最终的方格里，游戏结束。
                print("骰子数刚好使玩家移动到最终的方格里，游戏结束")
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                //骰子数将会使玩家的移动超出最后的方格，那么这种移动是不合法的，玩家需要重新掷骰子
                print("将超出方格：\(newSquare)，继续扔")
                continue gameLoop
            default:
                //正常移动
                square += diceRoll
                square += board[square]
            }
        }
        print("Game over with square=\(square)")
    }
}
