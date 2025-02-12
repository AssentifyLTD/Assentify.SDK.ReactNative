import ObjectiveC
import UIKit
import Foundation
import AssentifySdk

@objc(NativeAssentifySdk)
class NativeAssentifySdk: RCTEventEmitter  ,AssentifySdkDelegate , SubmitDataDelegate{


    private var assentifySdk :AssentifySdk?
    private var stepDefinitions :[StepDefinitions]?
    private var configModel :ConfigModel?
    private var timeStarted :String?
    private var holdHandColor: String?;
    private var processingColor: String?;
    private var templatesByCountry: [TemplatesByCountry]?;
    private var apiKey:String?;


    @objc
    func initialize(_
                          apiKey: String,
                          tenantIdentifier: String,
                          instanceHash: String,
                          processMrz: Bool = true,
                          storeCapturedDocument: Bool = true,
                          performLivenessDocument: Bool = false,
                          performLivenessFace: Bool = false,
                          storeImageStream: Bool = true,
                          saveCapturedVideoID: Bool = true,
                          saveCapturedVideoFace: Bool = true,
                          ENV_CustomColor: String = "#f5a103",
                          enableDetect: Bool = true,
                          enableGuide: Bool = true
           
                 ) -> Void {

        if(apiKey.isEmpty || tenantIdentifier.isEmpty || instanceHash.isEmpty ){
            print("apiKey, tenantIdentifier, instanceHash a are mandatory parameters")
            return
        }
        
        self.apiKey = apiKey

        print("apiKey: \(apiKey)")
        print("tenantIdentifier: \(tenantIdentifier)")
        print("instanceHash: \(instanceHash)")
        print("processMrz: \(Bool(processMrz))")
        print("storeCapturedDocument: \(Bool(storeCapturedDocument))")
        print("performLivenessDocument: \(Bool(performLivenessDocument))")
        print("performLivenessFace: \(Bool(performLivenessFace))")
        print("storeImageStream: \(Bool(storeImageStream))")
        print("saveCapturedVideoID: \(Bool(saveCapturedVideoID))")
        print("saveCapturedVideoFace: \(Bool(saveCapturedVideoFace))")
        print("ENV_CustomColor: \(ENV_CustomColor)")
        print("enableDetect: \(enableDetect)")
        print("enableGuide: \(enableGuide)")


        let eventResultMap: [String: Any] = [
            "assentifySdkInitStart": true,
        ]
        DispatchQueue.main.async {
            self.sendEvent(withName: "AppResult",body : eventResultMap)
        }

        UserDefaults.standard.set(instanceHash, forKey:"instanceHash")
        // UserDefaults.standard.set(previewURL, forKey:"previewURL")
   
        let environmentalConditions = EnvironmentalConditions(
            enableDetect: enableDetect, enableGuide: enableGuide,
            BRIGHTNESS_HIGH_THRESHOLD: 500.0,
            BRIGHTNESS_LOW_THRESHOLD: 0.0,
            PREDICTION_LOW_PERCENTAGE: 50.0,
            PREDICTION_HIGH_PERCENTAGE: 100.0,
            CustomColor:  "#ffffff",
            HoldHandColor: ENV_CustomColor
        )

        self.holdHandColor = ENV_CustomColor;
        self.processingColor = "#ffffff";
        

        self.assentifySdk = AssentifySdk(
            apiKey: apiKey,
            tenantIdentifier: tenantIdentifier,
            interaction: instanceHash,
            environmentalConditions: environmentalConditions,
            assentifySdkDelegate: self,
            processMrz: processMrz,
            storeCapturedDocument: storeCapturedDocument,
            performLivenessDocument: performLivenessDocument,
            performLivenessFace: performLivenessFace,
            storeImageStream: storeImageStream,
            saveCapturedVideoID: saveCapturedVideoID,
            saveCapturedVideoFace: saveCapturedVideoFace
        )


    }

    func onAssentifySdkInitError(message: String) {
        DispatchQueue.main.async {
            let eventResultMap: [String: Any] = ["assentifySdkInitSuccess": false]
            self.sendEvent(withName: "AppResult",body : eventResultMap)
        }
    }

