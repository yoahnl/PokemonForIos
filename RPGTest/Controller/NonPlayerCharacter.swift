//
//  NonPlayerCharacter.swift
//  RPGTest
//
//  Created by Yoahn on 06/12/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import Foundation
import SpriteKit

class NonPlayerCharacter: SKSpriteNode
{
    var Action: String?;
    func printInfo(_ value: Any)
    {
        let types = type(of: value)
        print("'\(value)' of type '\(types)'")
    }
    
    func setupWithDict(theDict: [String: Any])
    {
        var action1: SKAction?;
        var isAction1: Bool = false;
        for (key, value) in theDict
        {
            if key == "Position"
            {
                let tmp = value as! Array<Any>;
                self.position.y = tmp[1] as! CGFloat;
                self.position.x = tmp[0] as! CGFloat;
            }
            if key == "SizeScale"
            {
                let SizeTMP = Double(value as! String)
                let toSize = CGFloat(exactly: SizeTMP! as NSNumber)
                self.size =  CGSize(width: (self.size.width) * toSize!, height: (self.size.height) * toSize!);
            }
            if key == "Action"
            {
                action1 = SKAction(named: value as! String, duration: 5)!;
                isAction1 = true;
                print("value for action = \(value)")
                Action = value as? String;
            }
        }
        
        if isAction1
        {
            let testArray: [SKAction] = [action1!];
            let group = SKAction.group(testArray);
            self.run(group);
        }
        self.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width) / 2);
        self.physicsBody?.affectedByGravity = false;
        let NPCCollisionBitMask: UInt32 = 0x1 << 0;
        
        self.physicsBody?.collisionBitMask = NPCCollisionBitMask;
    }
}
