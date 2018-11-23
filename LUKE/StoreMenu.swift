//
//  StoreMenu.swift
//  LUKE
//
//  Created by Mitchell Walters on 11/19/18.
//  Copyright © 2018 Mitchell Walters. All rights reserved.
//

import Foundation


import Foundation
import SpriteKit
import SwiftyStoreKit
import StoreKit
import SwiftyStoreKit


// this is probably where all constants should live. I think there are some sprinkled throughout the other classes


class StoreMenu: SKScene {
    
    // these are the assets that i want to use
    // https://www.gameart2d.com/free-casual-game-button-pack.html
    
    
    
    var high_score = SKLabelNode(text: "0")
    
    var play_button = SKSpriteNode(imageNamed: "play")
    
    var remove_ads = SKLabelNode(text: "Remove ads")
    var restore_purchase = SKLabelNode(text: "Restore purchase")
    
    var title = SKLabelNode(text: "Store")
    var instructions_background = SKSpriteNode()
    var instructions_background2 = SKSpriteNode()
    
    var rate = SKLabelNode(text: "RATE")
    let store = SKSpriteNode(imageNamed: "store")
    let green = SKColor(red: 57.0 / 255.0, green: 255.0 / 255.0, blue: 52.0 / 255.0, alpha: 20.0)
    
    func get_high_score() -> Int {
        return(UserDefaults.standard.integer(forKey: "high_score"))
    }
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.black
        
        
        instructions_background = SKSpriteNode(color: UIColor(displayP3Red: 40.0 / 255.0, green: 40.0 / 255.0, blue: 40.0 / 255.0, alpha: 0.9), size: CGSize(width: self.frame.width - 90, height: 200))
        instructions_background.position.y += 150
        instructions_background.zPosition = 99999
        instructions_background.name = "ads"
        addChild(instructions_background)
        
        var instruction_background_corners = [CGPoint]()
        
        //top left
        instruction_background_corners.append(
            CGPoint(x: -1 * instructions_background.frame.width / 2, y: instructions_background.frame.height / 2)
        )
        //top right
        instruction_background_corners.append(
            CGPoint(x: instructions_background.frame.width / 2, y: instructions_background.frame.height / 2)
        )
        //bottom left
        instruction_background_corners.append(
            CGPoint(x: -1 * instructions_background.frame.width / 2, y: -1 * instructions_background.frame.height / 2)
        )
        //bottom right
        instruction_background_corners.append(
            CGPoint(x: instructions_background.frame.width / 2, y: -1 * instructions_background.frame.height / 2)
        )
        
        for i in 0...3 {
            let effect = SKShapeNode(circleOfRadius: 9.0)
            effect.fillColor = green
            
            instructions_background.addChild(effect)
            effect.position = instruction_background_corners[i]
            effect.addGlow()
        }
        
        var line_pairs = [[CGPoint]]()
        //top
        line_pairs.append([instruction_background_corners[0],instruction_background_corners[1]])
        //bottom
        line_pairs.append([instruction_background_corners[2],instruction_background_corners[3]])
        //left
        line_pairs.append([instruction_background_corners[0],instruction_background_corners[2]])
        //right
        line_pairs.append([instruction_background_corners[1],instruction_background_corners[3]])
        
        
        for i in 0...3 {
            let top_line = SKShapeNode()
            let line_path:CGMutablePath = CGMutablePath()
            line_path.move(to: line_pairs[i][0])
            line_path.addLine(to: line_pairs[i][1])
            
            top_line.zPosition = 2
            top_line.path = line_path
            top_line.strokeColor = green
            top_line.position = CGPoint.zero
            
            top_line.lineWidth = 5
            instructions_background.addChild(top_line)
            top_line.glowWidth = 3
            
        }
        
        remove_ads.fontColor = green
        remove_ads.fontSize = 80
        remove_ads.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        remove_ads.name = "ads"
        
        instructions_background.addChild(remove_ads)
        
        
        instructions_background2 = SKSpriteNode(color: UIColor(displayP3Red: 40.0 / 255.0, green: 40.0 / 255.0, blue: 40.0 / 255.0, alpha: 0.9), size: CGSize(width: self.frame.width - 90, height: 200))
        instructions_background2.position.y -= 175
        instructions_background2.zPosition = 99999
        instructions_background2.name = "restore"
        addChild(instructions_background2)
        
        //var instruction_background_corners = [CGPoint]()
        
        //top left
        instruction_background_corners.append(
            CGPoint(x: -1 * instructions_background.frame.width / 2, y: instructions_background.frame.height / 2)
        )
        //top right
        instruction_background_corners.append(
            CGPoint(x: instructions_background.frame.width / 2, y: instructions_background.frame.height / 2)
        )
        //bottom left
        instruction_background_corners.append(
            CGPoint(x: -1 * instructions_background.frame.width / 2, y: -1 * instructions_background.frame.height / 2)
        )
        //bottom right
        instruction_background_corners.append(
            CGPoint(x: instructions_background.frame.width / 2, y: -1 * instructions_background.frame.height / 2)
        )
        
        for i in 0...3 {
            let effect = SKShapeNode(circleOfRadius: 9.0)
            effect.fillColor = green
            
            instructions_background2.addChild(effect)
            effect.position = instruction_background_corners[i]
            effect.addGlow()
        }
        
