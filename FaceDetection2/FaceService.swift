//
//  FaceService.swift
//  FaceDetection2
//
//  Created by Lucheo Antonio Tombini Filho on 29/10/16.
//  Copyright © 2016 Lucheo Antonio Tombini Filho. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "bc711bbec71045ffbad1440a38c999ae")
    
    
}
