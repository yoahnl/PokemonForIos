//
//  Controller.swift
//  RPGTest
//
//  Created by Yoahn on 21/11/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

struct Info
{
    static var LastSceneLoadedMenu: String?;
    static var LastSceneLoad: String?;
    static var MenuSaveLocation: CGPoint? = CGPoint();
    static var NPCName: String?;
    static var NPCAction: String?;
}

class NPCinfo
{
    var Zone: String?;
    var Speech: [String]?;
    var Name: String?;
    var Action: String?;
}

class Controller: SKScene, SKPhysicsContactDelegate
{
    
    var isMoving: Bool = false;
    var player: SKSpriteNode?;
    var d_pad: [SKSpriteNode?] = [SKSpriteNode]();
    var CameraNode: SKCameraNode = SKCameraNode();
    var gameScene: SKScene!;
    var currentZone: String?;
    var PlayerCollisionBitMask: UInt32 = 0x1 << 1;
    var NPCnbr: Int = 0;
    var NPCinfos: [NPCinfo] = [NPCinfo()];
    var NbrLine: Int = 0;
    var RemindNbrLine: Int = 0;
    var RemindSpeechChar: Int = 0;
    var SpeechToPrint: String = "";
    var CurrentNPCName: String = "";
    
    func printInfo(_ value: Any)
    {
        let types = type(of: value)
        print("'\(value)' of type '\(types)'")
    }
    
    // MARK: Create and Set Interface And Player
    func CreatePlayer(point: CGPoint)
    {
        player = SKSpriteNode(imageNamed: "player_up_0");
        player?.position = point;
        player?.zPosition = 1;
        player?.name = "player";
        player?.physicsBody = SKPhysicsBody(circleOfRadius: (player?.size.width)! / 2);
        player?.physicsBody?.affectedByGravity = false;
        player?.physicsBody?.collisionBitMask = PlayerCollisionBitMask;
        player?.size = CGSize(width: (player?.size.width)! * 1.7, height: (player?.size.height)! * 1.7);
        player?.physicsBody?.isDynamic = true;
        self.addChild(player!);
    }
    
    func SetView(point : CGPoint)
    {
        self.physicsWorld.contactDelegate = self;
        CreatePlayer(point: point);
        addDpad();
        self.addChild(CameraNode);
        CameraNode.position = self.position;
        camera = CameraNode;
        player?.physicsBody?.contactTestBitMask = 3;
        addMenuButton();
        parsePropertyList();
    }
    func addDpad()
    {
        var i = 0;
        let d_pad_top: SKSpriteNode = SKSpriteNode(imageNamed: "d-pad-top");
        let d_pad_right: SKSpriteNode = SKSpriteNode(imageNamed: "d-pad-right");
        let d_pad_down: SKSpriteNode = SKSpriteNode(imageNamed: "d-pad-down");
        let d_pad_left: SKSpriteNode = SKSpriteNode(imageNamed: "d-pad-left");
        d_pad_top.position = CGPoint(x: -230, y: -80);
        d_pad_top.name = "top";
        d_pad_right.position = CGPoint(x: -200, y: -105);
        d_pad_right.name = "right";
        d_pad_down.position = CGPoint(x: -230, y: -130);
        d_pad_down.name = "down";
        d_pad_left.position = CGPoint(x: -260, y: -105);
        d_pad_left.name = "left";
        d_pad.append(d_pad_top);
        d_pad.append(d_pad_right);
        d_pad.append(d_pad_down);
        d_pad.append(d_pad_left);
        while i <= 3
        {
            d_pad[i]?.zPosition = 2;
            CameraNode.addChild(d_pad[i]!);
            i += 1;
        }
    }
    
    func addMenuButton()
    {
        let MenuButton: SKSpriteNode = SKSpriteNode(imageNamed: "card");
        
        MenuButton.name = "MenuButton";
        MenuButton.position = CGPoint(x: 270, y: 150);
        MenuButton.zPosition = 3;
        MenuButton.size = CGSize(width: 100, height: 50);
        self.CameraNode.addChild(MenuButton);
    }
    
