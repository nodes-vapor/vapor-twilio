import Foundation
import HTTP
import JWT
import Punctual
import TLS
import Vapor

public struct TwilioClient {
    public let settings: TwilioSettings

    fileprivate let client: ClientProtocol
    fileprivate let headers: [HeaderKey: String]
    fileprivate let now: () -> Date
    fileprivate let uriBuilder: URIBuilder

    public init(
        clientFactory: ClientFactoryProtocol,
        now: @escaping () -> Date = Date.init,
        settings: TwilioSettings
    ) throws {
        self.now = now
        self.settings = settings

        let hostname = "chat.twilio.com"
        client = try clientFactory.makeClient(
            hostname: hostname,
            port: 443,
            securityLayer: .tls(Context(.client))
        )

        headers = settings.basicAuthHeaders()
        uriBuilder = URIBuilder(
            hostname: hostname,
            basePath: "v2/Services",
            chatServiceSid: settings.chatServiceSid
        )
    }
}

// MARK: Channels
extension TwilioClient {
    public func channels() throws -> [Channel] {
        let channelList: ChannelList = try decode(respond(to: .channels))
        return channelList.channels
    }

    public func createChannel(_ channel: Channel) throws -> Channel {
        return try decode(respond(to: .channels, method: .post, body: channel))
    }

    public func deleteChannel(_ channel: Channel) throws {
        try respond(to: .channel(channel), method: .delete)
    }

    public func updateChannel(_ channel: Channel) throws {
        try respond(to: .channel(channel), method: .post, body: channel)
    }
}

// MARK: Members
extension TwilioClient {
    public func members(in channel: Channel) throws -> [Member] {
        let memberList: MemberList = try decode(respond(to: .members(channel)))
        return memberList.members
    }

    public func createMember(
        _ member: Member,
        in channel: Channel
    ) throws -> Member {
        return try decode(
            respond(to: .members(channel), method: .post, body: member)
        )
    }

    public func deleteMember(
        _ member: Member,
        from channel: Channel
    ) throws {
        try respond(to: .member(channel, member), method: .delete)
    }
}

// MARK: Users
extension TwilioClient {
    public func users() throws -> [User] {
        let userList: UserList = try decode(respond(to: .users))
        return userList.users
    }

    public func createUser(_ user: User) throws -> User {
        return try decode(respond(to: .users, method: .post, body: user))
    }

    public func deleteUser(_ user: User) throws {
        try respond(to: .user(user), method: .delete)
    }

    public func updateUser(_ user: User) throws {
        try respond(to: .user(user), method: .post, body: user)
    }
}

// MARK: Access Token
extension TwilioClient {

    /// see: https://www.twilio.com/docs/api/rest/access-tokens#jwt-format
    public func createAccessToken(grants: [Grant]) throws -> JWT {
        let now = self.now()

        guard let expirationDate = now + settings.ttl.seconds else {
            throw Abort(.internalServerError)
        }

        let headers = [
            ContentTypeHeader(contentType: "twilio-fpa;v=1")
        ]

        let jwtId = "\(settings.apiKeySid)-\(Int(now.timeIntervalSince1970))"

        let payload = JSON([
            ExpirationTimeClaim(date: expirationDate),
            GrantsClaim(grants: grants),
            IssuerClaim(string: settings.apiKeySid),
            JWTIDClaim(string: jwtId),
            NotBeforeClaim(date: now),
            SubjectClaim(string: settings.accountSid)
        ])

        let signer = HS256(key: settings.apiKeySecret.makeBytes())

        return try JWT(
            additionalHeaders: headers,
            payload: payload,
            signer: signer
        )
    }
}

extension TwilioClient {
    internal func decode<T: Decodable>(_ response: Response) throws -> T {
        guard case .data(let bytes) = response.body else {
            throw TwilioError.unexpectedResponseFromTwilio
        }

        return try JSONDecoder().decode(T.self, from: Data(bytes))
    }

    @discardableResult
    internal func respond(
        to endpoint: ChatEndpoint,
        method: HTTP.Method = .get,
        body: NodeRepresentable? = nil
    ) throws -> Response {
        let request = try Request(
            method: method,
            uri: uriBuilder.uri(for: endpoint),
            headers: headers
        )
        request.formURLEncoded = try body?.makeNode(in: nil)

        let response = try client.respond(to: request)

        try assertCorrect(response.status, for: method)

        return response
    }

    internal func assertCorrect(_ status: Status, for method: HTTP.Method) throws {
        switch (status, method) {
        case (.noContent, .delete),
             (.created, .post),
             (.ok, .get),
             (.ok, .post):
            return
        case (.conflict, .post):
            throw TwilioError.conflict
        case (.notFound, _):
            throw TwilioError.notFound
        default:
            throw TwilioError.unexpectedResponseFromTwilio
        }
    }
}
