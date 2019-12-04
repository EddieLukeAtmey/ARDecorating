//
//  VirtualObject.swift
//  ARDecorating
//
//  Created by Eddie on 12/4/19.
//  Copyright © 2019 Eddie. All rights reserved.
//

import ARKit
import RealityKit

final class VirtualObject: Entity, HasCollision, HasAnchoring {

//    var modelName: String {
//        return referenceURL.lastPathComponent.replacingOccurrences(of: ".obj", with: "")
//    }

    let allowedAlignment = ARRaycastQuery.TargetAlignment.horizontal

    /// Rotates the first child node of a virtual object.
    /// - Note: For correct rotation on horizontal and vertical surfaces, rotate around
    /// local y rather than world y.
//    var objectRotation: Float {
//        get { return childNodes.first!.eulerAngles.y }
//        set { childNodes.first!.eulerAngles.y = newValue }
//    }

    /// The object's corresponding ARAnchor.
//    var anchor: ARAnchor?

    /// The raycast query used when placing this object.
    var raycastQuery: ARRaycastQuery?

    /// The associated tracked raycast used to place this object.
    var raycast: ARTrackedRaycast?

    /// The most recent raycast result used for determining the initial location
    /// of the object after placement.
    var mostRecentInitialPlacementResult: ARRaycastResult?

    /// Flag that indicates the associated anchor should be updated
    /// at the end of a pan gesture or when the object is repositioned.
    var shouldUpdateAnchor = false

    /// Stops tracking the object's position and orientation.
    /// - Tag: StopTrackedRaycasts
    func stopTrackedRaycast() {
        raycast?.stopTracking()
        raycast = nil
    }
}
