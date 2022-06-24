//
//  SKNode+TextUtils.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

//
//  TextUtils.swift
//  spritekittest
//
//  Created by Matt Condon on 4/26/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import SpriteKit

let FADE_IN = "fadeIn"
let FADE_OUT = "fadeOut"

func generalTextNode(text: String) -> SKLabelNode {
    let node = SKLabelNode(fontNamed: Constant.GenericText.Font.Name)
    node.text = text
    node.fontSize = Constant.GenericText.Font.Size
    node.fontColor = Constant.GenericText.Font.Color
    node.verticalAlignmentMode = .center
    node.horizontalAlignmentMode = .center
    return node
}

func multipleLineText(labelInPut: SKLabelNode) -> SKNode {
    let subStrings:[String] = labelInPut.text!.components(separatedBy: "\n")
    let labelOutPut = SKNode()

    for (i, subString) in subStrings.enumerated() {
        let label = SKLabelNode(fontNamed: labelInPut.fontName)
        label.text = subString
        label.fontColor = labelInPut.fontColor
        label.fontSize = labelInPut.fontSize
        label.position = labelInPut.position
        label.horizontalAlignmentMode = labelInPut.horizontalAlignmentMode
        label.verticalAlignmentMode = labelInPut.verticalAlignmentMode

        let y = CGFloat(i) * labelInPut.fontSize // 0, 22, 44, 66
        label.position = CGPoint(x: 0, y: -y)
        labelOutPut.addChild(label)
    }

    return labelOutPut
}

extension SKLabelNode {
    func setFont(to fontName: String) -> SKLabelNode {
        self.fontName = fontName
        return self
    }

    func toMultilineNode() -> SKNode {
        return multipleLineText(labelInPut: self)
    }
}

extension SKNode {

    @discardableResult
    func setPos(to position: CGPoint) -> SKNode {
        self.position = position
        return self
    }

    @discardableResult
    func addTo(node: SKNode) -> SKNode {
        node.addChild(self)
        return self
    }

    // MARK: Fade In

    @discardableResult
    func fadeIn(duration: TimeInterval, completion: (() -> Void)?) -> SKNode {
        // remove all fadeIn and fadeOut actions
        if self.action(forKey: FADE_IN) != nil {
            self.removeAction(forKey: FADE_IN)
        } else {
            self.alpha = 0
        }

        self.runAction(action: SKAction.fadeIn(withDuration: duration), withKey: FADE_IN, completion: completion)

        return self
    }

    @discardableResult
    func fadeIn(duration: TimeInterval = 1) -> SKNode {
        return fadeIn(duration: duration, completion: nil)
    }

    @discardableResult
    func fadeInAfter(after: TimeInterval = 1, duration: TimeInterval = 1) -> SKNode {
        self.alpha = 0
        self.removeAction(forKey: FADE_IN)

        self.run(SKAction.sequence([
            SKAction.wait(forDuration: after),
            SKAction.fadeIn(withDuration: duration)
        ]), withKey: FADE_IN)
        return self
    }

    // MARK: Fade Out

    @discardableResult
    func fadeOut(duration: TimeInterval, completion: (() -> Void)?) -> SKNode {
        self.removeAction(forKey: FADE_OUT)

        self.runAction(action: SKAction.fadeOut(withDuration: duration), withKey: FADE_OUT, completion: completion)

        return self
    }

    @discardableResult
    func fadeOut(duration: TimeInterval = 1) -> SKNode {
        return self.fadeOut(duration: duration, completion: nil)
    }

    @discardableResult
    func fadeOutAfter(after: TimeInterval = 1, duration: TimeInterval = 1, completion: (() -> Void)? = nil) -> SKNode {
        self.removeAction(forKey: FADE_OUT)

        self.runAction(action: SKAction.sequence([
            SKAction.wait(forDuration: after),
            SKAction.fadeOut(withDuration: duration)
        ]), withKey: FADE_OUT, completion: completion)
        return self
    }

    @discardableResult
    func fadeOutAndRemoveAfter(after: TimeInterval = 1, duration: TimeInterval = 1, completion: (() -> Void)? = nil) -> SKNode {
        self.removeAction(forKey: FADE_OUT)

        self.runAction(action: SKAction.sequence([
            SKAction.wait(forDuration: after),
            SKAction.fadeOut(withDuration: duration),
            SKAction.removeFromParent()
        ]), withKey: FADE_OUT, completion: completion)
        return self
    }

    // MARK: Utils

    func runAction(action: SKAction!, withKey: String!, completion: (() -> Void)?)
    {
        if let completion = completion {
            let completionAction = SKAction.run(completion)
            let compositeAction = SKAction.sequence([action, completionAction])
            run(compositeAction, withKey: withKey)
        } else {
            run(action, withKey: withKey)
        }
    }

}































