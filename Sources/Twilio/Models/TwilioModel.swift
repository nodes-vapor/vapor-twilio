public protocol TwilioModel {
    var sid: String? { get }
    var uniqueId: String? { get }
}

extension TwilioModel {
    func assertUniqueId() throws -> String {
        guard let uniqueId = self.uniqueId else {
            throw TwilioError.uniqueIdNotSet
        }
        return uniqueId
    }
}
