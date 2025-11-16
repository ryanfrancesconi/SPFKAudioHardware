// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKAudioHardware
// Based on SimplyCoreAudio by Ruben Nine (c) 2014-2023. Revision History at https://github.com/rnine/SimplyCoreAudio

import CoreAudio
import Foundation
import SPFKAudioHardwareC

class AudioDeviceListener: NSObject, SPFKAudioHardwareC.PropertyListenerDelegate {
    var eventHandler: ((AudioDeviceNotification) -> Void)?

    init(eventHandler: ((AudioDeviceNotification) -> Void)?) {
        self.eventHandler = eventHandler
    }
    
    func propertyListener(_ propertyListener: PropertyListener, eventReceived propertyAddress: AudioObjectPropertyAddress) {
        guard let notification = AudioDeviceNotification(propertyAddress: propertyAddress) else { return }
        send(notification: notification)
    }

    private func send(notification: AudioDeviceNotification) {
        Task { @MainActor in
            eventHandler?(notification)
        }
    }
}
