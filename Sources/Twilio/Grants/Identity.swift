import Node

public struct Identity: Grant {
    public static let name = "identity"
    public let node: Node

    public init(identity: Node) {
        self.node = identity
    }
}
