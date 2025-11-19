// Copyright Ryan Francesconi. All Rights Reserved. Revision History at https://github.com/ryanfrancesconi/SPFKAudioHardware
// Based on SimplyCoreAudio by Ruben Nine (c) 2014-2023. Revision History at https://github.com/rnine/SimplyCoreAudio

import CoreAudio
@testable import SPFKAudioHardware
import SPFKBase
import Testing

@Suite(.serialized)
class AudioHardwareManagerTests: NullDeviceTestCase {
    @Test func allDevices() async throws {
        let allDevices = await hardwareManager.allDevices

        Log.debug("Found", allDevices.count, "devices: ", allDevices)
    }

    @Test func multipleInstances() async throws {
        var hm1: AudioHardwareManager? = await AudioHardwareManager()
        Log.debug(hm1, await hm1?.allDevices.count, "devices")

        var hm2: AudioHardwareManager? = await AudioHardwareManager()
        Log.debug(hm2, await hm1?.allDevices.count, "devices")

        var hm3: AudioHardwareManager? = await AudioHardwareManager()
        Log.debug(hm3, await hm1?.allDevices.count, "devices")

        await hm1?.dispose()
        hm1 = nil

        await hm2?.dispose()
        hm2 = nil

        await hm3?.dispose()
        hm3 = nil

        try await wait(sec: 2)

        try await tearDown()
    }

    @Test func deviceEnumeration() async throws {
        let nullDevice = try #require(nullDevice)

        let aggregateDevice = try await createAggregateDevice(in: 0.3)

        let allDevices = await hardwareManager.allDevices
        let allDeviceIDs = await hardwareManager.allDeviceIDs
        let allInputDevices = await hardwareManager.allInputDevices
        let allOutputDevices = await hardwareManager.allOutputDevices
        let allIODevices = await hardwareManager.allIODevices
        let allNonAggregateDevices = await hardwareManager.allNonAggregateDevices
        let allAggregateDevices = await hardwareManager.allAggregateDevices

        Log.debug("allDevices", allDevices)
        Log.debug("allInputDevices", allInputDevices)
        Log.debug("allOutputDevices", allOutputDevices)
        Log.debug("allIODevices", allIODevices)
        Log.debug("allNonAggregateDevices", allNonAggregateDevices)
        Log.debug("allAggregateDevices", allAggregateDevices)

        #expect(allDevices.contains(nullDevice))
        #expect(allDeviceIDs.contains(nullDevice.id))
        #expect(allInputDevices.contains(nullDevice))
        #expect(allOutputDevices.contains(nullDevice))
        #expect(allIODevices.contains(nullDevice))
        #expect(allNonAggregateDevices.contains(nullDevice))
        #expect(allAggregateDevices.contains(nullDevice) == false)

        if let aggregateDevice {
            #expect(allAggregateDevices.contains(aggregateDevice))

            #expect(noErr == hardwareManager.removeAggregateDevice(id: aggregateDevice.id))
        }

        try await tearDown()
    }
}
