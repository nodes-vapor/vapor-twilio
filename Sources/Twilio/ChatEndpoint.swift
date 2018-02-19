enum ChatEndpoint {
    case channel(Channel)
    case channels
    case member(Channel, Member)
    case members(Channel)
    case user(User)
    case users
}

extension ChatEndpoint {
    func path() throws -> String {
        switch self {
        case .channel(let channel):
            return try "Channels/\(channel.assertUniqueId())"
        case .channels:
            return "Channels"
        case .member(let channel, let user):
            return try "Channels/\(channel.assertUniqueId())" +
            "/Members/\(user.assertUniqueId())"
        case .members(let channel):
            return try "Channels/\(channel.assertUniqueId())/Members"
        case .user(let user):
            return try "Users/\(user.assertUniqueId())"
        case .users:
            return "Users"
        }
    }
}
