//
//  SnakeViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 3/2/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit

class SnakeViewController: UIViewController {

    
    // MARK: Properties
    
    @IBOutlet var stageView: StageView!
    @IBOutlet weak var snakeView: SnakeView!
    var appleView: AppleView!
    
    var appleRadius: CGFloat = 5.0
    var snakeWidth: CGFloat = 10.0
    
    var animationTimer : NSTimer!
    var defaultAnimationTimeInteral: NSTimeInterval = 0.05
    var animationTimerInterval: NSTimeInterval = 0.05 {
        didSet {
            if animationTimerInterval <= 0 {
                animationTimerInterval = oldValue
            }
        }
    }
    var animationDelta = 0.05
    
    var rightSwipeGS: UISwipeGestureRecognizer!
    var leftSwipeGS: UISwipeGestureRecognizer!
    var upSwipeGS: UISwipeGestureRecognizer!
    var downSwipeGS: UISwipeGestureRecognizer!
    
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up gesture recogninzers
         setUpGestureRecognizers()

        
        // Do any additional setup after loading the view.
        startGame()
        
    }
    
    // MARK: Instance Methods
    
    func setUpGestureRecognizers() {
        
        // Right Direction
        rightSwipeGS = UISwipeGestureRecognizer(target: self, action: "swipe:")
        rightSwipeGS.numberOfTouchesRequired = 1
        rightSwipeGS.direction = UISwipeGestureRecognizerDirection.Right
        snakeView.addGestureRecognizer(rightSwipeGS)
        
        // Left Direction
        leftSwipeGS = UISwipeGestureRecognizer(target: self, action: "swipe:")
        leftSwipeGS.numberOfTouchesRequired = 1
        leftSwipeGS.direction = UISwipeGestureRecognizerDirection.Left
        snakeView.addGestureRecognizer(leftSwipeGS)
        
        // Up Direction
        upSwipeGS = UISwipeGestureRecognizer(target: self, action: "swipe:")
        upSwipeGS.numberOfTouchesRequired = 1
        upSwipeGS.direction = UISwipeGestureRecognizerDirection.Up
        snakeView.addGestureRecognizer(upSwipeGS)
        
        // Down Direction
        downSwipeGS = UISwipeGestureRecognizer(target: self, action: "swipe:")
        downSwipeGS.numberOfTouchesRequired = 1
        downSwipeGS.direction = UISwipeGestureRecognizerDirection.Down
        snakeView.addGestureRecognizer(downSwipeGS)
        
    }
    
    func startGame() {
        
        // Set up stage
        // Set the stage grid unit size and get linear scaled dimensions
        // TODO: Check what happens if the orientation is not portrait
        stageView.gridUnitSize = 10.0
        
        let xLowerBound: Float = 0
        let yLowerBound: Float = 0
        let xUpperBound: Float = Float(stageView.scaledWidth)
        let yUpperBound: Float = Float(stageView.scaledHeight)
        
        //Create an apple
        let apple = Apple(xLowerBound: xLowerBound, xUpperBound: xUpperBound, yLowerBound: yLowerBound, yUpperBound: yUpperBound, randomize: false)
        //Create an apple view
        appleView = AppleView(apple: apple, appleRadius: appleRadius)
        appleView.xOffset = stageView.originX
        appleView.yOffset = stageView.originY
        appleView.scaleFactor = stageView.gridUnitSize
        stageView.addSubview(appleView)
        stageView.sendSubviewToBack(appleView)
        
        // Create a snake
        let snake = Snake(xLowerBound: xLowerBound, xUpperBound: xUpperBound, yLowerBound: yLowerBound, yUpperBound: yUpperBound)
        //Configure the snake view
        snakeView.snake = snake
        snakeView.snakeWidth = snakeWidth
        snakeView.scaleFactor = stageView.gridUnitSize
        snakeView.xOffset = stageView.originX
        snakeView.yOffset = stageView.originY
        stageView.bringSubviewToFront(snakeView)
        
        // Schedule animation timer
        scheduleAnimationTimer()
    }
    
    func endGame() {
        
        // Stop animating
        animationTimer.invalidate()
        animationTimerInterval = defaultAnimationTimeInteral
        snakeView.clearView()
        
        appleView.removeFromSuperview()
        appleView = nil

    }
    
    func restartGame() {
        endGame()
        startGame()
    }
    
    func scheduleAnimationTimer() {
        
        // Create timer
        animationTimer = NSTimer(timeInterval: animationTimerInterval,
            target: self,
            selector: "move:",
            userInfo: nil,
            repeats: true)
        
        // Schedule the timer
        // TODO: Schedule the timer not in the main thread
        NSRunLoop.currentRunLoop().addTimer(animationTimer, forMode: NSDefaultRunLoopMode)
        animationTimer.fire()

    }
    
    // MARK: IBAction and targets
    
    func move(timer: NSTimer){
        
        
        // Check if the snake did eat an apple
        let didEatApple = CGRectIntersectsRect(snakeView.snakeHeadRect!, appleView.frame)
        let collision = false
        
        if didEatApple {
            println("The snake ate an apple")
            
            // Invalidate animation timer. It should be rescheduled with a smaller timerInterval
            animationTimer.invalidate()
            
            // Generate a new apple
            appleView.apple.updateLocation()
            appleView.resizeFrame()  // FIXME: Who should be in charge of trigerring this call, controller or delegate?
            appleView.setNeedsDisplay()
            
            // Snake should grow
            snakeView.snake!.grow()
            
        }else { // Check for collisions
            
            var collision : Bool = false
            
            // Border collision
            for border in stageView.stageBorders {
                collision = CGRectIntersectsRect(snakeView.snakeHeadRect!, border)
                if collision {
                    animationTimer.invalidate()
                    break
                }
            }
            
            // Itself collision
            if !collision {
                if let bodyParts = snakeView.bodyPartsRects {
                    for bodyPart in bodyParts {
                        collision = CGRectIntersectsRect(snakeView.snakeHeadRect!, bodyPart)
                        if collision {
                            animationTimer.invalidate()
                            break
                        }
                    }
                }
            }
            
            if collision {
                println("Oh snap! Collision!")
                restartGame()
            }
        }
        
        if !collision {
            snakeView.snake?.move(false)
            snakeView.setNeedsDisplay() //FIXME: Who should be in charge of trigerring this call, controller or delegate?
        }
        
        if didEatApple{
            
            // Schedule animation timer with a smaller timeInterval
            animationTimerInterval -= animationDelta
            scheduleAnimationTimer()
        }
    }
    
    func swipe(gestureRecognizer: UISwipeGestureRecognizer) {
        
        // Detect direction
        let direction = gestureRecognizer.direction
        
        if gestureRecognizer.direction == rightSwipeGS.direction {
            snakeView.steerSnake(Direction.Right)
        }
        
        if gestureRecognizer.direction == leftSwipeGS.direction {
            snakeView.steerSnake(Direction.Left)
        }
        
        if gestureRecognizer.direction == upSwipeGS.direction {
            snakeView.steerSnake(Direction.Up)
        }
        
        if gestureRecognizer.direction == downSwipeGS.direction {
            snakeView.steerSnake(Direction.Down)
        }
    }
    
}
