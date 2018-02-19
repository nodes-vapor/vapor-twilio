import Node

// see: https://www.twilio.com/docs/api/chat/rest/channels
public struct Channel: Decodable, TwilioModel {
    internal enum CodingKeys: String, CodingKey {
        case sid
        case friendlyName = "friendly_name"
        case uniqueName = "unique_name"
        case visibilityType = "type"
    }

    public enum VisibilityType: String, Decodable {
        case `private`
        case `public`
    }

    public var uniqueId: String? {
        return uniqueName ?? sid
    }

    public let sid: String?

    internal let friendlyName: String?
    internal let uniqueName: String?

    internal let visibilityType: VisibilityType?

    public init(
        sid: String? = nil,
        friendlyName: String? = nil,
        uniqueName: String? = nil,
        visibilityType: VisibilityType? = .private
    ) {
        self.sid = sid
        self.friendlyName = friendlyName
        self.uniqueName = uniqueName
        self.visibilityType = visibilityType
    }
}

extension Channel: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set("FriendlyName", friendlyName)
        try node.set("UniqueName", uniqueName)
        try node.set("Type", visibilityType?.rawValue)

        return node
    }
}

public struct ChannelList: Decodable {
    internal let channels: [Channel]
}