    func onAssentifySdkInitSuccess(configModel: ConfigModel) {
        UserDefaults.standard.set(nil, forKey:"FaceModel")
        UserDefaults.standard.set(nil,  forKey:"PassportModel")
        UserDefaults.standard.set(nil,  forKey:"IDModel")
        UserDefaults.standard.set(nil,  forKey:"IDBackModel")
        UserDefaults.standard.set(nil, forKey:"OtherModel")
        self.stepDefinitions = configModel.stepDefinitions;
        self.configModel = configModel;

        self.templatesByCountry =  self.assentifySdk!.getTemplates();
        do {
            let jsonData = try JSONEncoder().encode(self.templatesByCountry)
            let jsonString = String(decoding: jsonData, as: UTF8.self)
            let eventResultMap: [String: Any]  =   ["AssentifySdkHasTemplates": jsonString, "assentifySdkInitSuccess": true]
            DispatchQueue.main.async {
                self.sendEvent(withName: "AppResult",body : eventResultMap)
            }
        } catch {
        }
    }



    override func supportedEvents() -> [String]! {
        return [
            "AppResult",
            "EventResult",
            "EventError",
            "onEnvironmentalConditionsChange",
            "onUploadFailed",
            "onDocumentCropped",
            "onDocumentCaptured",
            "onQualityCheckAvailable",
            "onFaceExtracted",
            "onNoFaceDetected",
            "onFaceDetected",
            "onNoMrzDetected",
            "onMrzDetected",
            "onMrzExtracted",
            "onCardDetected",
            "onComplete",
            "onLivenessUpdate",
            "onUpdated",
            "onStatusUpdated",
            "onClipPreparationComplete",
            "onRetry",
            "onSend",
            "onError",
            "onWrongTemplate",
            "onBackClick",
            "SubmitResult"
        ]
    }


    func navigateToPassportController(language: String) {
        DispatchQueue.main.async {

            self.timeStarted =  self.getTimeUTC();
            if let currentViewController = UIViewController.currentViewController {
                let viewController = PassportController(assentifySdk: self.assentifySdk!,nativeAssentifySdk: self,holdHandColor:self.holdHandColor!,processingColor: self.processingColor!,language: language,showCountDown: true,apiKey:  self.apiKey!)
                viewController.modalPresentationStyle = .fullScreen
                currentViewController.present(viewController, animated: true, completion: nil)
            }
        }
    }


    func navigateToOtherController(language: String ) {
        DispatchQueue.main.async {
            self.timeStarted =  self.getTimeUTC();
            if let currentViewController = UIViewController.currentViewController {
                let viewController = OtherController(assentifySdk: self.assentifySdk!,nativeAssentifySdk: self,holdHandColor:self.holdHandColor!,processingColor: self.processingColor!,language: language,showCountDown: true,apiKey:   self.apiKey!)
                viewController.modalPresentationStyle = .fullScreen
                currentViewController.present(viewController, animated: true, completion: nil)
            }
        }
    }


