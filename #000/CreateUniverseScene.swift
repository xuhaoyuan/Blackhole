//
//  CreateUniverseScene.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import SpriteKit

let BIG_BANG_HOLD_TIME : TimeInterval = 8

class CreateUniverseScene: SKScene {

    // MARK: Properties

    var universeDelegate : CreateUniverseDelegate?

    let container = SKNode()

    lazy var tapAndHoldNode : SKLabelNode = { [unowned self] in
        return generalTextNode(text: "tap and hold").setPos(to: self.textNodePosition) as! SKLabelNode
    }()

    lazy var keepHoldingNode : SKLabelNode = { [unowned self] in
        return generalTextNode(text: "keep holding").setPos(to: self.textNodePosition) as! SKLabelNode
    }()

    var gravityField : SKFieldNode?
    var gravitySingularity : SKShapeNode?

    var bigBangOccurred = false
    var bigBangTimer : Timer?

    lazy var dustParticleTexture : SKTexture = { [unowned self] in
        let shape = SKShapeNode(rectOf: CGSize(width: 1, height: 1))
        shape.fillColor = Constant.Color.DustColor
        return self.view!.texture(from: shape)!
    }()

    lazy var blackHolePosition : CGPoint = { [unowned self] in
        return CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height * 0.2)
    }()

    lazy var textNodePosition : CGPoint = { [unowned self] in
        return CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height * 0.85)
    }()

    // MARK: Lifecycle Methods

    override func didMove(to view: SKView) {
        backgroundColor = Constant.Color.SpaceBackground ?? .clear
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)

        addChild(container)

        keepHoldingNode.alpha = 0
        container.addChild(keepHoldingNode)

        container.addChild(tapAndHoldNode)
        setTextState(state: .TapAndHold)
    }

    override func didSimulatePhysics() {

        container.enumerateChildNodes(withName: Constant.SpriteKeys.DustParticle, using: { (node, stop) in
            // if the particles are out of bounds, remove them
            if node.position.x < 0 || node.position.x > self.frame.size.width {
                node.removeFromParent()
            } else if node.position.y < 0 || node.position.y > self.frame.size.height {
                node.removeFromParent()
            } else if let g = self.gravitySingularity, g.contains(node.position) {
                node.removeFromParent()
            }
        })
    }

    // MARK: Dust Stuff

    var dustTimer : Timer?

    func beginCreatingDust() {
        dustTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { timer in
            for _ in 1...10 {
                self.createDust()
            }
        })
    }

    func endCreatingDust() {
        dustTimer?.invalidate()

        // destroy all dust particles
        container.enumerateChildNodes(withName: Constant.SpriteKeys.DustParticle, using: { (node, stop) in
            node.run(SKAction.fadeOut(withDuration: 0.5)) {
                node.removeFromParent()
            }
        })
    }

    func createDust() {

        // creates a singular dust particle

        let particleSize : CGFloat = 1.0

        let particle = SKSpriteNode(texture: dustParticleTexture)
        particle.name = Constant.SpriteKeys.DustParticle
        particle.alpha = CGFloat(randomDouble(from: 0.3, to: 1.0))

        let randomX = randomDouble(from: -20.0, to: Double(frame.size.width) + 20.0)
        let randomY = randomDouble(from: -20.0, to: Double(frame.size.height) + 20.0)

        particle.position = CGPoint(x: randomX, y: randomY)
        particle.physicsBody = SKPhysicsBody(circleOfRadius: particleSize)
        container.addChild(particle)
    }

    // MARK: Singularity Stuff

    func createSingularity(at loc: CGPoint) {
        gravitySingularity = SKShapeNode(circleOfRadius: self.frame.size.width * 0.05)

        guard let gravitySingularity = gravitySingularity else { return }

        gravitySingularity.fillColor = .black
        gravitySingularity.strokeColor = .white
        gravitySingularity.glowWidth = 1

        gravitySingularity.position = loc
        gravitySingularity.setScale(0.01)

        gravityField = self.createRadialGravityField()
        gravitySingularity.addChild(gravityField!)

        container.addChild(gravitySingularity)

        gravitySingularity.run(SKAction.scale(to: 1.0, duration: 5.0))
    }

    func removeSingularity() {
        gravitySingularity?.removeFromParent()
        gravitySingularity = nil

        self.gravityField?.removeFromParent()
        self.gravityField = nil
    }

    func createRadialGravityField() -> SKFieldNode {
        let gravityField = SKFieldNode.radialGravityField()
        gravityField.strength = 12
        gravityField.falloff = 0.1

        return gravityField
    }

    var previousState : Constant.StateKeys.CreateUniverse.TextState?

    func setTextState(state: Constant.StateKeys.CreateUniverse.TextState) {
        switch state {
        case .BigBanged:
            tapAndHoldNode.fadeOut(duration: 0.2) { self.tapAndHoldNode.removeFromParent() }
            keepHoldingNode.fadeOut(duration: 0.2) { self.keepHoldingNode.removeFromParent() }
        case .KeepHolding:
            // fade out tap and fade in keep Holding
            tapAndHoldNode.fadeOut(duration: 1.0)
            keepHoldingNode.fadeInAfter(after: 2, duration: 1)
        case .TapAndHold: fallthrough
        default:
            if let _ = previousState {
                // by default
                keepHoldingNode.fadeOut(duration: 0.4)
                tapAndHoldNode.fadeInAfter(after: 1.0, duration: 1.0)
            } else {
                // first run
                tapAndHoldNode.fadeInAfter(after: 1.0, duration: 1.0)
            }
        }

        previousState = state
    }

    // MARK: Big Bang Stuff

    func triggerBigBang() {

        guard let gravitySingularity = gravitySingularity else { return }

        if !bigBangOccurred {
            bigBangOccurred = true

            // stop creating dust
            endCreatingDust()

            // fade out text
            tapAndHoldNode.fadeOut(duration: 0.2)  // just in case
            keepHoldingNode.fadeOut(duration: 0.2)

            // start big bang animations
            let bigBangParticleEmitter = SKEmitterNode(fileNamed: "BigBang.sks")!
            bigBangParticleEmitter.position = gravitySingularity.position
            container.addChild(bigBangParticleEmitter)

            removeSingularity()

            // shake the screen a bit
            container.run(SKAction.shake(duration: 0.8, amplitudeX: 100, amplitudeY: 100)) {
                let blackHole = BlackHole()
                blackHole.setScale(0.01)
                blackHole.position = self.lastTouch ?? CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
                self.container.addChild(blackHole)
                let seq = SKAction.sequence([
                    SKAction.wait(forDuration: 1.0),
                    SKAction.scale(to: 1.0, duration: 1.0),
                    SKAction.wait(forDuration: 1.0),
                    SKAction.move(to: self.blackHolePosition, duration: 3.0)
                ])
                blackHole.run(seq) {
                    self.universeDelegate?.didFinishCreatingUniverse()
                }
            }
        }
    }


    // MARK: Touches State Machine

    var lastTouch : CGPoint?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: container) else { return }

        if !bigBangOccurred {
            lastTouch = loc

            // create a strong radial gravitational field at the touch point
            createSingularity(at: loc)

            // begin spawning "dust" particles that are attracted to the radial field
            beginCreatingDust()

            // fade out the tapAndHoldNode, create the keepHoldingNode if not exists
            setTextState(state: .KeepHolding)

            bigBangTimer = Timer.schedule(delay: BIG_BANG_HOLD_TIME) {[unowned self] timer in
                self.triggerBigBang()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // enable this if I ever find a good way to stop the phone from lagging to death
        if let loc = touches.first?.location(in: self) {
            lastTouch = loc
            gravitySingularity?.position = loc
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // disable gravity
        removeSingularity()

        // turn off dust generation
        endCreatingDust()

        // stop big bang timer
        bigBangTimer?.invalidate()

        // fade out keep holding regardless
        setTextState(state: .TapAndHold)

        if bigBangOccurred {
            // if the big bang occured
            setTextState(state: .BigBanged)

        }
    }
}


protocol CreateUniverseDelegate {
    func didFinishCreatingUniverse()
}
