    func MovePlayer(move: UITouch)
    {
        let location = move.previousLocation(in: self)
        let node = self.nodes(at: location).first
        switch  node?.name
        {
        case "top"?:
            let moveAction = SKAction.moveBy(x: 0, y: 0.7, duration: 0.01);
            let repeatAction = SKAction.repeatForever(moveAction);
            let run = SKAction.animate(with: [SKTexture(imageNamed: "player_down_0"),SKTexture(imageNamed: "player_down_1"),SKTexture(imageNamed: "player_down_2")], timePerFrame: 0.1);
            player?.run(SKAction.repeatForever(SKAction.sequence([run,SKAction.wait(forDuration: 0.1)])), withKey:"heroRunning");
            player?.run(repeatAction);
        case "right"?:
            let moveAction = SKAction.moveBy(x: 0.7, y: 0, duration: 0.01);
            let repeatAction = SKAction.repeatForever(moveAction);
            let run = SKAction.animate(with: [SKTexture(imageNamed: "player_right_0"),SKTexture(imageNamed: "player_right_1"),SKTexture(imageNamed: "player_right_2")], timePerFrame: 0.1);
            player?.run(SKAction.repeatForever(SKAction.sequence([run,SKAction.wait(forDuration: 0.1)])), withKey:"heroRunning");
            player?.run(repeatAction);
        case "down"?:
            let moveAction = SKAction.moveBy(x: 0, y: -0.7, duration: 0.01);
            let repeatAction = SKAction.repeatForever(moveAction);
            let run = SKAction.animate(with: [SKTexture(imageNamed: "player_up_0"),SKTexture(imageNamed: "player_up_1"),SKTexture(imageNamed: "player_up_2"), ], timePerFrame: 0.1);
            player?.run(SKAction.repeatForever(SKAction.sequence([run,SKAction.wait(forDuration: 0.1)])), withKey:"heroRunning");
            player?.run(repeatAction);
            
        case "left"?:
            let moveAction = SKAction.moveBy(x: -0.7, y: 0, duration: 0.01);
            let repeatAction = SKAction.repeatForever(moveAction);
            let run = SKAction.animate(with: [SKTexture(imageNamed: "player_left_0"),SKTexture(imageNamed: "player_left_1"),SKTexture(imageNamed: "player_left_2")], timePerFrame: 0.1);
            player?.run(SKAction.repeatForever(SKAction.sequence([run,SKAction.wait(forDuration: 0.1)])), withKey:"heroRunning");
            player?.run(repeatAction);
        case "MenuButton"?:
            let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.3);
            gameScene = SKScene(fileNamed: String("MenuController"));
            Info.MenuSaveLocation = player?.position;
            self.view?.presentScene(gameScene, transition: transition);
        case "SpeechBox"?:
            if NbrLine > 1
            {
                print("Il y a encore des trucs à écrire !");
                let Remove = CameraNode.childNode(withName: "SpeechBox");
                CameraNode.removeChildren(in: [Remove!]);
                let NPC = self.childNode(withName: Info.NPCName!);
                let actionToAdd = SKAction(named: Info.NPCAction!);
                NPC?.run(actionToAdd!);
                print("SpeechToPrint = \(SpeechToPrint)");
                CreateSpeechBoxWithIndex(speech: SpeechToPrint, Name: CurrentNPCName, From: RemindSpeechChar);
                NbrLine -= 1;
            }
            else
            {
                let Remove = CameraNode.childNode(withName: "SpeechBox");
                CameraNode.removeChildren(in: [Remove!]);
                let NPC = self.childNode(withName: Info.NPCName!);
                let actionToAdd = SKAction(named: Info.NPCAction!);
                NPC?.run(actionToAdd!);
                SpeechToPrint = "";
                CurrentNPCName = "";
                RemindSpeechChar = 0;
            }
        default:
            break;
        }
    }
    
    func MovePlayerBack(move: UITouch)
    {
        let location = move.previousLocation(in: self)
        let node = self.nodes(at: location).first
        switch  node?.name
        {
        case "top"?:
            let moveAction = SKAction.moveBy(x: 0, y: 0.7, duration: 0.01);
            let repeatAction = SKAction.repeatForever(moveAction);
            player?.texture = SKTexture(imageNamed: "player_down_1")
            player?.run(repeatAction);
        case "right"?:
            let moveAction = SKAction.moveBy(x: 0.7, y: 0, duration: 0.01);
            let repeatAction = SKAction.repeatForever(moveAction);
            player?.texture = SKTexture(imageNamed: "player_right_0")
            player?.run(repeatAction);
        case "down"?:
            let moveAction = SKAction.moveBy(x: 0, y: -0.7, duration: 0.01);
            let repeatAction = SKAction.repeatForever(moveAction);
            player?.texture = SKTexture(imageNamed: "player_up_0");
            player?.run(repeatAction);
        case "left"?:
            let moveAction = SKAction.moveBy(x: -0.7, y: 0, duration: 0.01);
            let repeatAction = SKAction.repeatForever(moveAction);
            player?.texture = SKTexture(imageNamed: "player_left_1")
            player?.run(repeatAction);
        default:
            break;
        }
        
    }
    
    func getPositionAtloadTime() -> CGPoint
    {
        return CGPoint(x: 0, y: 0);
    }
    
    func parsePropertyList()
    {
        
        let path = Bundle.main.path(forResource: "GameData", ofType: "plist");
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!;
        var Zone:String?;
        if dict.object(forKey: "Zone")  != nil
        {
            if let zoneDict: [String: Any] = dict.object(forKey: "Zone") as? [String: Any]
            {
                for (key, value) in zoneDict
                {
                    if key == self.currentZone
                    {
                        Zone = key;
                        if let zoneData:[String: Any] = value as? [String: Any]
                        {
                            for (key, value) in zoneData
                            {
                                if (key == "NPC")
                                {
                                    NPCnbr += 1;
                                    createNPC(NPC: value as! [String : Any], nbr: NPCnbr);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createNPC(NPC: [String: Any], nbr: Int)
    {
        for (key, value) in NPC
        {
            var theBaseImage: String = "";
            let NickName: String = key;
            var Speech: [String]?;
            if let NPCData:[String : Any] = value as? [String: Any]
            {
                for (key, value) in NPCData
                {
                    if key == "BaseImage"
                    {
                        theBaseImage = value as! String
                    }
                    
                    if key == "Speech"
                    {
                        
                        Speech = value as? [String];
                    }
                }
            }
            
            let info: NPCinfo = NPCinfo();
            info.Name = NickName;
            info.Zone = self.currentZone;
            info.Speech = Speech;
            let newNPC: NonPlayerCharacter = NonPlayerCharacter(imageNamed: theBaseImage);
            newNPC.name = NickName;
            newNPC.setupWithDict(theDict: value as! [String: Any]);
            info.Action = newNPC.Action;
            newNPC.zPosition = (player?.zPosition)!;
            newNPC.physicsBody?.affectedByGravity = false;
            newNPC.physicsBody?.isDynamic = false;
            self.addChild(newNPC);
            NPCinfos.append(info);
        }
    }
    
    func FindNPCByName(name: String) -> Int?
    {
        var count: Int = 0;
        for i in NPCinfos
        {
            if i.Name == name
            {
                return count;
            }
            count += 1;
        }
        return nil;
    }
    
    func CreateSpeechBox(speech: String, Name: String)
    {
        SpeechToPrint = speech;
        NbrLine = speech.count / 50;
        print("NbrLine = \(NbrLine)");
        let MaxInOneLine: Int = 51;
        var i:Int = 0;
        var CharPrint: Int = 0;
        CurrentNPCName = Name;
        var line1: String = "";
        var line2: String = "";
        let Speech1: SKLabelNode = SKLabelNode(fontNamed: "PowerClear-Regular");
        let Speech2: SKLabelNode = SKLabelNode(fontNamed: "PowerClear-Regular");
        
        var useLine2: Bool = false;
        
        for letter in speech.characters
        {
            if i > MaxInOneLine && String(letter) == " "
            {
                useLine2 = true;
            }
            if useLine2 == false
            {
                line1 = line1 + String(letter);
                CharPrint += 1;
            }
            else if (i <= MaxInOneLine * 2)
            {
                line2 = line2 + String(letter);
                CharPrint += 1;
            }
            
            i += 1;
        }
        print("i = \(i)");
        RemindSpeechChar = CharPrint;
        Speech1.text = line1;
        Speech2.text = line2;
        let NPC: SKSpriteNode = self.childNode(withName: Name + "_NPC") as! SKSpriteNode;
        NPC.removeAllActions();
        let SpeechBox: SKSpriteNode = SKSpriteNode(imageNamed: "speechbox");
        SpeechBox.position.x = self.position.x + -2.994;
        SpeechBox.position.y = self.position.y + -119.267;
        SpeechBox.size.width = -573.458;
        SpeechBox.size.height =  78.533;
        SpeechBox.zPosition = (player?.zPosition)! + 10;
        SpeechBox.name = "SpeechBox";
        Speech1.fontColor = UIColor.black;
        Speech1.zPosition = SpeechBox.zPosition + 1;
        Speech1.position = CGPoint(x: -60, y: 10);
        Speech1.fontSize = 20;
        Speech1.horizontalAlignmentMode = .center;
        Speech1.verticalAlignmentMode = .center;
        
        Speech2.fontColor = UIColor.black;
        Speech2.zPosition = SpeechBox.zPosition + 1;
        Speech2.position = CGPoint(x: -70, y: -10);
        Speech2.fontSize = 20;
        Speech2.horizontalAlignmentMode = .center;
        Speech2.verticalAlignmentMode = .center;
        SpeechBox.addChild(Speech1);
        SpeechBox.addChild(Speech2);
        CameraNode.addChild(SpeechBox);
    }
    
    func CreateSpeechBoxWithIndex(speech: String, Name: String, From: Int)
    {
        SpeechToPrint = speech;
        NbrLine = speech.count / 50;
        print("NbrLine = \(NbrLine)");
        let MaxInOneLine: Int = 51;
        var i:Int = 0;
        CurrentNPCName = Name;
        var line1: String = "";
        var line2: String = "";
        let Speech1: SKLabelNode = SKLabelNode(fontNamed: "PowerClear-Regular");
        let Speech2: SKLabelNode = SKLabelNode(fontNamed: "PowerClear-Regular");
        
        var useLine2: Bool = false;
        print("From = \(From)");
        for letter in speech.characters
        {
            if i < From
            {
                
            }
            else if i > From
            {
                if i - From > MaxInOneLine && String(letter) == " "
                {
                    useLine2 = true;
                }
                if useLine2 == false
                {
                    line1 = line1 + String(letter);
                }
                else if (i + From <= MaxInOneLine * 2)
                {
                    line2 = line2 + String(letter);
                }
                
            }
            i += 1;
        }
        print("line1 = \(line1)");
        print("line2 = \(line2)");
        RemindSpeechChar =   (i + From) - (line1.count + line2.count);
        Speech1.text = line1;
        Speech2.text = line2;
        let NPC: SKSpriteNode = self.childNode(withName: Name + "_NPC") as! SKSpriteNode;
        NPC.removeAllActions();
        let SpeechBox: SKSpriteNode = SKSpriteNode(imageNamed: "speechbox");
        SpeechBox.position.x = self.position.x + -2.994;
        SpeechBox.position.y = self.position.y + -119.267;
        SpeechBox.size.width = -573.458;
        SpeechBox.size.height =  78.533;
        SpeechBox.zPosition = (player?.zPosition)! + 10;
        SpeechBox.name = "SpeechBox";
        Speech1.fontColor = UIColor.black;
        Speech1.zPosition = SpeechBox.zPosition + 1;
        Speech1.position = CGPoint(x: -60, y: 10);
        Speech1.fontSize = 20;
        Speech1.horizontalAlignmentMode = .center;
        Speech1.verticalAlignmentMode = .center;
        
        Speech2.fontColor = UIColor.black;
        Speech2.zPosition = SpeechBox.zPosition + 1;
        Speech2.position = CGPoint(x: -70, y: -10);
        Speech2.fontSize = 20;
        Speech2.horizontalAlignmentMode = .center;
        Speech2.verticalAlignmentMode = .center;
        SpeechBox.addChild(Speech1);
        SpeechBox.addChild(Speech2);
        CameraNode.addChild(SpeechBox);
    }
   
    override func didMove(to view: SKView)
    {
        self.currentZone = "GameScene";
        let playerPosition = getPositionAtloadTime();
        SetView(point: playerPosition);
        Info.LastSceneLoad = self.currentZone;
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let move = touches.first
        {
            isMoving = true;
            MovePlayer(move: move);
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let move = touches.first
        {
            isMoving = false;
            MovePlayerBack(move: move);
        }
        
        self.player?.removeAllActions();
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        var playerBody: SKPhysicsBody;
        var otherBody: SKPhysicsBody;
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            playerBody = contact.bodyA;
            otherBody = contact.bodyB;
        }
        else
        {
            playerBody = contact.bodyB;
            otherBody = contact.bodyA;
        }
        if playerBody.collisionBitMask == PlayerCollisionBitMask
        {
            let nameSceneToLoadArr = (otherBody.node?.name?.split(separator: "_"))!;
            let namesSceneToLoad = nameSceneToLoadArr[1];
            
            print("porte touchée ! go to \(namesSceneToLoad)");
            let transition = SKTransition.fade(withDuration: 1);
            gameScene = SKScene(fileNamed: String(namesSceneToLoad));
            gameScene.scaleMode = .aspectFit;
            
            self.view?.presentScene(gameScene, transition: transition);
        }
        else
        {
            let playerBodyTouchedName: String = (playerBody.node?.name)!;
            let touchedNPC: Bool = playerBodyTouchedName.contains("NPC");
            if touchedNPC
            {
                let ObjectTouchedArr = (playerBody.node?.name?.split(separator: "_"))!;
                let ObjectTouched = ObjectTouchedArr[1];
                if ObjectTouched == "NPC"
                {
                    let NPCName = ObjectTouchedArr[0]
                    print("the NPC Touched is \(NPCName)");
                    let nbrNPC = FindNPCByName(name: String(NPCName + "_NPC"));
                    let speech = NPCinfos[nbrNPC!].Speech;
                    Info.NPCName = NPCName + "_NPC";
                    Info.NPCAction = NPCinfos[nbrNPC!].Action;
                    CreateSpeechBox(speech: speech![0], Name: String(NPCName));
                    
                }
            }
            else
            {
                print("node touched = \(String(describing: playerBody.node?.name))");
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        CameraNode.position = (player?.position)!;
    }
}
