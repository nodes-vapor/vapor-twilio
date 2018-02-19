import JWT

internal struct ContentTypeHeader: Header {
    internal static let name = "cty"
    internal let node: Node

    internal init(contentType: String) {
        node = .string(contentType)
    }
}
