

import UIKit
import AVFoundation
import AssentifySdk

class OtherController: UIViewController ,ScanOtherDelegate , ChildViewControllerDelegate
{

    private var isDone:Bool = false;
    private var assentifySdk:AssentifySdk?;
    private var baseAssentifySdk:BaseAssentifySdk?;
    private var start:Bool = false;
    var infoLabel : UILabel?;
    init(assentifySdk: AssentifySdk,baseAssentifySdk:BaseAssentifySdk) {
          self.assentifySdk = assentifySdk
          self.baseAssentifySdk = baseAssentifySdk
          super.init(nibName: nil, bundle: nil)
      }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "#f5a103")
        UIApplication.shared.isStatusBarHidden = false;
        DispatchQueue.main.async {
            var scanOther =  self.assentifySdk?.startScanOthers(scanOtherDelegate: self)
            self.addChild(scanOther!)
            self.view.addSubview(scanOther!.view)
            scanOther!.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scanOther!.view.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 28),
                scanOther!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                scanOther!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                scanOther!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
            scanOther!.didMove(toParent: self)
            self.infoLabel = showInfo(view: self.view, text: "Please Present Your ID", initialTextColorHex: "#f5a103")
            showNavigationBarWithBackArrow(title: "", view: self.view, target: self, action: #selector(self.backButtonTapped))

        }
    }
    @objc func backButtonTapped() {
        DispatchQueue.main.async {
            self.dismiss(animated: false)
        }
    }

    func dismissParentViewController() {
        DispatchQueue.main.async {
            self.dismiss(animated: false)
        }

    }
    func onError(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onError",dataModel:dataModel)
        DispatchQueue.main.async {
            self.start = false;
        }
    }

    func onSend() {
        triggerEvent(eventName:"onSend",dataModel:nil)
        DispatchQueue.main.async {
                self.start = true;
        }

    }

    func onRetry(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onRetry",dataModel:dataModel)
        DispatchQueue.main.async {
            self.start = false;
        }
    }

    func onClipPreparationComplete(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onClipPreparationComplete",dataModel:dataModel)
    }

    func onStatusUpdated(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onStatusUpdated",dataModel:dataModel)
    }

    func onUpdated(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onUpdated",dataModel:dataModel)
    }

    func onLivenessUpdate(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onLivenessUpdate",dataModel:dataModel)
    }

    func onComplete(dataModel: OtherResponseModel) {
        if(!isDone){
            isDone = true;
            if let outputProperties = try? JSONSerialization.data(withJSONObject: dataModel.otherExtractedModel?.outputProperties, options: []) {
                UserDefaults.standard.set(outputProperties, forKey: "OutputPropertiesDoc")
            }
            triggerCompleteEvent(eventName:"onComplete",dataModel:dataModel.otherExtractedModel)

            if let imageUrlString = dataModel.otherExtractedModel?.imageUrl,
               let imageUrl = URL(string: imageUrlString) {

                if let base64String = self.imageToBase64(from:imageUrl  ) {

                    DispatchQueue.main.async {
                        if let currentViewController = UIViewController.currentViewController {
                            let viewController = FaceMAtchController(assentifySdk: self.assentifySdk!,
                                                                     baseAssentifySdk: self.baseAssentifySdk,
                                                                     secondImage:base64String,delegate: self)
                            viewController.modalPresentationStyle = .fullScreen
                            currentViewController.present(viewController, animated: true, completion: nil)
                        }
                    }

                }
            }
        }


    }

    func onCardDetected(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onCardDetected",dataModel:dataModel)
    }

    func onMrzExtracted(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onMrzExtracted",dataModel:dataModel)
    }

    func onMrzDetected(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onMrzDetected",dataModel:dataModel)
    }

    func onNoMrzDetected(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onNoMrzDetected",dataModel:dataModel)
    }


    func onFaceDetected(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onFaceDetected",dataModel:dataModel)
    }

    func onNoFaceDetected(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onNoFaceDetected",dataModel:dataModel)
    }

    func onFaceExtracted(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onFaceExtracted",dataModel:dataModel)
    }

    func onQualityCheckAvailable(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onQualityCheckAvailable",dataModel:dataModel)
    }

    func onDocumentCaptured(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onDocumentCaptured",dataModel:dataModel)
    }

    func onDocumentCropped(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onDocumentCropped",dataModel:dataModel)
    }

    func onUploadFailed(dataModel: RemoteProcessingModel) {
        triggerEvent(eventName:"onUploadFailed",dataModel:dataModel)
    }

    func onEnvironmentalConditionsChange(brightness: Double, motion: MotionType, zoom: ZoomType) {
        DispatchQueue.main.async {
            if(self.start){
                self.infoLabel?.text = "Processing... "
                self.infoLabel?.textColor = UIColor(named: "#f5a103")
            }else{
                self.infoLabel?.textColor = UIColor(named: "#f5a103")
                if (zoom != ZoomType.SENDING) {
                    if (zoom == ZoomType.ZOOM_IN) {
                        self.start = false;
                        self.infoLabel?.text = "Please Move The ID\nCloser To The Camera"
                    }
                    if (zoom == ZoomType.ZOOM_OUT) {
                        self.start = false;
                        self.infoLabel?.text = "Please Move The ID\nAway From The Camera"
                    }
                } else if (motion == MotionType.HOLD_YOUR_HAND) {
                    self.start = false;
                    self.infoLabel?.text = "Please Hold Your Hand"
                } else {
                    self.infoLabel?.text = "Please Present Your ID"
                }
            }
            var eventResultMap: [String: Any] = [
                "start": self.start,
                "zoomType": zoom,
                "motion": motion,
                "brightness": brightness
            ]
            var result: [String: Any] =  ["OtherDataModel": eventResultMap]
            self.baseAssentifySdk?.sendEvent(withName: "onEnvironmentalConditionsChange", body: result)
        }

    }




    func triggerCompleteEvent(eventName:String, dataModel: OtherExtractedModel?){
        var eventResultMap: [String: Any] = [:]
        if(dataModel != nil){
            eventResultMap =   [
                "OtherDataModel":  otherModelToJsonString(dataModel: dataModel) as Any
            ]
        }
        DispatchQueue.main.async {
            self.baseAssentifySdk?.sendEvent(withName: eventName, body: eventResultMap)
        }

    }

    func triggerEvent(eventName:String, dataModel: RemoteProcessingModel?){
        var eventResultMap: [String: Any] = [:]
        if(dataModel != nil){
            eventResultMap =   [
                "OtherDataModel": dataModel?.response as Any
            ]
        }
        DispatchQueue.main.async {
            self.baseAssentifySdk?.sendEvent(withName: eventName, body: eventResultMap)
        }

    }

    func imageToBase64(from url: URL) -> String? {
          guard let imageData = try? Data(contentsOf: url) else {
              print("Failed to download image from URL")
              return nil
          }

          // Convert image data to base64
          let base64String = imageData.base64EncodedString()

          return base64String
      }


}



