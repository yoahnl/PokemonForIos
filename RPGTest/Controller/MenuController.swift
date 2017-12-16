//
//  MenuController.swift
//  RPGTest
//
//  Created by Yoahn on 23/11/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import SpriteKit

class MenuController: SKScene
{
    
    var PreviousView: String?;
    var time: String?;
    var batteryLevel: Int {
        return Int(round(UIDevice.current.batteryLevel * 100))
    }
    
    func getBatterieLevel()
    {
        let batterieLabel: SKLabelNode = (self.childNode(withName: "Batterie"))! as! SKLabelNode;
        batterieLabel.text =  String(batteryLevel);
    }
    func getCurrentTime()
    {
        let hh2 = (Calendar.current.component(.hour, from: Date()));
        let mm2 = (Calendar.current.component(.minute, from: Date()));
        time = "\(hh2) : \(mm2)";
        let timeLabel: SKLabelNode = (self.childNode(withName: "Time"))! as! SKLabelNode;
        timeLabel.text = time;
    }
    
    func makeAction(move: UITouch)
    {
        let location = move.previousLocation(in: self)
        let node = self.nodes(at: location).first
        
        var nodeArr: [SKNode] = [];
        
        nodeArr.append(node!);
        
        animateNodes(nodeArr);
        switch  node?.name
        {
        case "return"?:
            let gameScene: SKScene?;
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.3);
            print("Info.LastSceneLoad =  \(Info.LastSceneLoad!)");
            gameScene = SKScene(fileNamed: PreviousView!);
            self.view?.presentScene(gameScene!, transition: transition);
        default:
            break;
        }
    }
    
    func animateNodes(_ nodes: [SKNode])
    {
        for (index, node) in nodes.enumerated()
        {
            // Offset each node with a slight delay depending on the index
            
            // Scale up and then back down
            
            let scaleUpAction = SKAction.scale(to: 1.6, duration: 0.3)
            let scaleDownAction = SKAction.scale(by: 1.6, duration: 0.3)

            let actionSequence = SKAction.sequence([scaleUpAction, scaleDownAction]);
            
            // Run the action
            node.run(actionSequence)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let move = touches.first
        {
            makeAction(move: move);
        }
    }
    
    override func didMove(to view: SKView)
    {
        getCurrentTime();
        getBatterieLevel();
        print("fonction didMove called !");
        self.PreviousView = Info.LastSceneLoad;
        Info.LastSceneLoad = "MenuController";
        print(batteryLevel);
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        getCurrentTime();
    }
}
