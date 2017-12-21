//
//  MenuController.swift
//  RPGTest
//
//  Created by Yoahn on 23/11/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import SpriteKit
import Foundation

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
    
    func makeActionBegan(move: UITouch)
    {
        let location = move.previousLocation(in: self)
        let node = self.nodes(at: location).first
        
        var nodeArr: [SKNode] = [];
        
        nodeArr.append(node!);
        
        animateNodesStart(nodeArr);
        switch  node?.name
        {
        case "return"?:
            let gameScene: SKScene?;
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.3);
            print("Info.LastSceneLoad =  \(Info.LastSceneLoad!)");
            gameScene = SKScene(fileNamed: PreviousView!);
            Info.LastSceneLoad = "MenuController";
            self.view?.presentScene(gameScene!, transition: transition);
        default:
            break;
        }
    }
    
    func MakeActionEnded(move: UITouch)
    {
        let location = move.previousLocation(in: self)
        let node = self.nodes(at: location).first
        
        var nodeArr: [SKNode] = [];
        
        nodeArr.append(node!);
        animateNodesEnded(nodeArr);
        
    }
    func animateNodesStart(_ nodes: [SKNode])
    {
        for (index, node) in nodes.enumerated()
        {
            print(index);
            if node.name == "Pokemon" || node.name == "Pokedex" || node.name == "Bag" || node.name == "Trainer" || node.name == "Report" || node.name == "Settings"
            {
                let scaleUpAction: SKAction = SKAction(named: "ScaleChangeMenu")!;
                node.run(scaleUpAction);
            }
        }
    }
    
    func animateNodesEnded(_ nodes: [SKNode])
    {
        for (index, node) in nodes.enumerated()
        {
            print(index);
            if node.name == "Pokemon" || node.name == "Pokedex" || node.name == "Bag" || node.name == "Trainer" || node.name == "Report" || node.name == "Settings"
                
            {
                let scaleUpAction: SKAction = SKAction(named: "ScaleBackMenu")!;
                node.run(scaleUpAction);
                
                switch  node.name
                {
                case "Pokemon"?:
                    let GameScene: SKScene?;
                    let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 0.3);
                    print("Scene Load = PokemonController");
                    GameScene = SKScene(fileNamed: "PokemonController");
                    self.view?.presentScene(GameScene!, transition: transition);
                case "Bag"?:
                    let GameScene: SKScene?;
                    let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 0.3);
                    print("Scene Load = BagController");
                    GameScene = SKScene(fileNamed: "BagController");
                    self.view?.presentScene(GameScene!, transition: transition);

                default:
                    break;
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let move = touches.first
        {
            makeActionBegan(move: move);
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let move = touches.first
        {
            MakeActionEnded(move: move);
        }
    }
    
    override func didMove(to view: SKView)
    {
        getCurrentTime();
        getBatterieLevel();
        print("fonction didMove called !");
        self.PreviousView = Info.LastSceneLoad;
        
        Info.LastSceneLoadedMenu = "MenuController";
        print(batteryLevel);
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        getCurrentTime();
    }
}
