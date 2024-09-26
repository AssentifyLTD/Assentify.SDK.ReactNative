import UIKit
import AssentifySdk

class PassportScannerView: UIView, ScanPassportDelegate {

  private var assentifySdk:AssentifySdk?;
  private var start:Bool = false;

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  private func setupView() {
    var scanPassport =  self.assentifySdk?.startScanPassport(scanPassportDelegate: self)
      self.addSubview(scanPassport!.view)
      scanPassport!.view.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          scanPassport!.view.topAnchor.constraint(equalTo: self.topAnchor,constant: 28),
          scanPassport!.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
          scanPassport!.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
          scanPassport!.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      ])
  }

    private func formatResponseCallback(dataModel: RemoteProcessingModel) -> [AnyHashable: Any]{
        var event = [AnyHashable: Any]()
        event = [
          "response": dataModel.response as Any,
          "error": dataModel.error as Any,
          "success": dataModel.success as Any
        ]
        return event;
    }


    @objc var onSendCallback: RCTBubblingEventBlock?
    func onSend() {
      if onSendCallback == nil {
        return
      }
      let event = [AnyHashable: Any]()
      onSendCallback!(event)
    }

    @objc var onErrorCallback: RCTBubblingEventBlock?
    func onError(dataModel: RemoteProcessingModel) {
        if onErrorCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onErrorCallback!(event)
    }

    @objc var onRetryCallback: RCTBubblingEventBlock?
    func onRetry(dataModel: RemoteProcessingModel) {
        if onRetryCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onRetryCallback!(event)
    }

    @objc var onClipPreparationCompleteCallback: RCTBubblingEventBlock?
    func onClipPreparationComplete(dataModel: RemoteProcessingModel) {
        if onClipPreparationCompleteCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onClipPreparationCompleteCallback!(event)
    }

    @objc var onStatusUpdatedCallback: RCTBubblingEventBlock?
    func onStatusUpdated(dataModel: RemoteProcessingModel) {
        if onStatusUpdatedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onStatusUpdatedCallback!(event)
    }

    @objc var onUpdatedCallback: RCTBubblingEventBlock?
    func onUpdated(dataModel: RemoteProcessingModel) {
        if onUpdatedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onUpdatedCallback!(event)
    }

    @objc var onLivenessUpdateCallback: RCTBubblingEventBlock?
    func onLivenessUpdate(dataModel: RemoteProcessingModel) {
        if onLivenessUpdateCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onLivenessUpdateCallback!(event)
    }

    @objc var onCompleteCallback: RCTBubblingEventBlock?
    func onComplete(dataModel: PassportResponseModel) {
        if onCompleteCallback == nil {
          return
        }
        var event = [AnyHashable: Any]()
        event = [
          "passportExtractedModel": dataModel.passportExtractedModel as Any,
          "destinationEndpoint": dataModel.destinationEndpoint as Any,
          "error": dataModel.error as Any,
          "success": dataModel.success as Any
        ]
        onCompleteCallback!(event)
    }

    @objc var onCardDetectedCallback: RCTBubblingEventBlock?
    func onCardDetected(dataModel: RemoteProcessingModel) {
        if onCardDetectedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onCardDetectedCallback!(event)
    }

    @objc var onMrzExtractedCallback: RCTBubblingEventBlock?
    func onMrzExtracted(dataModel: RemoteProcessingModel) {
        if onMrzExtractedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onMrzExtractedCallback!(event)
    }

    @objc var onMrzDetectedCallback: RCTBubblingEventBlock?
    func onMrzDetected(dataModel: RemoteProcessingModel) {
        if onMrzDetectedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onMrzDetectedCallback!(event)
    }

    @objc var onNoMrzDetectedCallback: RCTBubblingEventBlock?
    func onNoMrzDetected(dataModel: RemoteProcessingModel) {
        if onNoMrzDetectedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onNoMrzDetectedCallback!(event)
    }

    @objc var onFaceDetectedCallback: RCTBubblingEventBlock?
    func onFaceDetected(dataModel: RemoteProcessingModel) {
        if onFaceDetectedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onFaceDetectedCallback!(event)
    }

    @objc var onNoFaceDetectedCallback: RCTBubblingEventBlock?
    func onNoFaceDetected(dataModel: RemoteProcessingModel) {
        if onNoFaceDetectedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onNoFaceDetectedCallback!(event)
    }

    @objc var onFaceExtractedCallback: RCTBubblingEventBlock?
    func onFaceExtracted(dataModel: RemoteProcessingModel) {
        if onFaceExtractedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onFaceExtractedCallback!(event)
    }

    @objc var onQualityCheckAvailableCallback: RCTBubblingEventBlock?
    func onQualityCheckAvailable(dataModel: RemoteProcessingModel) {
        if onQualityCheckAvailableCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onQualityCheckAvailableCallback!(event)
    }

    @objc var onDocumentCapturedCallback: RCTBubblingEventBlock?
    func onDocumentCaptured(dataModel: RemoteProcessingModel) {
        if onDocumentCapturedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onDocumentCapturedCallback!(event)
    }

    @objc var onDocumentCroppedCallback: RCTBubblingEventBlock?
    func onDocumentCropped(dataModel: RemoteProcessingModel) {
        if onDocumentCroppedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onDocumentCroppedCallback!(event)
    }

    @objc var onUploadFailedCallback: RCTBubblingEventBlock?
    func onUploadFailed(dataModel: RemoteProcessingModel) {
        if onUploadFailedCallback == nil {
          return
        }
        var event = formatResponseCallback(dataModel: dataModel)
        onUploadFailedCallback!(event)
    }

    @objc var onEnvironmentalConditionsChangeCallback: RCTBubblingEventBlock?
    func onEnvironmentalConditionsChange(brightness: Double, motion: MotionType, zoom: ZoomType) {
        if onEnvironmentalConditionsChangeCallback == nil {
          return
        }
        var event = [AnyHashable: Any]()
        event = [
          "brightness": brightness,
          "motion": motion,
          "zoom": zoom
        ]
        onEnvironmentalConditionsChangeCallback!(event)
    }

}

@objc (RNPassportScanner)
class RNPassportScanner: RCTViewManager {

  override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  override func view() -> UIView! {
    return PassportScannerView()
  }
}
