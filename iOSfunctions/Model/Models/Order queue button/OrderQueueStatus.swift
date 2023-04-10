//
//  OrderQueueStatus.swift
//  OneOfOne
//
//  Created by Veronika Tsukat on 11.11.2022.
//  Copyright © 2022 YOUMAWO. All rights reserved.
//

import Foundation

public enum OrderQueueStatus: String, Codable {
    case queuePaused = "Paused"
    case queueError = "Error"
    case orderUploading = "Uploading"
    case orderUploaded = "Uploaded"
    case scanIsSaved
    case scanInProgress
    case waiting = "Waiting..."
}
