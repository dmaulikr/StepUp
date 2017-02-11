import Foundation

public enum Result<ResourceType> {
    case success(ResourceType)
    case failure(Error)
}
