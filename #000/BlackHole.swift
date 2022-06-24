//
//  BlackHole.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import SpriteKit

let blackHoleRadius : CGFloat = 40
let singularityRadius : CGFloat = 15

let ANIMATION_KEY = "animation"
let ROTATION_KEY = "rotate"

class BlackHole: SKNode {

    let singularityIdleAtlas = SKTextureAtlas(named: "idle")
    let singularityExcited = SKTextureAtlas(named: "excited")
    var idleFrames = [SKTexture]()
    var excitedFrames = [SKTexture]()

    lazy var innerSingularity : SKSpriteNode = { [unowned self] in

        let innerSize = CGSize(width: singularityRadius * 2, height: singularityRadius * 2)

        let innerSingularity = SKSpriteNode(texture: SKTexture(imageNamed: self.singularityIdleAtlas.textureNames.first!), color: UIColor.black, size: innerSize)
        innerSingularity.physicsBody = SKPhysicsBody(circleOfRadius: singularityRadius)
        innerSingularity.physicsBody?.affectedByGravity = false
        innerSingularity.physicsBody?.isDynamic = false
        innerSingularity.physicsBody?.categoryBitMask = Constant.SpriteMasks.BlackHoleSingularity
        innerSingularity.physicsBody?.collisionBitMask = 0

        for texture in self.singularityIdleAtlas.textureNames {
            self.idleFrames.append(self.singularityIdleAtlas.textureNamed(texture))
        }

        for texture in self.singularityExcited.textureNames {
            self.excitedFrames.append(self.singularityExcited.textureNamed(texture))
        }

        return innerSingularity
    }()

    //  let eventHorizonAtlas = SKTextureAtlas(named: "event_horizon")
    //  var eventHorizonFrames = [SKTexture]()

    lazy var eventHorizon : SKSpriteNode = { [unowned self] in
        let eventHorizon = SKSpriteNode(texture: SKTexture(imageNamed: "event_horizon"))
        eventHorizon.size = CGSize(width: blackHoleRadius * 2.7, height: blackHoleRadius * 2.7)
        eventHorizon.zPosition = -1
        //    for texture in self.eventHorizonAtlas.textureNames.sort() {
        //      self.eventHorizonFrames.append(self.eventHorizonAtlas.textureNamed(texture))
        //    }
        //
        //    eventHorizon.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(self.eventHorizonFrames, timePerFrame: 0.06)))


        return eventHorizon
    }()

    var gravityField : SKFieldNode = {
        let gravityField = SKFieldNode.radialGravityField()
        gravityField.strength = 0.0
        gravityField.categoryBitMask = Constant.FieldMasks.BlackHoleField
        return gravityField
    }()

    override init() {
        super.init()

        name = Constant.SpriteKeys.BlackHole

        physicsBody = SKPhysicsBody(circleOfRadius: blackHoleRadius)
        physicsBody?.categoryBitMask = Constant.SpriteMasks.BlackHole
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false

        addChild(innerSingularity)
        addChild(gravityField)

        runIdleAnimation()
        runFastEventHorizon()
    }

    func introduceEventHorizon() {
        eventHorizon.setScale(0.01)
        addChild(eventHorizon)
        eventHorizon.run(SKAction.scale(to: 1.0, duration: 1.0))
    }

    func runIdleAnimation() {
        innerSingularity.run(SKAction.repeatForever(SKAction.animate(with: self.idleFrames, timePerFrame: 0.5)), withKey: ANIMATION_KEY)
    }

    func runExcitedAnimation() {
        innerSingularity.run(SKAction.repeatForever(SKAction.animate(with: self.excitedFrames, timePerFrame: 0.5)), withKey: ANIMATION_KEY)
    }

    func runFastEventHorizon() {
        eventHorizon.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 15.0)), withKey: ROTATION_KEY)
    }

    func runSlowEventHorizon() {
        eventHorizon.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 20.0)), withKey: ROTATION_KEY)
    }

    func beginConsuming() {
        runExcitedAnimation()
        runSlowEventHorizon()
    }

    func endConsuming() {
        runIdleAnimation()
        runFastEventHorizon()
    }

    func startGravity() {
        gravityField.strength = 0.3
    }

    func endGravity() {
        gravityField.strength = 0.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}






























