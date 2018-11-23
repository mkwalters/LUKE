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
import StoreKit


struct physicsCategory {
    
    static let projected_velocity: UInt32 = 0x1 << 1
    static let obstacle: UInt32 = 0x1 << 2
    static let checkpoint_one: UInt32 = 0x1 << 3
    static let checkpoint_two: UInt32 = 0x1 << 4
    static let finish_line: UInt32 = 0x1 << 5
    
}

extension SKNode
{
    func addGlow(radius:CGFloat=30)
    {
        let view = SKView()
        let effectNode = SKEffectNode()
        let texture = view.texture(from: self)
        effectNode.shouldRasterize = true
        effectNode.filter = CIFilter(name: "CIGaussianBlur",parameters: ["inputRadius":radius])
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var block_radius = 0.0
    var block = SKShapeNode(circleOfRadius: CGFloat(0))
    var starting_block_position = CGPoint()
    let line = SKShapeNode()
    
    var first_instructions = SKLabelNode()
    var second_instructions = SKLabelNode()
    
    var end_joints = [SKShapeNode]()
    var joints = [SKEmitterNode]()
    
    var obstacles = [SKShapeNode]()
    var game_ended = false
    
    var obstacle_length = CGFloat()
    
    var last_obstacle_direction = "left"
    
    let purple = UIColor(displayP3Red: 39.0 / 255.0, green: 16.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    let green = SKColor(red: 57.0 / 255.0, green: 255.0 / 255.0, blue: 52.0 / 255.0, alpha: 20.0)
    
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
    
    let score_y_offset = CGFloat(20)
    let score_x_offset = CGFloat(20)
    var number_of_starting_obstacles = 0
    
    let block_y_offset = CGFloat(25)
    
    var instructions_background = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        create_scene()
    
    }
    
    func restart_scene() {
        
        removeAllActions()
        removeAllChildren()
        create_scene()
        
    }
    
    
    func create_scene() {
//        let end_joint = SKEmitterNode(fileNamed: "MyParticle")!
//        end_joint.position = CGPoint.zero
//        addChild(end_joint)
        self.physicsWorld.contactDelegate = self
        forces = []
        for _ in 1...n_forces {
            forces.append(0.0)
        }
        
        instructions_background = SKSpriteNode(color: UIColor(displayP3Red: 40.0 / 255.0, green: 40.0 / 255.0, blue: 40.0 / 255.0, alpha: 0.9), size: CGSize(width: self.frame.width - 90, height: 200))
        instructions_background.zPosition = 99999
        
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

        let latest_high_score = UserDefaults.standard.integer(forKey: "high_score")
        
        backgroundColor = UIColor(displayP3Red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        game_has_started = false
        game_ended = false
        obstacles = []
        block_radius = Double(self.frame.width / 10)
        score = 0
        number_of_starting_obstacles = 20
        
        first_instructions = SKLabelNode(text: "Press harder to move right")
        first_instructions.position = CGPoint(x: 0, y: 25)
        first_instructions.fontName = "Futura-MediumItalic"
        first_instructions.fontSize = 50
        first_instructions.fontColor = UIColor.white
        
        instructions_background.addChild(first_instructions)
        second_instructions = SKLabelNode(text: "Contact line to begin moving")
        second_instructions.position = CGPoint(x: 0, y: -50)
        second_instructions.fontName = "Futura-MediumItalic"
        second_instructions.fontSize = 47
        second_instructions.fontColor = UIColor.white
        
        instructions_background.addChild(second_instructions)
        
        
        //I LIKE IT DIVIDED BY 3
        obstacle_length = self.frame.width / 3
        
        starting_block_position = CGPoint(x: -1 * self.frame.width / 2 + CGFloat(block_radius), y: -1 * self.frame.height / 2 + CGFloat(block_radius) + block_y_offset)
        block = SKShapeNode(circleOfRadius: CGFloat(block_radius))
        
        block.position = CGPoint(x: 0, y: 0)
        
        block.fillColor = green
        block.strokeColor = green
        
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
        block.addGlow()
        
        score_label = SKLabelNode(text: String(score))
        score_label.fontName = "Futura-MediumItalic"
        score_label.fontSize = 70
        score_label.fontColor = UIColor.white
        score_label.horizontalAlignmentMode = .right
        score_label.position = CGPoint(x: self.frame.width / 2 - score_x_offset , y: self.frame.height / 2 - score_label.frame.height - score_y_offset)
        
        addChild(score_label)
        
        high_score_label = SKLabelNode(text: String(latest_high_score))
        high_score_label.fontName = "Futura-MediumItalic"
        high_score_label.fontSize = 70
        high_score_label.fontColor = UIColor.white
        high_score_label.horizontalAlignmentMode = .left
        high_score_label.position = CGPoint(x: -1 * self.frame.width / 2 + score_x_offset , y: self.frame.height / 2 - high_score_label.frame.height - score_y_offset)
        
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
        
        
        let joint = SKEmitterNode(fileNamed: "MyParticle")!
        joint.position = CGPoint.zero
        addChild(joint)
        joints.append(joint)
        
        
        for i in stride(from: 20, through: 0, by: -1) {
            make_obstacle(starting: true, new: false)
        }
        
        for _ in 0...20 {
            make_obstacle(starting: false, new: false)
        }
        
        
    }
    
    func determine_obstacle_angle() -> CGFloat {
        var angle_in_degrees = CGFloat((arc4random() % 100) + 40)
        if obstacles.count > 0 {
            if (self.frame.width / 2) - obstacle_length <  obstacles.last!.path!.boundingBox.maxX   {
                //print("too far right")
                angle_in_degrees = CGFloat((arc4random() % 50 ) + 90)
            }
        
        
            if (-1 * self.frame.width / 2) + obstacle_length > obstacles.last!.path!.boundingBox.minX   {
                //print("too far left")
                angle_in_degrees = CGFloat((arc4random() % 50 ) + 40 )
            }
        }
        flip_angle_switch(angle: angle_in_degrees)
        return angle_in_degrees
    }
    
    func flip_angle_switch(angle: CGFloat) {
        if angle < 90 {
            last_obstacle_direction = "right"
        } else {
            last_obstacle_direction = "left"
        }
    }
    
    func make_obstacle(starting: Bool, new: Bool ) {
        
        //THIS WILL BREAK IF OBSTACLES ARRAY IS NILL
        //OBSRACLES GETS ONE ELEMENT FROM CREATE_SCENEz
        
        let projected_path = SKShapeNode()
        //let fall_distance = -100
        
        var starting_position = CGPoint(x: 400, y: -700)
        var ending_position = CGPoint(x: 300, y: 300)
        
        if obstacles.count > 0 {
            if last_obstacle_direction == "left" {
                starting_position = CGPoint(x: obstacles.last!.path!.boundingBox.minX, y: obstacles.last!.frame.maxY)
            } else {
                starting_position = CGPoint(x: obstacles.last!.path!.boundingBox.maxX, y: obstacles.last!.frame.maxY)
            }
        }
        
        let angle_in_degrees = self.determine_obstacle_angle()

        ending_position = CGPoint(x: starting_position.x + (obstacle_length * cos(angle_in_degrees * .pi / 180)), y: starting_position.y + (obstacle_length * sin(angle_in_degrees * .pi / 180)))
        
//        if new {
//            starting_position.y += CGFloat(fall_distance)
//            ending_position.y += CGFloat(fall_distance)
//        }
//
        if starting {
            starting_position = CGPoint(x: 0, y: CGFloat(number_of_starting_obstacles) * -1 * obstacle_length)
            ending_position = CGPoint(x: 0, y: CGFloat(number_of_starting_obstacles + 1) * -1 * obstacle_length)
            number_of_starting_obstacles -= 1
        }
        
        let glow_width = CGFloat(5)
        let line_width = CGFloat(2)
        
        let line_path:CGMutablePath = CGMutablePath()
        line_path.move(to: starting_position)
        line_path.addLine(to: ending_position)
        projected_path.zPosition = 200
        projected_path.path = line_path
        projected_path.strokeColor = green
        projected_path.lineWidth = line_width
        //projected_path.glowWidth = 2
        
        projected_path.name = "projected_path"
        
        projected_path.physicsBody = SKPhysicsBody(edgeChainFrom: line_path)
        projected_path.physicsBody?.categoryBitMask = physicsCategory.obstacle
        projected_path.physicsBody?.collisionBitMask = physicsCategory.projected_velocity
        projected_path.physicsBody?.contactTestBitMask = physicsCategory.projected_velocity
        projected_path.physicsBody?.isDynamic = true
        projected_path.physicsBody?.affectedByGravity = true
        projected_path.physicsBody?.pinned = true
        projected_path.glowWidth = glow_width
        
        
        
        let joint = SKEmitterNode(fileNamed: "MyParticle")!
        joint.position = ending_position
        addChild(joint)
        
        joints.append(joint)

        run_fall_forever(node: projected_path)
        if game_has_started {
            run_fall_forever(node: joint)
            joint.yAcceleration = 300
        }
        if game_has_started == false {
            projected_path.isPaused = true
            //end_joint.isPaused = true
        }
        addChild(projected_path)
        
        obstacles.append(projected_path)
        
    }
    
    func update_high_score(new_score: Double) {
        
        if score > UserDefaults.standard.integer(forKey: "high_score") {
            UserDefaults.standard.set(new_score, forKey: "high_score")
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
    
    func go_to_start_menu() {
        if let scene = StartMenu(fileNamed:"StartMenu")
        {
            let skView = self.view! as SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            skView.ignoresSiblingOrder = true

            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
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
                    go_to_start_menu()
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func run_fall_forever(node: SKNode) {
        let fall = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.28)
        node.run(SKAction.repeatForever(fall), withKey: "fall")
    }
    
    func start_obstacle_spawn() {
//        let spawn = SKAction.run({
//            self.make_obstacle(starting: false, new: true)
//
//        })
//        let wait = SKAction.wait(forDuration: 0.28)
//
//        let sequence = SKAction.sequence([wait, spawn])
//
//        let spawn_forever = SKAction.repeatForever(sequence)
//        score_label.run(spawn_forever)
    }
    func unpause_obstacles() {
        for obstacle in obstacles {
            obstacle.isPaused = false
            score_label.isPaused = false
            //print("game started")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "obstacle" || contact.bodyB.node?.name == "obstacle" {

            if game_has_started == false {
                
                //start_obstacle_spawn()
                game_has_started = true
                instructions_background.removeFromParent()
                unpause_obstacles()
                for joint in joints {
                    run_fall_forever(node: joint)
                    joint.yAcceleration = 300
                }
            }

        }
        
    }
    
    func get_high_score() -> Int {
        return(UserDefaults.standard.integer(forKey: "high_score"))
    }
    func get_death_count() -> Int {
        return(UserDefaults.standard.integer(forKey: "death_count"))
    }
    
    func add_restart_and_home_button() {
        let restart_button = SKSpriteNode(imageNamed: "replay")
        restart_button.position = CGPoint(x: 0, y: 100)
        restart_button.setScale(3.0)
        restart_button.zPosition = 9999999
        restart_button.name = "restart"
        //restart_button.addGlow()
        addChild(restart_button)
        
        let home_button = SKSpriteNode(imageNamed: "home")
        home_button.position = CGPoint(x: 0, y: -100)
        home_button.setScale(1.6)
        home_button.zPosition = 9999999
        home_button.name = "home"
        addChild(home_button)
    }
    
    func pause_obstacles() {
        for obstacle in obstacles {
            obstacle.isPaused = true
        }
        score_label.isPaused = true
    }
    func pause_joints() {
        for joint in joints {
            joint.removeAction(forKey: "fall")
            joint.yAcceleration = 0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

        if obstacles.last!.frame.maxY < 1000 {
            print("spawning")
            make_obstacle(starting: false, new: true)
        }
        
        if obstacles.first!.frame.maxY < -1000 {
            print("purging")
            obstacles.first?.removeAllActions()
            obstacles.first?.removeFromParent()
            obstacles.removeFirst()
            
            
            joints.first?.removeAllActions()
            joints.first?.removeFromParent()
            joints.removeFirst()
            
        }
        
        if block.physicsBody?.allContactedBodies().isEmpty ?? false && game_has_started == true && game_ended == false {
            
            game_ended = true
            update_high_score(new_score: Double(score))
            update_death_count()
            
            if get_high_score() > 10 && get_death_count() % 5 == 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showAd"), object: nil)
            }
            add_restart_and_home_button()
            
            pause_obstacles()
            pause_joints()

            vibrateWithHaptic()
        }
        if game_has_started == false || game_ended == true {
            pause_obstacles()
        }

    }
    
}
