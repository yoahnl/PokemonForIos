//
//  House_Inside.swift
//  RPGTest
//
//  Created by Yoahn on 22/11/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import SpriteKit
import GameplayKit

class HouseInside: Controller
{
    override func getPositionAtloadTime() -> CGPoint
    {
        switch Info.LastSceneLoad
        {
        case "House"?:
            var playerPosition = self.childNode(withName: "Back_House")?.position;
            playerPosition?.y += 50;
            return playerPosition!
        default:
            return CGPoint(x: 0, y: 0);
        }
    }
    
    override func didMove(to view: SKView)
    {
        self.currentZone = "HouseInside";
        let playerPosition = getPositionAtloadTime();
        SetView(point: playerPosition);
        Info.LastSceneLoad = self.currentZone;
    }
}


