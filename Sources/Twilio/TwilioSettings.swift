import HTTP
import Vapor

public struct TwilioSettings {
    internal let accountSid: String
    internal let apiKeySid: String
    internal let apiKeySecret: String
    internal let chatServiceSid: String
    internal let ttl: Int
}

extension TwilioSettings: ConfigInitializable {
    public init(config: Vapor.Config) throws {
        guard
            let twilioConfig = config["twilio"]?.object,
            let accountSid = twilioConfig["accountSid"]?.string,
            let apiKeySid = twilioConfig["apiKeySid"]?.string,
            let apiKeySecret = twilioConfig["apiKeySecret"]?.string,
            let chatServiceSid = twilioConfig["chatServiceSid"]?.string
        else {
            throw Abort(.internalServerError)
        }

        self.accountSid = accountSid
        self.apiKeySid = apiKeySid
        self.apiKeySecret = apiKeySecret
        self.chatServiceSid = chatServiceSid
        ttl = twilioConfig["ttl"]?.int ?? 3600
    }
}

extension TwilioSettings {
    internal func basicAuthHeaders() -> [HeaderKey: String] {
        let basicAuthString = "\(apiKeySid):\(apiKeySecret)"
            .makeBytes().base64Encoded.makeString()
        return [.authorization: "Basic \(basicAuthString)"]
    }

    public func makeChatGrant() -> Chat {
        return Chat(serviceSid: chatServiceSid)
    }
}
