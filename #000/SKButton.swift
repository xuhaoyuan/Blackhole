//
//  SKButton.swift
//  #000
//
//  Created by Matt Condon on 5/1/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import SpriteKit

typealias OnTapHandler = (SKButton) -> Void

class SKButton : SKLabelNode {

    var onTap : OnTapHandler?

    init(text: String, onTap: @escaping OnTapHandler) {
        super.init()
        self.text = text
        self.onTap = onTap

        self.fontName = Constant.GenericText.Font.Name
        self.fontSize = Constant.GenericText.Font.Size
        self.fontColor = Constant.GenericText.Font.Color

        self.verticalAlignmentMode = .center
        self.horizontalAlignmentMode = .center

        self.isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.onTap?(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
