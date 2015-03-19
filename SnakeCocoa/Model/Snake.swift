//
//  Snake.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation


class Snake : StageElementDirectable {
    
    weak var delegate: SnakeDelegate?
    
    var moveTimer: NSTimer!
    var speed: NSTimeInterval = 0.5 {
        didSet {
            if speed < 0.05 {
                speed = oldValue
            }
        }
    }
    let speedDelta = 0.025
    
    init() {
        super.init(location: nil, direction: Direction.randomDirection())
        
        scheduleMoveTimer()
    }
    
    func scheduleMoveTimer() {
        moveTimer = NSTimer(timeInterval: speed,
            target: self,
            selector: "move",
            userInfo: nil,
            repeats: true)
        NSRunLoop.mainRunLoop().addTimer(moveTimer, forMode: NSDefaultRunLoopMode)
        moveTimer.fire()
    }
    
    func move() {
        if let _delegate = delegate {
            location = _delegate.moveSnake(self)
            resetDirectionState()
        }
    }
    
    func kill() {
        delegate = nil
        moveTimer.invalidate()
        moveTimer = nil
    }
    
    func didEatApple() {
        speed -= speedDelta
        scheduleMoveTimer()
    }
   
}

protocol SnakeDelegate : class {
    func moveSnake(snake: Snake) -> StageLocation?
}