    func navigateToIDCardController(jsonStringKycDocumentDetails: String,language: String,flippingCard:Bool) {
        if(jsonStringKycDocumentDetails.isEmpty) {
            return;
        }
        let jsonData = Data(jsonStringKycDocumentDetails.utf8)
        let kycDocumentDetails: [KycDocumentDetails] = try! JSONDecoder().decode([KycDocumentDetails].self, from: jsonData)
        DispatchQueue.main.async {
            self.timeStarted =  self.getTimeUTC();
            if let currentViewController = UIApplication.shared.keyWindow?.rootViewController {
                let viewController = IDCardController(assentifySdk: self.assentifySdk!,nativeAssentifySdk: self,holdHandColor: self.holdHandColor!,processingColor: self.processingColor!,kycDocumentDetails: kycDocumentDetails,language:language,flippingCard: flippingCard,titleID:self.getIdTitle(kycDocumentDetails:kycDocumentDetails ), showCountDown: true,apiKey:   self.apiKey!)
                              viewController.modalPresentationStyle = .fullScreen
                              currentViewController.present(viewController, animated: true, completion: nil)
                          }
        }
    }

    
    func navigateToFaceMatchontroller(imageUrl: String ,showCountDown:Bool) {
        DispatchQueue.main.async {
            let imageDocUrl = URL(string: imageUrl)
            self.imageToBase64(from: imageDocUrl!) { base64String in
                DispatchQueue.main.async {
                    if let currentViewController = UIViewController.currentViewController {
                        let viewController = FaceMAtchController(assentifySdk: self.assentifySdk!,
                                                                 nativeAssentifySdk: self,
                                                                 holdHandColor: self.holdHandColor!,
                                                                 processingColor: self.processingColor!,
                                                                 secondImage:base64String!,
                                                                 showCountDown: showCountDown
                                                                )
                        viewController.modalPresentationStyle = .fullScreen
                        currentViewController.present(viewController, animated: true, completion: nil)
                    }
                }
                
            }
            
        }
    }

    @objc
    func startScanPassport(_ language: String ) {
        /**  Nav To Passport Scan Page **/
        navigateToPassportController(language: language)
    }

    @objc
    func startScanOtherIDPage(_ language: String) {
        /**  Nav To Other Scan Page **/
        navigateToOtherController(language: language);
    }

    @objc
    func startScanIDPage(_ kycDocumentDetails: String ,language: String,flippingCard:Bool) {
        navigateToIDCardController(jsonStringKycDocumentDetails: kycDocumentDetails,language:language,flippingCard:flippingCard)
    }
    
    @objc
    func startFaceMatch(_ imageUrl: String ,showCountDown:Bool) {
        navigateToFaceMatchontroller(imageUrl: imageUrl,showCountDown:showCountDown)
    }
    
    

    @objc
    func submitData(_ data: [String: Any]) {

        DispatchQueue.main.async {
            let instanceHashValue = UserDefaults.standard.string(forKey: "instanceHash") ?? ""

            var submitRequestModel : [SubmitRequestModel] = []
            var extractedInformationWrapUp: [String: String] = [:]
            var extractedInformationBlockLoader: [String: String] = [:]






            self.stepDefinitions?.forEach({ step in
                if(step.stepDefinition == StepsName.DocumentCapture){
                    if let savedData = UserDefaults.standard.data(forKey: "OutputPropertiesDoc") {
                        if let outputProperties = try? JSONSerialization.jsonObject(with: savedData, options: []) as? [String: Any] {
                            submitRequestModel.append(SubmitRequestModel(
                                stepId: step.stepId,
                                stepDefinition:StepsName.DocumentCapture,
                                extractedInformation:self.convertAnyDictToStringDict(dict: outputProperties)
                            ))
                        }
                    }


                }
                if(step.stepDefinition == StepsName.FaceMatch){
                    if let savedData = UserDefaults.standard.data(forKey: "OutputPropertiesFace") {
                        if let outputProperties = try? JSONSerialization.jsonObject(with: savedData, options: []) as? [String: Any] {
                            submitRequestModel.append(SubmitRequestModel(
                                stepId: step.stepId,
                                stepDefinition:StepsName.FaceMatch,
                                extractedInformation:self.convertAnyDictToStringDict(dict: outputProperties)
                            ))
                        }
                    }

                }

                if(step.stepDefinition == StepsName.WrapUp){
                    step.outputProperties.forEach({ property in
                        if (property.key.contains(WrapUpKeys.TimeEnded)) {
                            extractedInformationWrapUp[property.key] = self.getTimeUTC();
                        }
                    })
                    submitRequestModel.append(SubmitRequestModel(
                        stepId: step.stepId,
                        stepDefinition:StepsName.WrapUp,
                        extractedInformation:extractedInformationWrapUp
                    ))
                }
                if(step.stepDefinition == StepsName.BlockLoader){
                    step.outputProperties.forEach({ property in
                        if (property.key.contains(BlockLoaderKeys.DeviceName)) {
                            extractedInformationBlockLoader[property.key] = "iOS";
                        }
                        if (property.key.contains(BlockLoaderKeys.FlowName)) {
                            extractedInformationBlockLoader[property.key] = self.configModel?.flowName
                        }
                        if (property.key.contains(BlockLoaderKeys.Application)) {
                            extractedInformationBlockLoader[property.key] = self.configModel?.instanceId
                        }
                        if (property.key.contains(BlockLoaderKeys.TimeStarted)) {
                            extractedInformationBlockLoader[property.key] = self.timeStarted;
                        }
                        if (property.key.contains(BlockLoaderKeys.UserAgent)) {
                            extractedInformationBlockLoader[property.key] = "SDK";
                        }
                        if (property.key.contains(BlockLoaderKeys.InstanceHash)) {
                            extractedInformationBlockLoader[property.key] =  self.configModel?.instanceHash

                        }
                        if (property.key.contains(BlockLoaderKeys.interactionID)) {
                            extractedInformationBlockLoader[property.key] = self.configModel?.instanceId
                        }
                        if !data.isEmpty {
                            for (keyData, valueData) in data {
                                if property.key.contains(keyData) {
                                    extractedInformationBlockLoader[property.key] = String(describing: valueData)
                                }
                            }
                        }
                    })

                    submitRequestModel.append(SubmitRequestModel(
                        stepId:step.stepId,
                        stepDefinition:StepsName.BlockLoader,
                        extractedInformation:extractedInformationBlockLoader
                    ))

                }

            })

            submitRequestModel.forEach { item in
                print(item.stepDefinition)
                print(item.extractedInformation)
            }

            var submitData = self.assentifySdk?.startSubmitData(submitDataDelegate: self, submitRequestModel:submitRequestModel)
        }


    }

