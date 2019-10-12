//
//  ARViewController.swift
//  TrunkFit
//
//  Created by Turner Thornberry on 10/8/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBAction func buttonTap(_ sender: UIButton) {
        if focusSquare.lastPosition != nil {
            showTrunk()
        }
    }
    

    // Prompts user to find planes
    let coachingOverlay = ARCoachingOverlayView()
    var focusSquare = FocusSquare()
    
    // Because I'm lazy
    let updateQueue = DispatchQueue.main
    
    // flag to indicate if user has placed trunk
    var hasShownTrunk = false
    
   // MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBarTransparent(controller: self)
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Configure Plane Detection
        setupCoachingOverlay()
        setActivatesAutomatically()
        setGoal()
        
        // Add Focus Square so user knows where they will place trunk
        sceneView.scene.rootNode.addChildNode(focusSquare)
        sceneView.autoenablesDefaultLighting = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // configure session to look for horizontal planes
        configuration.planeDetection = .horizontal


        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    // MARK: - Showing Trunk
    func showTrunk() {
        if hasShownTrunk != true {
            // width is front/back, length is left/right from focus square
            
            showTrunkOriginPoint(position: SCNVector3(focusSquare.lastPosition!))
            
            // Create Nodes
            let bottomPlane = SCNBox(width: 1.1, height: 0.01, length: 1.0, chamferRadius: 0)
            var bottomPlaneNode = SCNNode(geometry: bottomPlane)
            
            let frontPlane = SCNBox(width: 1.1, height: 0.31, length: 1.0, chamferRadius: 0)
            var frontPlaneNode = SCNNode(geometry: bottomPlane)
            
            let backPlane = SCNBox(width: 1.1, height: 0.31, length: 1.0, chamferRadius: 0)
            var backPlaneNode = SCNNode(geometry: bottomPlane)
            
            
            
            
            // Place Node at center of current focus square position
            bottomPlaneNode.position = SCNVector3(focusSquare.lastPosition!)
            frontPlaneNode.position = SCNVector3(focusSquare.lastPosition!)
            backPlaneNode.position = SCNVector3(focusSquare.lastPosition!)
            
            // normalize to right-hand 3-D coordinate system originating from center of focus square & adjust accordingly...
            // !!!IMPORTANT NOTE!!!: byAng MUST take 2 params: the x and z vector angle
            //       transforms in degrees, respectively. [x, z]
            bottomPlaneNode = adjust(initialNode: bottomPlaneNode,
                                     byPos: SCNVector3(0, 0, -Float(bottomPlane.length/2)),
                                     byAngDeg: [0,0])
            
            frontPlaneNode = adjust(initialNode: frontPlaneNode,
                                    byPos: SCNVector3(0, 0, 0),
                                    byAngDeg: [90, 0])
            
            backPlaneNode = adjust(initialNode: frontPlaneNode,
                                               byPos: SCNVector3(0, 0, -Float(bottomPlane.length/2)),
                                               byAngDeg: [0, 0])
            
            // Create material to be used
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.gray
            material.transparency = CGFloat(0.99)
            
            
            
            // Add materials to planes
            bottomPlane.firstMaterial  = material
            frontPlane.firstMaterial = material
            backPlane.firstMaterial = material
            
            // Add nodes to scene
            sceneView.scene.rootNode.addChildNode(bottomPlaneNode)
            // sceneView.scene.rootNode.addChildNode(frontPlaneNode)
            sceneView.scene.rootNode.addChildNode(backPlaneNode)

            
        }
        
        hasShownTrunk = true
    }
    
    // MARK: - Internal Functions
    // This function normalizes a starting node to a right-hand
    // coordinate system originating from center of focus square
    // NOTE: byAng MUST take 2 params: the x and z vector angle
    // transforms in degrees, respectively. [x, z]
    func adjust(initialNode: SCNNode, byPos: SCNVector3, byAngDeg: [Float]) -> SCNNode {
        
        let inputNode = initialNode
        
        // rotate about y-axis to reflect orientation user is currently facing
        let cameraEuler = sceneView.session.currentFrame?.camera.eulerAngles.y
        
        inputNode.eulerAngles.x = inputNode.eulerAngles.x + deg2rad(byAngDeg[0])
        inputNode.eulerAngles.y = cameraEuler!
        inputNode.eulerAngles.z = inputNode.eulerAngles.z + deg2rad(byAngDeg[1])
        
        inputNode.position = SCNVector3(inputNode.position.x + byPos.x,
                                        inputNode.position.y + byPos.y,
                                        inputNode.position.z + byPos.z)
        
        return inputNode

    }
    
    // FOR DEBUGGING
    func showTrunkOriginPoint(position: SCNVector3) {
        let sphere = SCNSphere(radius: 0.05)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        sphere.firstMaterial = material
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }

    // MARK: - Focus Square
    func updateFocusSquare(hasPlacedTrunk: Bool) {
        if coachingOverlay.isActive || hasPlacedTrunk {
            // TODO: Hide for production
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            //  statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        }
        
        // Perform ray casting only when ARKit tracking is in a good state.
        if let camera = sceneView.session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = sceneView.getRaycastQuery(),
            let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            if !coachingOverlay.isActive {
                // addObjectButton.isHidden = false
            }
            // statusViewController.cancelScheduledMessage(for: .focusSquare)
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
           // addObjectButton.isHidden = true
           // objectsViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    
}


// MARK: - Coaching Overlay Delegate
extension ViewController: ARCoachingOverlayViewDelegate {
    // https://developer.apple.com/documentation/arkit/placing_objects_and_handling_3d_interaction
    func setupCoachingOverlay() {
        // Set up coaching view
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        setActivatesAutomatically()
        setGoal()
    }
    
    // - Tag: CoachingActivatesAutomatically
    func setActivatesAutomatically() {
        coachingOverlay.activatesAutomatically = true
    }

    // - Tag: CoachingGoal
    func setGoal() {
        coachingOverlay.goal = .horizontalPlane
    }
}

// MARK: - AR Delegates
extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
    // This executes every time user moves camera
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateFocusSquare(hasPlacedTrunk: self.hasShownTrunk)
            // print("\(self.focusSquare.lastPosition)") //
        }
    }
}


// Used to translate a 2d point to 3d space plane
extension ARSCNView {
    
//     Type conversion wrapper for original `unprojectPoint(_:)` method.
//     Used in contexts where sticking to SIMD3<Float> type is helpful.

    func unprojectPoint(_ point: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(unprojectPoint(SCNVector3(point)))
    }
    
    // - Tag: CastRayForFocusSquarePosition
    func castRay(for query: ARRaycastQuery) -> [ARRaycastResult] {
        return session.raycast(query)
    }

    // - Tag: GetRaycastQuery
    func getRaycastQuery(for alignment: ARRaycastQuery.TargetAlignment = .any) -> ARRaycastQuery? {
        return raycastQuery(from: screenCenter, allowing: .estimatedPlane, alignment: alignment)
    }
    
    var screenCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
}




