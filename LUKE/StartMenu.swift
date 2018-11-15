//
//  StartMenu.swift
//  LUKE
//
//  Created by Mitchell Walters on 11/14/18.
//  Copyright © 2018 Mitchell Walters. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftyStoreKit


// this is probably where all constants should live. I think there are some sprinkled throughout the other classes
let ICON_SIZE = CGSize(width: 120, height: 120)

class StartMenu: SKScene {
    
    // these are the assets that i want to use
    // https://www.gameart2d.com/free-casual-game-button-pack.html
    
    
    
    var high_score = SKLabelNode(text: "0")
    
    var play_button = SKSpriteNode(imageNamed: "play")
    
    var remove_ads = SKLabelNode(text: "Remove ads")
    
    var title = SKLabelNode(text: "LUKE")
    
    var rate = SKLabelNode(text: "RATE")
    
    func get_high_score() -> Int {
        return(UserDefaults.standard.integer(forKey: "high_score"))
    }
    
    override func didMove(to view: SKView) {

        self.backgroundColor =  SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //scene?.scaleMode = .aspectFill
        
        
        high_score.position = CGPoint(x: 0, y: 0)
        high_score.text = String(describing: get_high_score())
        high_score.fontColor = SKColor.blue
        high_score.fontSize = 80
        
        addChild(high_score)
        
        rate.position = CGPoint(x: 0, y: -400)
        //rate.text = String(describing: get_high_score())
        rate.fontColor = SKColor.blue
        rate.name = "rate"
        rate.fontSize = 80
        
        //addChild(rate)
        
        play_button.position = CGPoint(x: 0, y: -200)
        play_button.name = "play"
        play_button.setScale(3.0)
        addChild(play_button)
        
        title.position = CGPoint(x: 0, y: 325)
        title.fontColor = SKColor.purple
        title.zPosition = 10000
        title.fontSize = 150
        
        addChild(title)
        
        remove_ads.position = CGPoint(x: 0, y: -400)
        remove_ads.fontColor = SKColor.red
        remove_ads.fontSize = 80
        remove_ads.name = "remove ads"
        //addChild(remove_ads)
        
        
    }
    
//    func go_to_app_store() {
//        print("trying to go to the app store")
//
//        //        if (UIApplication.shared.canOpenURL(NSURL(string:"baz")! as URL)) {
//        //            UIApplication.shared.openURL(NSURL(string: "foobar")! as URL) //    }
//        //        }
//
//        let urlStr = "itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8"
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
//
//        } else {
//            UIApplication.shared.openURL(URL(string: urlStr)!)
//        }
//    }
//
//    func get_high_score() -> Int {
//        return(UserDefaults.standard.integer(forKey: "high_score"))
//    }
//
//    func purchase_ad_removal() {
//        SwiftyStoreKit.purchaseProduct("54321", quantity: 1, atomically: true) { result in
//            switch result {
//            case .success(let purchase):
//                print("Purchase Success: \(purchase.productId)")
//            case .error(let error):
//                switch error.code {
//                case .unknown: print("Unknown error. Please contact support")
//                case .clientInvalid: print("Not allowed to make the payment")
//                case .paymentCancelled: break
//                case .paymentInvalid: print("The purchase identifier was invalid")
//                case .paymentNotAllowed: print("The device is not allowed to make the payment")
//                case .storeProductNotAvailable: print("The product is not available in the current storefront")
//                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
//                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
//                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
//                }
//            }
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let touchedNode = atPoint(positionInScene)
            if let name = touchedNode.name
            {
                if name == "play" {
                    if let scene = GameScene(fileNamed:"GameScene")
                    {
                        // Configure the view.
                        let skView = self.view! as SKView
                        skView.showsFPS = true
                        skView.showsNodeCount = true
                        
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView.ignoresSiblingOrder = true
                        
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .aspectFill
                        
                        skView.presentScene(scene)
                    }
                }
                
                if name == "remove ads" {
                    //purchase_ad_removal()
                }
                
                if name == "rate" {
                    //go_to_app_store()
                }
                
                
            }
        }
    }
    
}
