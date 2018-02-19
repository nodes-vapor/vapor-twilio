public enum TwilioError: Error {
    /// Usually this means an entity with a given unique identifier
    /// already exists.
    case conflict

    case notFound
    case unexpectedResponseFromTwilio
    case uniqueIdNotSet
}
