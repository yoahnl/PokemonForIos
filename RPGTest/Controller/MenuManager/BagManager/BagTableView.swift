//
//  BagTableView.swift
//  RPGTest
//
//  Created by Yoahn on 19/12/2017.
//  Copyright © 2017 Yoahn. All rights reserved.
//

import UIKit

struct BagContents
{
    enum Bag_Place: String
    {
        case Item, Healt, Pokeball, Key_Items
    }
    let name: String;
    let description: String;
    let small_description: String;
    let number: Int;
    let type: String;
    let image: String;
}

extension BagController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bagContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let element = bagContents[indexPath.row]
        
        let ncell: CustomCell = tableView.dequeueReusableCell(withIdentifier: "ElementCell") as! CustomCell
        ncell.awakeFromNib();
        ncell.First.text = element.name;
        ncell.Number.text = String(element.number);
        ncell.Description.text = element.small_description;
        ncell.ItemImage.image = UIImage(named: element.image);
        
        
        return ncell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
}

extension BagContents
{
    enum ErrorType: Error
    {
        case noPlistFile
        case cannotReadFile
    }
    
    static func loadFromPlist(current: String) throws -> [BagContents]
    {
        guard let file = Bundle.main.path(forResource: "BagContents", ofType: "plist")
            else
        {
            throw ErrorType.noPlistFile
        }
        
        guard let array = NSArray(contentsOfFile: file) as? [[String: AnyObject]]
            else
        {
            throw ErrorType.cannotReadFile
        }
        
        var contents: [BagContents] = []
        
        for dict in array
        {
            let element = BagContents.from(dict: dict, current: current)
            if element.name != "empty"
            {
                contents.append(element)
            }
        }
        
        return contents
    }
    
    static func from(dict: [String: AnyObject], current: String) -> BagContents
    {
        if Int(dict["number"] as! Int ) > 0 && dict["type"] as! String == current
        {
            let name = dict["name"] as! String;
            let description = dict["description"] as! String;
            let small_description = dict["small_description"] as! String;
            let number = dict["number"] as! Int;
            let type = dict["type"] as! String;
            let image = dict["image"] as! String;
            return BagContents(name: name,
                               description: description,
                               small_description: small_description,
                               number: number,
                               type: type,
                               image: image
            )
            
        }
        let name: String = "empty"
        let description = dict["description"] as! String;
        let small_description = dict["small_description"] as! String;
        let number = dict["number"] as! Int;
        let type = dict["type"] as! String;
        let image = dict["image"] as! String;
        return BagContents(name: name,
                           description: description,
                           small_description: small_description,
                           number: number,
                           type: type,
                           image: image
        )
    }
}




