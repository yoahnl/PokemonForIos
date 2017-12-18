//
//  NewZone.swift
//  RPGTest
//
//  Created by Yoahn on 13/12/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import SpriteKit
import GameplayKit

class NewZone: Controller
{
    override func getPositionAtloadTime() -> CGPoint
    {
        switch Info.LastSceneLoad
        {
        case "GameScene"?:
            var playerPosition = self.childNode(withName: "Exit_GameScene")?.position;
            playerPosition?.y += 50;
            return playerPosition!
        default:
            return CGPoint(x: 0, y: 0);
        }
    }
    
    override func didMove(to view: SKView)
    {
        self.currentZone = "NewZone";
        let playerPosition = getPositionAtloadTime();
        SetView(point: playerPosition);
        Info.LastSceneLoad = self.currentZone;
    }

}
