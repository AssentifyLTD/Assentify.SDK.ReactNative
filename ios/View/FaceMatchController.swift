

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
    var infoImage : UIImageView?;
    var popUpMessage : UIView?;
    private var holdHandColor: String;
    private var processingColor: String;
    private var showCountDown: Bool = true;
    
    init(assentifySdk: AssentifySdk, nativeAssentifySdk:NativeAssentifySdk?,holdHandColor: String,processingColor: String,secondImage:String,showCountDown:Bool,delegate:ChildViewControllerDelegate) {
              self.assentifySdk = assentifySdk
              self.holdHandColor = holdHandColor
              self.processingColor = processingColor
        self.secondImage = secondImage
        self.nativeAssentifySdk = nativeAssentifySdk
        self.delegate = delegate
              self.showCountDown = showCountDown
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
              var faceMatch =  self.assentifySdk?.startFaceMatch(faceMatchDelegate: self, secondImage: self.secondImage,showCountDown:self.showCountDown)
              self.addChild(faceMatch!)
              self.view.addSubview(faceMatch!.view)
              faceMatch!.view.translatesAutoresizingMaskIntoConstraints = false
              NSLayoutConstraint.activate([
                  faceMatch!.view.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 0),
                  faceMatch!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                  faceMatch!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                  faceMatch!.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
              ])
              faceMatch!.didMove(toParent: self)
              (self.infoLabel, self.infoImage) = showInfo(view: self.view, text: "Please face within circle",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor,initialImageName:"info_icon")
              showNavigationBarWithBackArrow(view: self.view, target: self, action: #selector(self.backButtonTapped), initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor,title: "Face Capture")
              faceMatch?.startScanning();
           

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
                  (self.infoLabel, self.infoImage) = showInfo(view: self.view, text: "Please face within circle",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor,initialImageName:"info_icon")
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
              self.popUpMessage =  showPopUpMessage(view: self.view, title: "Transmitting", subTitle: "",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "sending", isGif: false,target: self, action: #selector(self.dismissPopUpMessage))
          }
      }
      
      func onError(dataModel: RemoteProcessingModel) {
          triggerEvent(eventName:"onError",dataModel:dataModel)
          DispatchQueue.main.async {
              self.start = false;
              self.popUpMessage!.removeFromSuperview();
              self.popUpMessage =  showPopUpMessage(view: self.view, title: "Unable to Match", subTitle: "Let's try again",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "warning", isGif: false,target: self, action: #selector(self.dismissPopUpMessage))
          }
      }
      
      
      func onRetry(dataModel: RemoteProcessingModel) {
          triggerEvent(eventName:"onRetry",dataModel:dataModel)
          DispatchQueue.main.async {
              self.start = false;
              self.popUpMessage!.removeFromSuperview();
              self.popUpMessage =  showPopUpMessage(view: self.view, title: "Unable to Match", subTitle: "Let's try again",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "warning", isGif: false,target: self, action: #selector(self.dismissPopUpMessage))
          }
      }
      
      func onLivenessUpdate(dataModel: RemoteProcessingModel) {
          triggerEvent(eventName:"onLivenessUpdate",dataModel:dataModel)
          DispatchQueue.main.async {
              self.start = false;
              self.popUpMessage!.removeFromSuperview();
              self.popUpMessage =  showPopUpMessage(view: self.view, title: "Liveness Failed", subTitle: "Let's try again",initialTextColorHex:self.processingColor,initialBackgroundColorHex:self.holdHandColor, iconName: "warning", isGif: false,target: self, action: #selector(self.dismissPopUpMessage))
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

   

    func onComplete(dataModel: FaceResponseModel) {

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
              if (self.start == false) {
                            if (motion == MotionType.HOLD_YOUR_HAND) {
                                self.infoLabel?.text = "Please Hold Your Hand"
                                self.infoImage!.image = UIImage(named: "info_icon")
                            } else {
                                if (motion == MotionType.SENDING) {
                                    self.infoLabel?.text = "Hold Steady"
                                    self.infoImage!.image = UIImage(named: "info_icon")
                                }
                                if (motion == MotionType.NO_DETECT) {
                                    self.infoLabel?.text = "Please face within circle"
                                    self.infoImage!.image = UIImage(named: "info_icon")
                                }

                            }
                        }else{
                            self.infoLabel?.removeFromSuperview()
                            self.infoImage?.removeFromSuperview()
                        }
      
              
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



