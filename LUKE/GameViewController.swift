//
//  GameViewController.swift
//  LUKE
//
//  Created by Mitchell Walters on 11/6/18.
//  Copyright © 2018 Mitchell Walters. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "StartMenu") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//
//
//            NotificationCenter.default.addObserver(self, selector: #selector(self.showAd), name: NSNotification.Name(rawValue: "showAd"), object: nil)
//            interstitial = createAndLoadInterstitial()
//            let request = GADRequest()
//            request.testDevices = ["25c0bcb0d1bc91ac3a3e7ff59a1216f7"]
//            interstitial.delegate = self
//            interstitial.load(request)
        if let scene = StartMenu(fileNamed:"StartMenu")
        {
            // Configure the view.
            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAd), name: NSNotification.Name(rawValue: "showAd"), object: nil)
        interstitial = createAndLoadInterstitial()
        let request = GADRequest()
        request.testDevices = ["25c0bcb0d1bc91ac3a3e7ff59a1216f7", kGADSimulatorID]
        interstitial.delegate = self
        interstitial.load(request)

    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        //print("interstitialDidDismissScreen")
        interstitial = createAndLoadInterstitial()
        
        //        let menuScene = GameOverScreen()
        //        //MenuScene.
        //        let skView = view as! SKView
        //        //        skView.showsFPS = true
        //        //        skView.showsNodeCount = true
        //        //skView.ignoresSiblingOrder = true
        //        //menuScene.scaleMode = .resizeFill
        //        //menuScene.inputViewController = self
        //        skView.presentScene(menuScene)
        
        
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
    @IBAction func showAd(_ sender: AnyObject) {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }

    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