    func onSubmitError(message: String) {
        DispatchQueue.main.async {
            let eventResultMap: [String: Any]  =   [
                "success": false,
            ]
            self.sendEvent(withName: "SubmitResult",body : eventResultMap)
        }
    }

    func onSubmitSuccess() {
        DispatchQueue.main.async {
            let eventResultMap: [String: Any]  =   [
                "success": true,
            ]
            self.sendEvent(withName: "SubmitResult",body : eventResultMap)
        }
    }


    func convertAnyDictToStringDict(dict: [String: Any]) -> [String: String] {
        var stringDict: [String: String] = [:]

        for (key, value) in dict {
            if let stringValue = value as? String {
                stringDict[key] = stringValue
            } else {
                stringDict[key] = "\(value)"
            }
        }

        return stringDict
    }


    func getTimeUTC() -> String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTime = formatter.string(from: currentDate)
        return utcTime;
    }

    func getIdTitle(kycDocumentDetails: [KycDocumentDetails]) -> String {
        var title = ""
        
        for country in self.templatesByCountry ?? [] {
            for template in country.templates {
                if !template.kycDocumentDetails.isEmpty {
                    if kycDocumentDetails[0].templateProcessingKeyInformation == template.kycDocumentDetails[0].templateProcessingKeyInformation {
                        title = template.kycDocumentType
                    }
                }
            }
        }
        
        return title
    }

    func imageToBase64(from url: URL, completion: @escaping (String?) -> Void) {
          
          var request = URLRequest(url: url)
          
          let headers = ["X-Api-Key": self.apiKey]
          
          for (headerField, headerValue) in headers {
              request.setValue(headerValue, forHTTPHeaderField: headerField)
          }
          
          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let imageData = data, error == nil else {
                  print("Failed to download image from URL: \(error?.localizedDescription ?? "Unknown error")")
                  completion(nil)
                  return
              }
              
              let base64String = imageData.base64EncodedString()
              
              completion(base64String)
          }
          
          task.resume()
      }
}

extension UIViewController {
    static var currentViewController: UIViewController? {
        var viewController = UIApplication.shared.windows.first?.rootViewController

        while let presentedViewController = viewController?.presentedViewController {
            viewController = presentedViewController
        }

        return viewController
    }
}




