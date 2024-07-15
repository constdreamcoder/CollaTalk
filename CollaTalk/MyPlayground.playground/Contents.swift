import UIKit

func join(error: Error) async throws -> String? {
    
    if let commonError = CommonError(rawValue: errorCode.errorCode) {
        throw commonError
    } else if let emailValidationError = JoinError(rawValue: errorCode.errorCode) {
        throw emailValidationError
    }
    
    return nil
}
