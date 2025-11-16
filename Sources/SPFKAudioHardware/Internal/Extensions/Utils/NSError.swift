// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKAudioHardware
// Based on SimplyCoreAudio by Ruben Nine (c) 2014-2023. Revision History at https://github.com/rnine/SimplyCoreAudio

import Foundation

extension NSError {
    convenience init(
        description: String,
        domain: String = Bundle.main.bundleIdentifier ?? "SPFKAudioHardware",
        code: Int = 1
    ) {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: description,
        ]

        self.init(
            domain: domain,
            code: code,
            userInfo: userInfo
        )
    }
}
