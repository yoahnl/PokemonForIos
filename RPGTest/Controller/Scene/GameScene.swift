//
//  GameScene.swift
//  RPGTest
//
//  Created by Yoahn on 20/11/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: Controller
{
	override func getPositionAtloadTime() -> CGPoint
	{
		switch Info.LastSceneLoad
		{
		case "House"?:
			var playerPosition = self.childNode(withName: "House")?.position;
			playerPosition?.y -= 100;
			return playerPosition!;
		case "NewZone"?:
			var playerPosition = self.childNode(withName: "Exit_NewZone")?.position;
			playerPosition?.y -= 100;
			return playerPosition!;

		case "MenuController"?:
			let playerPosition = Info.MenuSaveLocation;
			return playerPosition!;
		default:
			return CGPoint(x: 0, y: 0);
			
		}
	}	
}