        //var line_pairs = [[CGPoint]]()
        //top
        line_pairs.append([instruction_background_corners[0],instruction_background_corners[1]])
        //bottom
        line_pairs.append([instruction_background_corners[2],instruction_background_corners[3]])
        //left
        line_pairs.append([instruction_background_corners[0],instruction_background_corners[2]])
        //right
        line_pairs.append([instruction_background_corners[1],instruction_background_corners[3]])
        
        
        for i in 0...3 {
            let top_line = SKShapeNode()
            let line_path:CGMutablePath = CGMutablePath()
            line_path.move(to: line_pairs[i][0])
            line_path.addLine(to: line_pairs[i][1])
            
            top_line.zPosition = 2
            top_line.path = line_path
            top_line.strokeColor = green
            top_line.position = CGPoint.zero
            
            top_line.lineWidth = 5
            instructions_background2.addChild(top_line)
            top_line.glowWidth = 3
            
        }
        
        restore_purchase.fontColor = green
        restore_purchase.fontSize = 80
        restore_purchase.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        restore_purchase.name = "restore"
        
        instructions_background2.addChild(restore_purchase)
        
        
        let home_button = SKSpriteNode(imageNamed: "home")
        home_button.position = CGPoint(x: 0, y: -1 * self.frame.height / 2 + 150)
        home_button.setScale(1.6)
        home_button.zPosition = 9999999
        home_button.name = "home"
        addChild(home_button)
        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //scene?.scaleMode = .aspectFill
        //        if get_high_score() > 1 && UserDefaults.standard.bool(forKey: "already flashed rate") == false {
        //            SKStoreReviewController.requestReview()
        //            UserDefaults.standard.set(true, forKey: "already flashed rate")
        //        }
        
//        store.position = CGPoint(x: 0, y: -425)
//        // ads.fontName = "PressStart2P"
//
//        store.name = "store"
//        store.zPosition = 4
//        store.setScale(2.0)
//
//        addChild(store)
        
        
        
        //        red_circle_with_slash.position = CGPoint(x: 0, y: -460)
        //        red_circle_with_slash.scale(to: CGSize(width: 75, height: 75))
        //        red_circle_with_slash.zPosition = 5
        //
        //        addChild(red_circle_with_slash)
        
        
        //        if let _ = UserDefaults.standard.value(forKey: "paid_version") {
        //
        //            ads.removeFromParent()
        //            //red_circle_with_slash.removeFromParent()
        //        }
        //
        
//        high_score.position = CGPoint(x: 0, y: 0)
//        high_score.fontName = "Futura-MediumItalic"
//        high_score.text = String(describing: get_high_score())
//        high_score.fontColor = SKColor.white
//        high_score.fontSize = 80
//
//        addChild(high_score)
//
//        rate.position = CGPoint(x: 0, y: -400)
//        //rate.text = String(describing: get_high_score())
//        rate.fontColor = SKColor.blue
//        rate.name = "rate"
//        rate.fontSize = 80
//
//        //addChild(rate)
//
//        play_button.position = CGPoint(x: 0, y: -200)
//        play_button.name = "play"
//        play_button.setScale(2.2)
//        addChild(play_button)
//
        title.position = CGPoint(x: 0, y: 450)
        title.fontColor = green
        title.fontName = "Futura-MediumItalic"
        title.zPosition = 10000
        title.fontSize = 80

        addChild(title)
//
//        remove_ads.position = CGPoint(x: 0, y: -400)
//        remove_ads.fontColor = SKColor.red
//        remove_ads.fontSize = 80
//        remove_ads.name = "remove ads"
        //addChild(remove_ads)
        
        
    }
    
    func purchase_ad_removal() {
        let feedback = UIActivityIndicatorView()
        feedback.color = green
        
        feedback.startAnimating()
        
        
        
        SwiftyStoreKit.purchaseProduct("09876", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                self.give_message(message: "Purchase Success: \(purchase.productId)")
            case .error(let error):
                self.give_message(message: "Unknown error")
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
        
        //feedback.stopAnimating()
    }
    
    func give_message(message: String) {
        
        let message_label = SKLabelNode(text: message)
        message_label.fontColor = green
        message_label.position = CGPoint(x: 0, y: -425)
        message_label.fontName = "Futura-MediumItalic"
        message_label.fontSize = 70
        
        
        self.addChild(message_label)
        
        
        let wait = SKAction.wait(forDuration: 1.0)
        
        let fade_out = SKAction.fadeOut(withDuration: 1.0)
        
        let sequence = SKAction.sequence([ wait, fade_out ])
        
        message_label.run(sequence)
    }
    
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
                        //                        skView.showsFPS = true
                        //                        skView.showsNodeCount = true

                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView.ignoresSiblingOrder = true

                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .aspectFill

                        skView.presentScene(scene)
                    }
                }
                
                if name == "home" {
                    if let scene = StartMenu(fileNamed:"StartMenu")
                    {
                        // Configure the view.
                        let skView = self.view! as SKView
//                        skView.showsFPS = true
//                        skView.showsNodeCount = true
                        
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView.ignoresSiblingOrder = true
                        
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .aspectFill
                        
                        skView.presentScene(scene)
                    }
                }

                if name == "ads" {
                    purchase_ad_removal()
                }

                if name == "restore" {
                    //go_to_app_store()
                    print("restore")
                    SwiftyStoreKit.restorePurchases(atomically: true) { results in
                        if results.restoreFailedPurchases.count > 0 {
                            print("Restore Failed: \(results.restoreFailedPurchases)")
                            self.give_message(message: "Restore Failed")
                        }
                        else if results.restoredPurchases.count > 0 {
                            print("Restore Success: \(results.restoredPurchases)")
                            UserDefaults.standard.set(true, forKey: "paid_version")
                            self.view?.subviews.forEach({ $0.removeFromSuperview() })
                        }
                        else {
                            //print("Nothing to Restore")
                            self.give_message(message: "Nothing to restore")
                            
                        }
                    }
                }


            }
        }
    }
    
}
