//
//  StageConfigurator.swift
//  SnakeSwift
//
//  Created by eandrade21 3/12/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import XCTest

class StageConfiguratorLevel1Test: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProperties_10x10() {
        
        // Create a StageConfigurator
        let size = StageSize(width: 10, height: 10)
        let stageConfigurator = StageConfiguratorLevel1(size: size)
        let obstacles = stageConfigurator.elements[Obstacle.className()]!
        let loopHoles = stageConfigurator.elements[LoopHole.className()]!
        let elementsIntersection = obstacles.intersects(loopHoles)
        
        // Validate properties
        XCTAssertEqual(obstacles.count, 38, "Stage should have 38 obstacles")
        XCTAssertEqual(loopHoles.count, 0, "Stage should have 0 loopHoles")
        XCTAssertEqual(elementsIntersection, [], "Obstacles and loopHoles should not intersect")
        
    }

}
