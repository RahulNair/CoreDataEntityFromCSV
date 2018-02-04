//
//  ViewController.swift
//  CoreDataEntityFromCSV
//
//  Created by Rahul Nair on 05/02/18.
//  Copyright © 2018 Rahul Nair. All rights reserved.
//

import UIKit
import  AEXML

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parseCVC()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func parseCVC(){
        
        if let filepath = Bundle.main.path(forResource: "columnsColumns", ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                
                
                let splitByComma = contents.split(separator: "\r\n")
                var dict : [String:[String:String]] = [:]
                
                
                for column_string in splitByComma{
                    
                    let colum = column_string.split(separator: ",")
                    guard let key : String? = String(describing: colum.first!) else{
                        
                        break
                        
                    }
                    
                    if var col_name_dict : [String:String] = dict[key!] {
                        let attr_name = String(colum[1])
                        let attr_type = String(describing: colum.last!)
                        col_name_dict[attr_name] = attr_type
                        dict[key!] = col_name_dict
                    }else{
                        if let attr_name = String(colum[1]) as? String{
                            if let attr_type = String(describing: colum.last!) as? String{
                                var col_name_dict : [String:String] = [:]
                                col_name_dict[attr_name] = attr_type
                                dict[key!] = col_name_dict
                                
                            }
                        }
                        
                        
                    }
                    
                    
                }
                
                //  print(dict)
                parseXML(parsedDict: dict)
                
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
    }
    
    
    
    func parseXML(parsedDict : [String:[String:String]])  {
        
        let dict = parsedDict
        
        let classnameList = Array(dict.keys)
        // create XML Document
        let content = AEXMLDocument()
        
        
        let attributes = ["type":"com.apple.IDECoreDataModeler.DataModel", "documentVersion":"1.0", "lastSavedToolsVersion":"13772" ,"systemVersion":"16G29", "minimumToolsVersion":"Automatic", "sourceLanguage":"Swift", "userDefinedModelVersionIdentifier":""]
        let model = content.addChild(name: "model", attributes: attributes)
        
        for elementName in classnameList{
            
            let entity = model.addChild(name: "entity",attributes : ["name":elementName.capitalizingFirstLetter(), "representedClassName":elementName.capitalizingFirstLetter(), "syncable":"YES" ,"codeGenerationType":"class"])
            
            let attributeDict = dict[elementName] as! [String:String]
            
            let attribureKeyList = Array(attributeDict.keys)
            
            for att_key in attribureKeyList{
                let type = getCoredataDataType(sqlType: attributeDict[att_key]!)
                entity.addChild(name: "attribute", value: nil, attributes: ["name":att_key ,"optional":"YES","attributeType": type,"syncable":"YES"])
            }
            
            
        }
        
        let elements = model.addChild(name: "elements")
        
        
        for elementName in classnameList{
            elements.addChild(name: "element", value: nil, attributes: ["name":elementName.capitalizingFirstLetter(),"positionX":"-18", "positionY":"27", "width":"128", "height":"90"])
            
        }
        
        
        print(content.xml)
        
        
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
        docURL = docURL?.appendingPathComponent("sample1.xml")
        do {
            // Write contents to file
            
            try content.xml.write(to: docURL!, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        
        print("path for outputfile is  \(docURL)")
        
    }
    
    func  getCoredataDataType(sqlType:String) -> String {
        
        
        var myType = ""
        switch sqlType {
        case "int":
            myType = "Integer 16"
            break
        case "float":
            myType = "Float"
            break
            
        case "varchar":
            myType = "String"
            break
            
        case "tinyint":
            myType = "Integer 16"
            break
            
        case "varchar":
            myType = "String"
            break
            
        case "date":
            myType = "Date"
            break
            
        case "timestamp":
            myType = "Date"
            break
        default:
            myType  = "String"
        }
        
        return myType
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


