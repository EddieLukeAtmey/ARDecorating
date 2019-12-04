//
//  ViewController.swift
//  ARDecorating
//
//  Created by Eddie on 12/3/19.
//  Copyright © 2019 Eddie. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

final class ViewController: UIViewController {

    @IBOutlet private weak var vArScene: ARView!

    /// A view that instructs the user's movement during session initialization.
    let coachingOverlay = ARCoachingOverlayView()
    let horizontalAnchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.15, 0.15])
//    let focusSquare = FocusSquare()

    override func viewDidLoad() {
        super.viewDidLoad()
        vArScene.debugOptions = [.showAnchorOrigins, .showAnchorGeometry, .showPhysics, .showWorldOrigin, .showFeaturePoints, .showStatistics]
        vArScene.session.delegate = self
        setupCoachingOverlay()

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.isLightEstimationEnabled = true
        vArScene.session.run(config)

        vArScene.scene.addAnchor(horizontalAnchor)
//        vArScene.scene.anchors.first?.addChild(focusSquare)
    }

    @IBAction private func loadTable() {

        if let entity = horizontalAnchor.findEntity(named: "table") {
            horizontalAnchor.removeChild(entity)
            return
        }

        do {
            let table = try VirtualObject.loadModel(named: "VirtualObjects.scnassets/Table/table.obj")
            table.name = "table"
            var material = SimpleMaterial()
            material.baseColor = try .texture(.load(named: "VirtualObjects.scnassets/Table/textures/WoodSeemles.jpg"))
            table.model?.materials = [material]

            horizontalAnchor.addChild(table)
            table.scale = [1, 1, 1] * 0.002
            table.generateCollisionShapes(recursive: true)

            // enable dragging
            vArScene.installGestures([.translation, .rotation], for: table)

        }
        catch { print(error) }
    }

    @IBAction private func loadItem() {

//        guard let item = try? ModelEntity.loadModel(named: "VirtualObjects.scnassets/Glass/Glass.obj") else { return }
        guard let item = try? ARDecoratingContent.loadBread() else { return }
//        var material = SimpleMaterial()
//        material.baseColor = try .texture(.load(named: "VirtualObjects.scnassets/Table/textures/WoodSeemles.jpg"))
//        item.model?.materials = [material]

        horizontalAnchor.addChild(item)
        horizontalAnchor.children.append(item)
//        item.scale = [1, 1, 1] * 0.002
        item.generateCollisionShapes(recursive: true)

        // enable dragging
        vArScene.installGestures([.translation, .rotation], for: item)
    }
}

extension ARDecoratingContent.Bread: HasCollision {}

extension ViewController: ARCoachingOverlayViewDelegate {

    func setupCoachingOverlay() {
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.activatesAutomatically = true

        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        vArScene.addSubview(coachingOverlay)

        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        print("\(#function)")
    }

    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("\(#function)")
    }

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingOverlayView.removeFromSuperview()
        print("\(#function)")
    }
}

/// Used to find a horizontal plane anchor before placing the game into the world.
extension ViewController: ARSessionDelegate {

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("\(#function), \(anchors)")
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("\(#function), \(anchors)")
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("\(#function), \(anchors)")
    }

    private func normalize(_ matrix: float4x4) -> float4x4 {
        var normalized = matrix
        normalized.columns.0 = simd.normalize(normalized.columns.0)
        normalized.columns.1 = simd.normalize(normalized.columns.1)
        normalized.columns.2 = simd.normalize(normalized.columns.2)
        return normalized
    }
}
