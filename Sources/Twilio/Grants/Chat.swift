import Node

public struct Chat: Grant {
    public static let name = "chat"
    public let node: Node

    public init(
        endpointID: String? = nil,
        deploymentRoleSid: String? = nil,
        pushCredentialSid: String? = nil,
        serviceSid: String? = nil
    ) {
        var object: [String: StructuredData] = [:]

        if let endpointID = endpointID {
            object["endpoint_id"] = .string(endpointID)
        }

        if let deploymentRoleSid = deploymentRoleSid {
            object["deployment_role_sid"] = .string(deploymentRoleSid)
        }

        if let pushCredentialSid = pushCredentialSid {
            object["push_credential_sid"] = .string(pushCredentialSid)
        }

        if let serviceSid = serviceSid {
            object["service_sid"] = .string(serviceSid)
        }

        node = Node(object)
    }
}
