import Node

// see: https://www.twilio.com/docs/api/chat/rest/users
public struct User: Decodable, TwilioModel {
    internal enum CodingKeys: String, CodingKey {
        case sid
        case identity
        case friendlyName = "friendly_name"
    }

    public var uniqueId: String? {
        return identity
    }

    public let sid: String?

    // A unique string identifier for a User in this Service
    let identity: String
    let friendlyName: String?

    public init(
        sid: String? = nil,
        identity: String,
        friendlyName: String? = nil
    ) {
        self.sid = sid
        self.identity = identity
        self.friendlyName = friendlyName
    }
}

extension User: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set("Identity", identity)
        try node.set("FriendlyName", friendlyName)

        return node
    }
}

public struct UserList: Decodable {
    let users: [User]
}
