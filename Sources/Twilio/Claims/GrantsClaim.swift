import JWT

internal struct GrantsClaim: Claim {
    internal static let name = "grants"
    internal let node: Node

    internal init(grants: [Grant]) {
        node = Node(grants)
    }

    func verify(_ node: Node) -> Bool {
        // verification is done by twilio
        return true
    }
}
