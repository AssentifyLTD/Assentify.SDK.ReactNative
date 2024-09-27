

import UIKit
import AVFoundation
import AssentifySdk

class IDCardController: UIViewController ,ScanIDCardDelegate , ChildViewControllerDelegate
{
    private var isDone:Bool = false;
    private var assentifySdk:AssentifySdk?;
    private var nativeAssentifySdk:NativeAssentifySdk?;
    private var dataFrontModel: IDExtractedModel? = nil;
    private var _kycDocumentDetails:[KycDocumentDetails];
    private var start:Bool = false;
    var infoLabel : UILabel?;

    init(assentifySdk: AssentifySdk,kycDocumentDetails:[KycDocumentDetails],nativeAssentifySdk:NativeAssentifySdk) {
        self.assentifySdk = assentifySdk
        self.nativeAssentifySdk = nativeAssentifySdk
        self._kycDocumentDetails = kycDocumentDetails
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
            var scanID =  self.assentifySdk?.startScanID(scanIDCardDelegate: self, kycDocumentDetails: self._kycDocumentDetails)
            self.addChild(scanID!)
            self.view.addSubview(scanID!.view)
            scanID!.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scanID!.view.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 28),
                scanID!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                scanID!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                scanID!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
            scanID!.didMove(toParent: self)
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
        print("onRetry: \(dataModel)")
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


    func onWrongTemplate(dataModel: RemoteProcessingModel) {
        print("IDCard onWrongTemplate: \(String(describing: dataModel.response))")
        triggerEvent(eventName:"onWrongTemplate",dataModel:dataModel)
        self.isDone = true;
        self.start = false;

        DispatchQueue.main.async {
            if let currentViewController = UIViewController.currentViewController {
                self.dismissParentViewController()
                currentViewController.dismiss(animated: false, completion: nil)
            }
        }
    }


    func onComplete(dataModel: IDResponseModel, order: Int) {

        print("onComplete" , order)
        DispatchQueue.main.async {
                if(self._kycDocumentDetails.count >= 1){
                    if(order == 1){
                        self.triggerCompleteEvent(eventName:"onComplete",dataModel: self.dataFrontModel)
                        var outputResultProperties = self.dataFrontModel?.outputProperties;
                        outputResultProperties!.merge((dataModel.iDExtractedModel?.outputProperties)!) { (_, new) in new }

                        if let outputProperties = try? JSONSerialization.data(withJSONObject: outputResultProperties, options: []) {
                            UserDefaults.standard.set(outputProperties, forKey: "OutputPropertiesDoc")
                        }
                        if let imageUrlString =  self.dataFrontModel?.imageUrl,
                           let imageUrl = URL(string: imageUrlString) {
                            if let base64String = self.imageToBase64(from:imageUrl  ) {
                                if let currentViewController = UIViewController.currentViewController {
                                    let viewController = FaceMAtchController(assentifySdk: self.assentifySdk!,
                                                                             nativeAssentifySdk: self.nativeAssentifySdk,
                                                                             secondImage:base64String, delegate: self)
                                    viewController.modalPresentationStyle = .fullScreen
                                    currentViewController.present(viewController, animated: true, completion: nil)
                                }
                            }
                        }
                    }else{
                        //self.dataFrontModel = dataModel.iDExtractedModel
                        // self.triggerCompleteEvent(eventName:"onComplete",dataModel:dataModel.iDExtractedModel)
                        self.dataFrontModel = dataModel.iDExtractedModel;
                        self.playVideoInView(videoName: "id_card_rotation", ofType: "mp4", in: self.view, fullscreen: true)
                        self.infoLabel?.text = "Please Present Your ID"
                        self.start = false;
                    }

                }else{
                    self.triggerCompleteEvent(eventName:"onComplete",dataModel:dataModel.iDExtractedModel)

                    if let outputProperties = try? JSONSerialization.data(withJSONObject: dataModel.iDExtractedModel?.outputProperties, options: []) {
                        UserDefaults.standard.set(outputProperties, forKey: "OutputPropertiesFace")
                    }
                    if let imageUrlString =  dataModel.iDExtractedModel?.imageUrl,
                       let imageUrl = URL(string: imageUrlString) {
                        if let base64String = self.imageToBase64(from:imageUrl  ) {
                            if let currentViewController = UIViewController.currentViewController {
                                let viewController = FaceMAtchController(assentifySdk: self.assentifySdk!,
                                                                         nativeAssentifySdk: self.nativeAssentifySdk,
                                                                         secondImage:base64String, delegate: self)
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
            let eventResultMap: [String: Any] = [
                "start": self.start,
                "zoomType": zoom,
                "motion": motion,
                "brightness": brightness
            ]
            let result: [String: Any] =  ["IdDataModel": eventResultMap]
            self.nativeAssentifySdk?.sendEvent(withName: "onEnvironmentalConditionsChange", body: result)
        }

    }

    func triggerCompleteEvent(eventName:String, dataModel: IDExtractedModel?){
        var eventResultMap: [String: Any] = [:]
        if(dataModel != nil){
            eventResultMap =   ["IdDataModel": iDModelToJsonString(dataModel:dataModel) as Any]
        }
        print("IdDataModel")
        print(iDModelToJsonString(dataModel:dataModel))
        DispatchQueue.main.async {
            self.nativeAssentifySdk?.sendEvent(withName: eventName, body: eventResultMap)
        }

    }

    func triggerEvent(eventName:String, dataModel: RemoteProcessingModel?){
        var eventResultMap: [String: Any] = [:]
        if(dataModel != nil){
            eventResultMap =   ["IdDataModel": dataModel?.response as Any]
        }
        DispatchQueue.main.async {
            self.nativeAssentifySdk?.sendEvent(withName: eventName, body: eventResultMap)
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



    func onHasTemplates(templates: [TemplatesByCountry]){
    }





    func playVideoInView(videoName: String, ofType fileType: String, in view: UIView, fullscreen: Bool) {
        guard let path = Bundle.main.path(forResource: videoName, ofType: fileType) else {
            print("Video file not found")
            return
        }

        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)

        var videoViewFrame = view.bounds

        if fullscreen {
            // For fullscreen mode, adjust the frame to cover the entire screen
            videoViewFrame = UIScreen.main.bounds
        }

        // Create a background view with white color
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)

        let videoView = UIView(frame: videoViewFrame)
        view.addSubview(videoView)

        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)

        player.play()

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { _ in
            player.pause()
            videoView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }





}



