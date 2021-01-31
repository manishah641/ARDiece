//
//  ViewController.swift
//  ARDiece
//
//  Created by Syed Muhammad on 22/04/2020.
//  Copyright © 2020 Syed Muhammad. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
//        sceneView.delegate = self
//        let sphere = SCNSphere(radius: 0.2)
//
////        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        let metrial = SCNMaterial()
//        metrial.diffuse.contents = UIImage(named:"art.scnassets/8k_mercury.jpg")
//        sphere.materials = [metrial]
//
//        let node = SCNNode()
//        node.position = SCNVector3(x:0, y: 0.1, z: -0.5)
//        node.geometry = sphere
//
//        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
//        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceColladacopy.scn")!
//       if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
//        diceNode.position = SCNVector3(0, 0, -0.1)
//        sceneView.scene.rootNode.addChildNode(diceNode)
//        }
       
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
           configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitResult = result.first{
          //        // Create a new scene
                    let diceScene = SCNScene(named: "art.scnassets/diceColladacopy.scn")!
                   if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
                    diceNode.position = SCNVector3(
                        hitResult.worldTransform.columns.3.x,
                        hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        hitResult.worldTransform.columns.3.z)
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
                     let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
                    diceNode.runAction(
                        SCNAction.moveBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5)
                    )
                }
                       
                //        // Set the scene to the view
                //        sceneView.scene = scene
            }
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            let placeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(placeAnchor.extent.x), height: CGFloat(placeAnchor.extent.z))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: placeAnchor.center.x, y: 0, z: placeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            let gridMeterial = SCNMaterial()
            gridMeterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMeterial]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
            
        }else {
            return
        }
    }


}
