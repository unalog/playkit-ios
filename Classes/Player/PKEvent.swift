// ===================================================================================================
// Copyright (C) 2017 Kaltura Inc.
//
// Licensed under the AGPLv3 license, unless a different license for a 
// particular library is specified in the applicable library path.
//
// You may obtain a copy of the License at
// https://www.gnu.org/licenses/agpl-3.0.html
// ===================================================================================================

import Foundation
import AVFoundation

/// PKEvent
@objc open class PKEvent: NSObject {
    // Events that have payload must provide it as a dictionary for objective-c compat.
    @objc public let data: [String: Any]?
    
    @objc public required init(_ data: [String: Any]? = nil) {
        self.data = data
        super.init()
        self.namespace = self.getEventNamespace()
    }
    
    private(set) public var namespace: String = ""
    
    private func getEventNamespace() -> String {
        var namespace = ""
        var mirror: Mirror? = Mirror(reflecting: self)
        while let m = mirror, m.subjectType != PKEvent.self && m.subjectType != NSObject.self {
            namespace = namespace == "" ? String(describing: m.subjectType) : "\(String(describing: m.subjectType))." + namespace
            mirror = m.superclassMirror
        }
        return namespace
    }
}

// MARK: - PKEvent Data Accessors Extension
public extension PKEvent {
    // MARK: - Event Data Keys
    struct EventDataKeys {
        static let duration = "duration"
        static let targetSeekPosition = "targetSeekPosition"
        static let tracks = "tracks"
        static let selectedTrack = "selectedTrack"
        static let playbackInfo = "playbackInfo"
        static let oldState = "oldState"
        static let newState = "newState"
        static let error = "error"
        static let metadata = "metadata"
        static let mediaSource = "mediaSource"
        static let timeRanges = "timeRanges"
        static let bitrate = "bitrate"
    }
    
    // MARK: Player Data Accessors
    
    /// Duration Value, PKEvent Data Accessor
    @objc public var duration: NSNumber? {
        return self.data?[EventDataKeys.duration] as? NSNumber
    }
    
    /// Duration Value, PKEvent Data Accessor
    @objc public var targetSeekPosition: NSNumber? {
        return self.data?[EventDataKeys.targetSeekPosition] as? NSNumber
    }
    
    /// Tracks Value, PKEvent Data Accessor
    @objc public var tracks: PKTracks? {
        return self.data?[EventDataKeys.tracks] as? PKTracks
    }
    
    /// Selected Track Value, PKEvent Data Accessor
    @objc public var selectedTrack: Track? {
        return self.data?[EventDataKeys.selectedTrack] as? Track
    }
    
    /// Indicated Bitrate, PKEvent Data Accessor
    @objc public var bitrate: NSNumber? {
        return self.data?[EventDataKeys.bitrate] as? NSNumber
    }
    
    /// Current Bitrate Value, PKEvent Data Accessor
    @objc public var playbackInfo: PKPlaybackInfo? {
        return self.data?[EventDataKeys.playbackInfo] as? PKPlaybackInfo
    }
    
    /// Current Old State Value, PKEvent Data Accessor
    @objc public var oldState: PlayerState {
        guard let oldState = self.data?[EventDataKeys.oldState] as? PlayerState else {
            return PlayerState.unknown
        }
        
        return oldState
    }
    
    /// Current New State Value, PKEvent Data Accessor
    @objc public var newState: PlayerState {
        guard let newState = self.data?[EventDataKeys.newState] as? PlayerState else {
            return PlayerState.unknown
        }
        
        return newState
    }
    
    /// Associated error from error event, PKEvent Data Accessor
    @objc public var error: NSError? {
        return self.data?[EventDataKeys.error] as? NSError
    }
    
    /// Associated metadata from the event, PKEvent Data Accessor
    @objc public var timedMetadata: [AVMetadataItem]? {
        return self.data?[EventDataKeys.metadata] as? [AVMetadataItem]
    }
    
    /// Content url, PKEvent Data Accessor
    @objc public var mediaSource: PKMediaSource? {
        return self.data?[EventDataKeys.mediaSource] as? PKMediaSource
    }
    
    /// Content url, PKEvent Data Accessor
    @objc public var timeRanges: [PKTimeRange]? {
        return self.data?[EventDataKeys.timeRanges] as? [PKTimeRange]
    }
}
