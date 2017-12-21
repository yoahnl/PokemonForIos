//
//  File.swift
//  RPGTest
//
//  Created by Yoahn on 18/12/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import Foundation

import SpriteKit

class PokemonController: SKScene
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
        
        switch  node?.name
        {
        case "return"?:
            let gameScene: SKScene?;
            let transition = SKTransition.push(with: SKTransitionDirection.right, duration: 0.3);
            print("Info.LastSceneLoadedMenu =  \(Info.LastSceneLoadedMenu!)");
            gameScene = SKScene(fileNamed: PreviousView!);
            self.view?.presentScene(gameScene!, transition: transition);
        default:
            break;
        }
    }
    
    func MakeActionEnded(move: UITouch)
    {
        
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
        self.PreviousView = Info.LastSceneLoadedMenu;
       // Info.LastSceneLoad = "PokemonController";
        print(batteryLevel);
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        getCurrentTime();
    }
}
