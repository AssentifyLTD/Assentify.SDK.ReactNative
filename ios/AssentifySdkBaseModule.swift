import ObjectiveC
import UIKit
import Foundation

@objc(AssentifySdkBaseModule)
class AssentifySdkBaseModule: RCTEventEmitter {

  override func supportedEvents() -> [String]! {
    return ["AssentifySdkInitError"]
  }

  @objc func emitSdkInitError(_ errorMessage: String) {
    sendEvent(withName: "AssentifySdkInitError", body: ["error": errorMessage])
  }
}
