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

    
    // MARK: - IB connections
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var bottomButton: UIButtonX!
    
    // TODO: Enable button for production
    @IBAction func seatDownUpTap(_ sender: UIButton) {
        // Reset Scene
        // TODO: Figure out why there is issues with adding a model scene
        // TODO: back onto root node after running this snippet
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        // Add proper model
        hasShownTrunk ? putSeatsDown() : showTrunk()
        // Ternary Operator
    }
    
    @IBAction func sceenTap(_ sender: UITapGestureRecognizer) {
        if focusSquare.lastPosition != nil {
            showTrunk()
            focusSquare.hide()
            bottomButton.isHidden = true
        }
    }
    
    
    // Prompts user to find planes
    let coachingOverlay = ARCoachingOverlayView()
    var focusSquare = FocusSquare()
    var modelOriginPoint = SCNVector3()
    
    // Because I'm lazy
    let updateQueue = DispatchQueue.main
    let userDefaults = UserDefaults.standard
    
    // Flag to indicate if user has placed trunk
    var hasShownTrunk = false
    
   // MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBarTransparent(controller: self)
        
        sceneView.delegate = self
        // FOR DEBUG
        // sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // FOR DEBUG
        // sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
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
        
        // Configure session to look for horizontal planes
        configuration.planeDetection = .horizontal
        
        // Hide UI elements so coaching overlay is prioritized
        focusSquare.hide()
        bottomButton.isHidden = true
        
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
        let myBMWint = userDefaults.integer(forKey: "myBMW")

        if hasShownTrunk != true {
            switch myBMWint {
                case 0:
                    print("Showing the X4 closed seat trunk model")
                    showX4trunk()
                case 1:
                    print("Showing the X5 closed seat trunk model")
                    showX5trunk()
                case 2:
                    print("Showing the i3 closed seat trunk model")
                    showi3trunk()
                default:
                    print("Error parsing myBMW from memory")
                }
        }
        hasShownTrunk = true
        bottomButton.isHidden = true
    }
    
    // MARK: - Initializing Trunks
    func showX4trunk() {
        let x4scene = SCNScene(named: "art.scnassets/X4_seatUp.scn")!
        var x4Node = x4scene.rootNode
        x4Node.position = SCNVector3(focusSquare.lastPosition!)
       // normalize to right-hand 3-D coordinate system originating
       // from center of focus square & adjust if needed...
        x4Node = adjust(initialNode: x4Node, byPos: SCNVector3(0.64,0,0))
        sceneView.scene.rootNode.addChildNode(x4Node)
    }
    
    func showX5trunk() {
           let x5scene = SCNScene(named: "art.scnassets/X5_seatUp.scn")!
           var x5Node = x5scene.rootNode
           x5Node.position = SCNVector3(focusSquare.lastPosition!)
          // normalize to right-hand 3-D coordinate system originating
          // from center of focus square & adjust if needed...
           x5Node = adjust(initialNode: x5Node, byPos: SCNVector3(0.64,0,0))
        print(x5Node.position)
           sceneView.scene.rootNode.addChildNode(x5Node)
       }
    
    func showi3trunk() {
              let i3scene = SCNScene(named: "art.scnassets/i3_seatUp.scn")!
              var i3Node = i3scene.rootNode
              i3Node.position = SCNVector3(focusSquare.lastPosition!)
             // normalize to right-hand 3-D coordinate system originating
             // from center of focus square & adjust if needed...
        i3Node = adjust(initialNode: i3Node, byPos: SCNVector3(0.64,0,0))
              sceneView.scene.rootNode.addChildNode(i3Node)
          }
    
    func putSeatsDown() {
        let myBMWint = userDefaults.integer(forKey: "myBMW")
        switch myBMWint {
           case 0:
               print("Showing the X4 open seat trunk model")
               // TODO: showX5trunkOS()
           case 1:
               print("Showing the X5 open seat trunk model")
               // TODO: showi3trunkOS()
           case 2:
               print("Showing the i3 open seat trunk model")
               // TODO: showX4trunkOS()
           default:
               print("Error parsing myBMW from memory")
           }
    }
    
    
    // MARK: - Internal Functions
    // This function normalizes the initial node to a right-hand
    // coordinate system originating from center of focus square
    func adjust(initialNode: SCNNode, byPos: SCNVector3) -> SCNNode {
        
        let inputNode = initialNode

        // rotate about y-axis to reflect orientation user is currently facing
        // and spin by 90 deg so it is easier to see trunk dimensions
        let cameraEuler = sceneView.session.currentFrame?.camera.eulerAngles.y
        inputNode.eulerAngles.y = cameraEuler! + .pi/2
        inputNode.position = SCNVector3(inputNode.position.x + byPos.x,
                                        inputNode.position.y + byPos.y,
                                        inputNode.position.z + byPos.z)
        return inputNode

    }
    
    
    // FOR DEBUGGING, SHOWS THE ORIGIN POINT OF SCENE AFTER ADJUSTMENT
    // AKA: RIGHT HAND COORDINATE SYSTEM POINT OF ORIGIN FROM CENTER
    // OF FOCUS SQUARE
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
    func updateFocusSquare() {
        if coachingOverlay.isActive {
            // TODO: Hide for production
            focusSquare.hide()
            bottomButton.isHidden = true
        } else {
            focusSquare.unhide()
            bottomButton.isHidden = false
        }
        
        // Perform ray casting only when ARKit tracking is in a good state.
        if let camera = sceneView.session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = sceneView.getRaycastQuery(),
            let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
//            if !coachingOverlay.isActive {
//                // addObjectButton.isHidden = false
//            }
//            // statusViewController.cancelScheduledMessage(for: .focusSquare)
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
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
            if !self.hasShownTrunk { self.updateFocusSquare() }
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




