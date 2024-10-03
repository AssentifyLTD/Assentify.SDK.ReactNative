

import UIKit
import AVFoundation
import AssentifySdk

class FaceMAtchController: UIViewController ,FaceMatchDelegate
{



    weak var delegate: ChildViewControllerDelegate?
    private var assentifySdk:AssentifySdk?;
    private var secondImage:String = "";
    private var nativeAssentifySdk:NativeAssentifySdk?;
    private var start:Bool = false;
    var infoLabel : UILabel?;
    init(assentifySdk: AssentifySdk, nativeAssentifySdk:NativeAssentifySdk?,secondImage:String,delegate:ChildViewControllerDelegate) {
          self.assentifySdk = assentifySdk
          self.secondImage = secondImage
          self.nativeAssentifySdk = nativeAssentifySdk
          self.delegate = delegate
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
            var faceMatch =  self.assentifySdk?.startFaceMatch(faceMatchDelegate: self,secondImage:self.secondImage)
            self.addChild(faceMatch!)
            self.view.addSubview(faceMatch!.view)
            faceMatch!.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                faceMatch!.view.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 28),
                faceMatch!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                faceMatch!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                faceMatch!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
            faceMatch!.didMove(toParent: self)
            self.infoLabel = showInfo(view: self.view, text: "Position your face within\nthe center of screen", initialTextColorHex: "#f5a103")
            showNavigationBarWithBackArrow(title: "", view: self.view, target: self, action: #selector(self.backButtonTapped))

        }
    }
    @objc func backButtonTapped() {
        DispatchQueue.main.async {
            self.delegate?.dismissParentViewController()
            self.dismiss(animated: false, completion: nil)
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

    func onComplete(dataModel: FaceResponseModel) {
        print("onCompleteFace")
        print(dataModel.faceExtractedModel?.percentageMatch)
        print(dataModel.faceExtractedModel?.outputProperties)
        if let outputProperties = try? JSONSerialization.data(withJSONObject: dataModel.faceExtractedModel?.outputProperties, options: []) {
            UserDefaults.standard.set(outputProperties, forKey: "OutputPropertiesFace")
        }
        triggerCompleteEvent(eventName:"onComplete",dataModel:dataModel.faceExtractedModel)

        DispatchQueue.main.async {
            if let currentViewController = UIViewController.currentViewController {
                self.delegate?.dismissParentViewController()
                currentViewController.dismiss(animated: false, completion: nil)

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

    func onEnvironmentalConditionsChange(brightness: Double, motion: MotionType) {
        DispatchQueue.main.async {
            if(self.start){
                self.infoLabel?.text = "Processing... "
                self.infoLabel?.textColor = UIColor(named: "#f5a103")
            }else{
                self.infoLabel?.textColor = UIColor(named: "#f5a103")
                if (motion == MotionType.HOLD_YOUR_HAND) {
                    self.start = false;
                    self.infoLabel?.text = "Please Hold Your Hand"
                } else {
                    self.infoLabel?.text = "Position your face within\nthe center of screen"
                }
            }
            let eventResultMap: [String: Any] = [
                "start": self.start,
                "motion": motion,
                "brightness": brightness
            ]
            let result: [String: Any] =  ["FaceMatchDataModel": eventResultMap]
            self.nativeAssentifySdk?.sendEvent(withName: "onEnvironmentalConditionsChange", body: result)
        }
    }

    func onHasTemplates(templates: [TemplatesByCountry]){
    }

    func triggerEvent(eventName:String, dataModel: RemoteProcessingModel?){
        var eventResultMap: [String: Any] = [:]
        if(dataModel != nil){

            eventResultMap =   ["FaceMatchDataModel": dataModel?.response as Any]
        }
        DispatchQueue.main.async {
            self.nativeAssentifySdk?.sendEvent(withName: eventName, body: eventResultMap)
        }

    }

    func triggerCompleteEvent(eventName:String, dataModel: FaceExtractedModel?){
        var eventResultMap: [String: Any] = [:]
        if(dataModel != nil){

            eventResultMap =   ["FaceMatchDataModel": faceModelToJsonString(dataModel: dataModel)  as Any]
        }
        DispatchQueue.main.async {
            self.nativeAssentifySdk?.sendEvent(withName: eventName, body: eventResultMap)
        }

    }





}



