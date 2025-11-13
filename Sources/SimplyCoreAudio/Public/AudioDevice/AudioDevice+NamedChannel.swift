import Foundation

extension AudioDevice {
    public struct NamedChannel: CustomStringConvertible, Equatable {
        public var description: String {
            var value = "\(scope.title) \(channel)"

            // MacBook air speakers Left channel is named "1". That's dumb.
            if let name, name != "", name != String(channel) {
                value = "\(channel) - " + name
            }

            return value
        }

        var channel: UInt32
        var name: String?
        var scope: Scope

        public init(channel: UInt32, name: String? = nil, scope: Scope) {
            self.channel = channel
            self.name = name
            self.scope = scope
        }
    }

    /// - Returns: A collection of named channels
    public func namedChannels(scope: Scope) -> [NamedChannel] {
        var out = [NamedChannel]()

        let channelCount = channels(scope: scope)

        guard channelCount > 0 else { return [] }

        for i in 1 ... channelCount {
            let string = name(channel: i, scope: scope)?.trimmingCharacters(in: .whitespacesAndNewlines)

            let deviceChannel = NamedChannel(
                channel: i,
                name: string,
                scope: scope
            )

            out.append(deviceChannel)
        }
        return out
    }

    public func preferredChannelsDescription(scope: Scope) -> String? {
        guard let preferredChannelsForStereo = preferredChannelsForStereo(scope: scope) else { return nil }

        var namedChannels = self.namedChannels(scope: .output).filter {
            $0.channel == preferredChannelsForStereo.left || $0.channel == preferredChannelsForStereo.right
        }

        namedChannels = namedChannels.sorted(by: { lhs, rhs -> Bool in
            lhs.channel < rhs.channel
        })

        let stringValues = namedChannels.map {
            $0.description
        }

        return stringValues.joined(separator: " + ")
    }
}
