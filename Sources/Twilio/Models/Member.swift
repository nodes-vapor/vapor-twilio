import Node

// see: https://www.twilio.com/docs/api/chat/rest/members
public struct Member: Decodable, TwilioModel {
    public var uniqueId: String? {
        return identity
    }

    internal enum CodingKeys: String, CodingKey {
        case sid
        case identity
    }

    public let sid: String?

    // A unique string identifier for a User in this Service
    internal let identity: String

    public init(
        sid: String? = nil,
        identity: String
    ) {
        self.sid = sid
        self.identity = identity
    }
}

extension Member: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set("Identity", identity)

        return node
    }
}

public struct MemberList: Decodable {
    internal let members: [Member]
}
