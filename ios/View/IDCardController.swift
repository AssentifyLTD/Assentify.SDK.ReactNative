

import UIKit
import AVFoundation
import AssentifySdk

class IDCardController: UIViewController ,ScanIDCardDelegate , ChildViewControllerDelegate
{
    private var imageUrl: String? = "";
    private var apiKey: String? = "";
    private var isDone:Bool = false;
    private var assentifySdk:AssentifySdk?;
    private var start:Bool = false;
    var infoLabel : UILabel?;
    var infoImage : UIImageView?;
    var popUpMessage : UIView?;
    private var holdHandColor: String;
    private var processingColor: String;
    private var language: String;
    private var flippingCard:Bool = false;
    private var showCountDown:Bool = true;
    private var _kycDocumentDetails:[KycDocumentDetails];
    private var titleID:String? = "";
    private var nativeAssentifySdk:NativeAssentifySdk?;
    private var outputResultProperties: [String: Any]? = [:];

    

    
    init(assentifySdk: AssentifySdk,nativeAssentifySdk:NativeAssentifySdk,holdHandColor: String,processingColor: String,kycDocumentDetails:[KycDocumentDetails],language:String,flippingCard:Bool,titleID:String,showCountDown:Bool,apiKey:String) {
          self.assentifySdk = assentifySdk
          self.nativeAssentifySdk = nativeAssentifySdk
          self.holdHandColor = holdHandColor
          self.processingColor = processingColor
          self._kycDocumentDetails = kycDocumentDetails
          self.language = language
          self.flippingCard = flippingCard
          self.titleID = titleID
          self.showCountDown = showCountDown
          self.apiKey = apiKey
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
            self.view.backgroundColor = .clear
            UIApplication.shared.isStatusBarHidden = false;
            DispatchQueue.main.async {
                var scanID =  self.assentifySdk?.startScanID(scanIDCardDelegate: self, kycDocumentDetails:  self._kycDocumentDetails,language:self.language)
                self.addChild(scanID!)
                self.view.addSubview(scanID!.view)
                scanID!.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    scanID!.view.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 0),
                    scanID!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    scanID!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    scanID!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                ])
                scanID!.didMove(toParent: self)
                (self.infoLabel, self.infoImage) = showInfo(view: self.view, text: "Please Present Your ID",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor,initialImageName:"info_icon")
                showNavigationBarWithBackArrow(view: self.view, target: self, action: #selector(self.backButtonTapped), initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor,title: self.titleID!)
            }
        }
        @objc func backButtonTapped() {
         triggerEvent(eventName:"onBackClick",dataModel:nil)
                DispatchQueue.main.async {
                self.dismiss(animated: false)
            }
        }
        
        func dismissParentViewController() {
            triggerEvent(eventName:"onBackClick",dataModel:nil)
                   DispatchQueue.main.async {
                self.dismiss(animated: false)
            }
         
        }
        
        @objc func dismissPopUpMessage() {
            DispatchQueue.main.async {
                if(!self.start){
                    self.popUpMessage!.removeFromSuperview();
                    (self.infoLabel, self.infoImage) = showInfo(view: self.view, text: "Please Present Your ID",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor,initialImageName:"info_icon")
                }
            }
         
        }
        
        func onSend() {
            triggerEvent(eventName:"onSend",dataModel:nil)
            DispatchQueue.main.async {
                if(self.popUpMessage != nil){
                    self.popUpMessage!.removeFromSuperview();
                }
                self.start = true;
                self.popUpMessage =  showPopUpMessage(view: self.view, title: "Transmitting", subTitle: "",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "id", isGif: true,target: self, action: #selector(self.dismissPopUpMessage))
            }
        }
        
        func onError(dataModel: RemoteProcessingModel) {
            triggerEvent(eventName:"onError",dataModel:dataModel)
            DispatchQueue.main.async {
                self.start = false;
                self.popUpMessage!.removeFromSuperview();
                self.popUpMessage =  showPopUpMessage(view: self.view, title: "Unable to extract", subTitle: "Let's try again",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "warning", isGif: false,target: self, action: #selector(self.dismissPopUpMessage))
            }
        }
        
        
        func onRetry(dataModel: RemoteProcessingModel) {
            triggerEvent(eventName:"onRetry",dataModel:dataModel)
            DispatchQueue.main.async {
                self.start = false;
                self.popUpMessage!.removeFromSuperview();
                self.popUpMessage =  showPopUpMessage(view: self.view, title: "Unable to extract", subTitle: "Let's try again",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "warning", isGif: false,target: self, action: #selector(self.dismissPopUpMessage))
            }
        }
        
        func onLivenessUpdate(dataModel: RemoteProcessingModel) {
            triggerEvent(eventName:"onLivenessUpdate",dataModel:dataModel)
            DispatchQueue.main.async {
                self.start = false;
                self.popUpMessage!.removeFromSuperview();
                self.popUpMessage =  showPopUpMessage(view: self.view, title: "Failed ID Check", subTitle: "Please real ID (Not copy)",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "id_warning", isGif: false,target: self, action: #selector(self.dismissPopUpMessage))
            }
        }
        
        func onWrongTemplate(dataModel:RemoteProcessingModel) {
            triggerEvent(eventName:"onWrongTemplate",dataModel:dataModel)
            DispatchQueue.main.async {
                self.start = false;
                self.popUpMessage!.removeFromSuperview();
                self.popUpMessage =  showPopUpMessage(view: self.view, title: "Wrong Template", subTitle: "Let's try again",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "id_warning", isGif: false,target: self, action: #selector(self.dismissPopUpMessage))
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



    func onComplete(dataModel: IDResponseModel, order: Int) {

        self.triggerCompleteEvent(eventName:"onComplete",dataModel: dataModel.iDExtractedModel)

        outputResultProperties!.merge((dataModel.iDExtractedModel?.transformedProperties)!) { (_, new) in new }
        
        self.start = false
        DispatchQueue.main.async {
             self.popUpMessage!.removeFromSuperview();
             (self.infoLabel, self.infoImage) = showInfo(view: self.view, text: "Please Present Your ID",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor,initialImageName:"info_icon")
       
            if(self._kycDocumentDetails.count == 1){
                self.imageUrl = dataModel.iDExtractedModel?.imageUrl;
            }
            
             if(order ==  self._kycDocumentDetails.count-1 ){

                 if let outputProperties = try? JSONSerialization.data(withJSONObject: self.outputResultProperties, options: []) {
                     UserDefaults.standard.set(outputProperties, forKey: "OutputPropertiesDoc")
                 }
                 DispatchQueue.main.async {
                 self.dismiss(animated: false)
             }
    
                 
             }else{
                 if(self.flippingCard){
                     let  flippingCardUI =  showFlippingCard(view: self.view);
                     DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                         flippingCardUI.removeFromSuperview();
                     }
                 }
                 if(order == 0){
                     self.imageUrl = dataModel.iDExtractedModel?.imageUrl;
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
                       if(self.start == false){
                           if (zoom != ZoomType.SENDING && zoom != ZoomType.NO_DETECT) {
                               if (zoom == ZoomType.ZOOM_IN) {
                                         self.start = false;
                                         self.infoLabel?.text = "Move ID Closer"
                                        self.infoImage!.image = UIImage(named: "zoom_in")
                                     }
                               if (zoom == ZoomType.ZOOM_OUT) {
                                   self.start = false;
                                   self.infoLabel?.text = "Move ID Further"
                                   self.infoImage!.image = UIImage(named: "zoom_out")
                                     }
                                 } else if (motion == MotionType.HOLD_YOUR_HAND) {
                                     self.start = false;
                                     self.infoLabel?.text = "Please Hold Your Hand"
                                     self.infoImage!.image = UIImage(named: "info_icon")
                                 } else {
                                     if (motion == MotionType.SENDING && zoom == ZoomType.SENDING){
                                         self.start = false;
                                         self.infoLabel?.text = "Hold Steady"
                                         self.infoImage!.image = UIImage(named: "info_icon")
                                     }
                                     if (motion == MotionType.NO_DETECT && zoom == ZoomType.NO_DETECT){
                                         self.start = false;
                                         self.infoLabel?.text = "Please Present Your ID"
                                         self.infoImage!.image = UIImage(named: "info_icon")
                                     }

                                 }
                             }else {
                                 self.infoLabel?.removeFromSuperview()
                                 self.infoImage?.removeFromSuperview()
                             }
                
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


