//
//  GameScene.swift
//  LUKE
//
//  Created by Mitchell Walters on 11/6/18.
//  Copyright © 2018 Mitchell Walters. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreGraphics



struct physicsCategory {
    
    static let projected_velocity: UInt32 = 0x1 << 1
    static let obstacle: UInt32 = 0x1 << 2
    static let checkpoint_one: UInt32 = 0x1 << 3
    static let checkpoint_two: UInt32 = 0x1 << 4
    static let finish_line: UInt32 = 0x1 << 5
    
}

//extension SKSpriteNode {
//    
//    func addGlow(radius: Float = 30) {
//        let effectNode = SKEffectNode()
//        effectNode.shouldRasterize = true
//        addChild(effectNode)
//        effectNode.addChild(SKSpriteNode(texture: texture))
//        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
//    }
//}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var block_radius = 0.0
    var block = SKShapeNode(circleOfRadius: CGFloat(0))
    var starting_block_position = CGPoint()
    let line = SKShapeNode()
    
    var first_instructions = SKLabelNode()
    var second_instructions = SKLabelNode()
    
    
    var obstacles = [SKShapeNode]()
    var game_ended = false
    //let line = SKSpriteNode(imageNamed: "line")
    
    
    var obstacle_length = CGFloat()
    
    var last_obstacle_direction = "left"
    
    let purple = UIColor(displayP3Red: 39.0 / 255.0, green: 16.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    let orange = SKColor(red: 250.0 / 255.0, green: 131.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
    
    let yellow = SKColor(red: 255.0 / 255.0, green: 253.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
    let light_blue = SKColor(red: 56.0 / 255.0, green: 134.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
    let mustard_yellow = SKColor(red: 165.0 / 255.0, green: 70.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    
    var line_segment_colors = [SKColor]()
    
    var game_has_started = false
    var score = 0
    var score_label = SKLabelNode()
    var high_score_label = SKLabelNode()
    
    let n_forces = 10
    var forces = [Double]()
    
    override func didMove(to view: SKView) {
        
        create_scene()
    
    }
    
    func restart_scene() {
        
        removeAllActions()
        removeAllChildren()
        create_scene()
        
    }
    
    
    func create_scene() {
        self.physicsWorld.contactDelegate = self
        forces = []
        for _ in 1...n_forces {
            forces.append(0.0)
        }
        
        let latest_high_score = UserDefaults.standard.integer(forKey: "high_score")
        
        backgroundColor = purple
        game_has_started = false
        game_ended = false
        obstacles = []
        block_radius = Double(self.frame.width / 10)
        line_segment_colors = [yellow, light_blue, mustard_yellow]
        score = 0
        
        first_instructions = SKLabelNode(text: "Press harder to move right")
        first_instructions.position = CGPoint(x: 0, y: 50)
        first_instructions.fontSize = 60
        first_instructions.fontColor = UIColor.white
        
        addChild(first_instructions)
        
        
        second_instructions = SKLabelNode(text: "Contact line to begin moving")
        second_instructions.position = CGPoint(x: 0, y: -50)
        second_instructions.fontSize = 50
        second_instructions.fontColor = UIColor.white
        
        addChild(second_instructions)
        
        
        //I LIKE IT DIVIDED BY 3
        obstacle_length = self.frame.width / 3
        
        starting_block_position = CGPoint(x: -1 * self.frame.width / 2 + CGFloat(block_radius), y: -1 * self.frame.height / 2 + CGFloat(block_radius))
        block = SKShapeNode(circleOfRadius: CGFloat(block_radius))
        block.position = CGPoint(x: 0, y: 0)
        
        block.fillColor = orange
        block.strokeColor = orange
        
        block.position = starting_block_position
        block.zPosition = 100000
        
        block.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(block_radius))
        block.physicsBody?.affectedByGravity = false

        block.zPosition = 50
        
        block.name = "obstacle"
        
        block.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(block_radius))
        block.physicsBody?.categoryBitMask = physicsCategory.projected_velocity
        block.physicsBody?.collisionBitMask = 0
        block.physicsBody?.contactTestBitMask = physicsCategory.obstacle
        block.physicsBody?.isDynamic = true
        block.physicsBody?.friction = 0
        
        block.physicsBody?.affectedByGravity = false
        addChild(block)
        
        score_label = SKLabelNode(text: String(score))
        score_label.fontSize = 90
        score_label.fontColor = UIColor.white
        score_label.horizontalAlignmentMode = .right
        score_label.position = CGPoint(x: self.frame.width / 2 - 5 , y: self.frame.height / 2 - score_label.frame.height - 5)
        
        addChild(score_label)
        
        high_score_label = SKLabelNode(text: String(latest_high_score))
        high_score_label.fontSize = 90
        high_score_label.fontColor = UIColor.white
        high_score_label.horizontalAlignmentMode = .left
        high_score_label.position = CGPoint(x: -1 * self.frame.width / 2 + 5 , y: self.frame.height / 2 - high_score_label.frame.height - 5)
        
        addChild(high_score_label)
        
        let update_score = SKAction.run {
            self.score += 1
            self.score_label.text = String(self.score)
        }
        
        let wait_for_score = SKAction.wait(forDuration: 0.5)
        
        //NEEDS TO BE CHECKED
        let update_high_score_if_necessary = SKAction.run {
            if self.score > latest_high_score {
                self.high_score_label.text = String(self.score)
            }
        }
        
        let increment_score = SKAction.sequence([update_score, update_high_score_if_necessary , wait_for_score ])
        
        
        
        let increment_score_forever = SKAction.repeatForever(increment_score)
        
        
        score_label.run(increment_score_forever)
        score_label.isPaused = true
        
        for i in 1...6 {
        
            let projected_path = SKShapeNode()
            
            let starting_position = CGPoint(x: 0, y: CGFloat(i) * -1 * obstacle_length)
            let ending_position = CGPoint.zero
            
            let line_path:CGMutablePath = CGMutablePath()
            line_path.move(to: starting_position)
            line_path.addLine(to: ending_position)
            
            
            projected_path.zPosition = 200
            projected_path.path = line_path
            projected_path.strokeColor = line_segment_colors.randomElement() ?? yellow
            
            projected_path.lineWidth = 2
            //projected_path.glowWidth = 2
            
            projected_path.name = "projected_path"
            
            projected_path.physicsBody = SKPhysicsBody(edgeChainFrom: line_path)
            projected_path.physicsBody?.categoryBitMask = physicsCategory.obstacle
            projected_path.physicsBody?.collisionBitMask = physicsCategory.projected_velocity
            projected_path.physicsBody?.contactTestBitMask = physicsCategory.projected_velocity
            projected_path.physicsBody?.isDynamic = true
            projected_path.physicsBody?.affectedByGravity = true
            projected_path.physicsBody?.pinned = true
            
            
            addChild(projected_path)
            let fall = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.35)
            
            let fall_forever = SKAction.repeatForever(fall)
            projected_path.run(fall_forever)
            projected_path.isPaused = true
            
            
            obstacles.append(projected_path)
            
        }
        
        for _ in 0...200 {
            make_obstacle()
        }
        
        
    }
//    var realPaused = false
//    {
//        didSet
//        {
//            isPaused = realPaused
//        }
//    }
//    override var isPaused : Bool
//        {
//        get
//        {
//            return realPaused
//        }
//        set
//        {
//            //we do not want to use newValue because it is being set without our knowledge
//            for obstacle in obstacles {
//                obstacle.isPaused = !realPaused
//            }
//        }
//    }
    
    func make_obstacle() {
        
        //THIS WILL BREAK IF OBSTACLES ARRAY IS NILL
        //OBSRACLES GETS ONE ELEMENT FROM CREATE_SCENEz
        
        let projected_path = SKShapeNode()
        
        
        var starting_position = CGPoint(x: 400, y: -700)
        var ending_position = CGPoint(x: 300, y: 300)
        
        if last_obstacle_direction == "left" {
            starting_position = CGPoint(x: obstacles.last!.path!.boundingBox.minX, y: obstacles.last!.path!.boundingBox.maxY)
        } else {
            starting_position = CGPoint(x: obstacles.last!.path!.boundingBox.maxX, y: obstacles.last!.path!.boundingBox.maxY)
        }
        
        var angle_in_degrees = CGFloat((arc4random() % 100) + 40)
        
        if (self.frame.width / 2) - obstacle_length <  obstacles.last!.path!.boundingBox.maxX   {
            //print("too far right")
            angle_in_degrees = CGFloat((arc4random() % 50 ) + 90)
        }

        if (-1 * self.frame.width / 2) + obstacle_length > obstacles.last!.path!.boundingBox.minX   {
            //print("too far left")
            angle_in_degrees = CGFloat((arc4random() % 50 ) + 40 )
        }

        
        if angle_in_degrees < 90 {
            last_obstacle_direction = "right"
        } else {
            last_obstacle_direction = "left"
        }
        
        ending_position = CGPoint(x: starting_position.x + (obstacle_length * cos(angle_in_degrees * .pi / 180)), y: starting_position.y + (obstacle_length * sin(angle_in_degrees * .pi / 180)))
        let line_path:CGMutablePath = CGMutablePath()
        line_path.move(to: starting_position)
        line_path.addLine(to: ending_position)
        

        projected_path.zPosition = 200
        projected_path.path = line_path
        projected_path.strokeColor = line_segment_colors.randomElement() ?? yellow
        projected_path.lineWidth = 2
        //projected_path.glowWidth = 2
        
        projected_path.name = "projected_path"
        
        projected_path.physicsBody = SKPhysicsBody(edgeChainFrom: line_path)
        projected_path.physicsBody?.categoryBitMask = physicsCategory.obstacle
        projected_path.physicsBody?.collisionBitMask = physicsCategory.projected_velocity
        projected_path.physicsBody?.contactTestBitMask = physicsCategory.projected_velocity
        projected_path.physicsBody?.isDynamic = true
        projected_path.physicsBody?.affectedByGravity = true
        projected_path.physicsBody?.pinned = true
        
        let fall = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.35)
        
        let fall_forever = SKAction.repeatForever(fall)
        
        projected_path.run(fall_forever)
        
        if game_has_started == false {
            projected_path.isPaused = true
        }
        
        addChild(projected_path)
        
        obstacles.append(projected_path)
        
        
    }
    
    func update_high_score(new_score: Double) {
        
        if score > UserDefaults.standard.integer(forKey: "high_score") {
            UserDefaults.standard.set(new_score, forKey: "high_score")
            //print(UserDefaults.standard.integer(forKey: "high_score"))
        }
    }
    
    func update_death_count() {
        
        var current_death_count = UserDefaults.standard.integer(forKey: "death_count")
        current_death_count += 1
        
        UserDefaults.standard.set(current_death_count, forKey: "death_count")
    
    }
 
    
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        
        for touch in touches {
            if game_ended == false {
                
                //print("updating")
                forces.remove(at: 0)
                forces.append(Double(touch.force))
                
                
                var average_force = 0.0
                for force in forces {
                    average_force += force
                }
                average_force = average_force / Double(n_forces)
                
                if touch.force == touch.maximumPossibleForce {
                    average_force = Double(touch.maximumPossibleForce)
                }
                
                block.position.x = starting_block_position.x + ( ((touch.force) * (self.frame.width - CGFloat(2 * block_radius)))/touch.maximumPossibleForce ) 


            }
        }
        
        
        
    }
    
    func vibrateWithHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        
        generator.impactOccurred()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if game_ended == false {
            block.position = starting_block_position
        }
        
        for touch in touches{
            let positionInScene = touch.location(in: self)
            let touchedNode = atPoint(positionInScene)
            
            if let name = touchedNode.name {
                if name == "restart" {
                    restart_scene()
                }
                if name == "home" {
                    if let scene = StartMenu(fileNamed:"StartMenu")
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
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print("touching")

        if contact.bodyA.node?.name == "obstacle" || contact.bodyB.node?.name == "obstacle" {

            if game_has_started == false {
                game_has_started = true
                for obstacle in obstacles {
                    obstacle.isPaused = false
                    score_label.isPaused = false
                    print("game started")
                    first_instructions.removeFromParent()
                    second_instructions.removeFromParent()

                }
            }

        }
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if block.physicsBody?.allContactedBodies().isEmpty ?? false && game_has_started == true && game_ended == false {
            score_label.isPaused = true
            game_ended = true
            update_high_score(new_score: Double(score))
            update_death_count()
            
            //UNCOMMENT THIS GUY FOR ADS TO BE PRESENT
            let current_death_count = UserDefaults.standard.integer(forKey: "death_count")
            let high_score = UserDefaults.standard.integer(forKey: "death_count")
            var frequency = 0
            if high_score > 100 {
                frequency = 1
            } else if high_score > 60 {
                frequency = 2
            } else if high_score > 30 {
                frequency = 3
            } else {
                frequency = 5
            }
            
            
            if current_death_count > 10 && current_death_count % frequency == 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showAd"), object: nil)
            }
            let restart_button = SKSpriteNode(imageNamed: "replay")
            restart_button.position = CGPoint(x: 0, y: 100)
            restart_button.setScale(3.0)
            restart_button.zPosition = 9999999
            restart_button.name = "restart"
            addChild(restart_button)
            
            let home_button = SKSpriteNode(imageNamed: "home")
            home_button.position = CGPoint(x: 0, y: -100)
            home_button.setScale(1.6)
            home_button.zPosition = 9999999
            home_button.name = "home"
            addChild(home_button)
            
            
            for obstacle in obstacles {
                
                obstacle.isPaused = true
                obstacle.strokeColor = UIColor.red
                
                
            }
            vibrateWithHaptic()
        }
        if game_has_started == false || game_ended == true {
            score_label.isPaused = true
            for obstacle in obstacles {
                
                obstacle.isPaused = true
                
                
            }
            
        }
        
    }
}
