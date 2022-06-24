//
//  PlanetScene.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import SceneKit

class PlanetScene: SCNScene {

  // given a UIImage, build the rotating

  convenience init(withImage image : UIImage) {
    self.init()

    let ambientLight = SCNLight()
    let ambientLightNode = SCNNode()
      ambientLight.type = SCNLight.LightType.ambient
      ambientLight.color = UIColor.white
    ambientLightNode.light = ambientLight
    rootNode.addChildNode(ambientLightNode)

    let sphere = SCNSphere(radius: 0.5)
    let material = createWorldMaterial(withDiffuse: image)
    sphere.materials =  [material]

    let sphereNode = SCNNode(geometry: sphere)
    rootNode.addChildNode(sphereNode)

    // @TODO - add some variable rotation around whatever axis that is
      sphereNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi/2, z: 0, duration: 10)))

  }


  func createWorldMaterial(withDiffuse img: UIImage) -> SCNMaterial {

    CustomFiltersVendor.registerFilters()

    let material = SCNMaterial()
    let context = CIContext()

    let pixelSize = 8

    let newRect = CGRect(
      x: pixelSize,
      y: pixelSize,
      width: Int(img.size.width) - pixelSize * 2,
      height: Int(img.size.height) - pixelSize * 2
    )

    let pixelImg = CIImage(image: img)!
          .applyingFilter("CIPixellate", parameters: ["inputScale": pixelSize])
          .cropped(to: newRect)


      let normalImg = pixelImg
//          .applyingFilter("NormalMap")
          .applyingFilter("CIColorControls", parameters: [kCIInputContrastKey: 30])

      let cgdiffuseMap = context.createCGImage(pixelImg, from: pixelImg.extent)
      let cgNormalMap = context.createCGImage(normalImg, from: normalImg.extent)

    material.diffuse.contents = cgdiffuseMap
    material.normal.contents = cgNormalMap
    material.normal.intensity = 1.0

    return material
  }

}
