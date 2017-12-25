//
//  BagController.swift
//  RPGTest
//
//  Created by Yoahn on 18/12/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import Foundation

import SpriteKit
import UIKit

class BagController: SKScene
{
    var bagContents: [BagContents] = [];
    var currentBagPocket: String = "item"
    var PreviousView: String?;
    var time: String?;
    weak var Table: UITableView!;
    

    func getBatterieLevel()
    {
        UIDevice.current.isBatteryMonitoringEnabled = true;
        let batteryLevel = UIDevice.current.batteryLevel;
        let batterieLabel: SKLabelNode = (self.childNode(withName: "Batterie"))! as! SKLabelNode;
        batterieLabel.text =  String(format: "%.0f%%", batteryLevel * 100);
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
        //  animateNodesStart(nodeArr);
        
        switch  node?.name
        {
        case "return"?:
            let gameScene: SKScene?;
            let transition = SKTransition.push(with: SKTransitionDirection.right, duration: 0.3);
            Table?.removeFromSuperview();
            print("Info.LastSceneLoadedMenu =  \(Info.LastSceneLoadedMenu!)");
            
            gameScene = SKScene(fileNamed: PreviousView!);
            
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
            if node.name == "item" || node.name == "healt" || node.name == "CS_CT" || node.name == "key_item" || node.name == "pokeball"            {
            }
        }
    }
    
    func animateNodesEnded(_ nodes: [SKNode])
    {
        for (index, node) in nodes.enumerated()
        {
            print(index);
            if node.name == "item" || node.name == "healt" || node.name == "CS_CT" || node.name == "key_item" || node.name == "pokeball"
                
            {
                currentBagPocket = node.name!;
                bagContents = try! BagContents.loadFromPlist(current: currentBagPocket)
                Table?.removeFromSuperview()
                TableViewSetUp()
                
            }
        }
    }
   
    func TableViewSetUp()
    {
        
        let Table: UITableView = UITableView(frame: CGRect(origin: CGPoint(x: 105, y: 35), size: CGSize(width: 540, height: 270)));
        Table.backgroundColor = UIColor.gray;
        Table.isOpaque = true;
        view?.addSubview(Table);
        self.Table = Table;
        
        Table.dataSource = self;
        Table.delegate = self;
        let NibName = UINib(nibName: "CustomCell", bundle: nil);
        Table.register(NibName, forCellReuseIdentifier: "ElementCell");
        Table.estimatedRowHeight = 70;
        Table.rowHeight = UITableViewAutomaticDimension;
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
        self.PreviousView = Info.LastSceneLoadedMenu;
        bagContents = try! BagContents.loadFromPlist(current: currentBagPocket)
        
        TableViewSetUp();
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        getCurrentTime();
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
}







