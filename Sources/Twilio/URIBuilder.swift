internal struct URIBuilder {
    private let uriPrefix: String
    private let chatServiceSid: String

    internal init(
        scheme: String = "https",
        hostname: String,
        basePath: String,
        chatServiceSid: String
    ) {
        self.uriPrefix = "\(scheme)://\(hostname)/\(basePath)"
        self.chatServiceSid = chatServiceSid
    }

    internal func uri(for endpoint: ChatEndpoint) throws -> String {
        return try "\(uriPrefix)/\(chatServiceSid)/" + endpoint.path()
    }
}
