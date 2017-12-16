//
//  House.swift
//  RPGTest
//
//  Created by Yoahn on 21/11/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import SpriteKit
import GameplayKit

class House: Controller
{
    override func getPositionAtloadTime() -> CGPoint
    {
        switch Info.LastSceneLoad
        {
        case "GameScene"?:
            var playerPosition = self.childNode(withName: "Back_GameScene")?.position;
            playerPosition?.y += 50;
            return playerPosition!;
        case "HouseInside"?:
            var playerPosition = self.childNode(withName: "Next_HouseInside")?.position;
            playerPosition?.y -= 50;
            return playerPosition!;
        case "MenuController"?:
            let playerPosition = Info.MenuSaveLocation;
            return playerPosition!;
        default:
            return CGPoint(x: 0, y: 0);
        }
    }
    
    override func didMove(to view: SKView)
    {
        self.currentZone = "House"
        let playerPosition = getPositionAtloadTime();
        SetView(point: playerPosition);
        Info.LastSceneLoad = self.currentZone;
    }
}

