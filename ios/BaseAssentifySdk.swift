import ObjectiveC
import UIKit
import Foundation
import AssentifySdk

@objc(BaseAssentifySdk)
class BaseAssentifySdk: RCTEventEmitter  ,AssentifySdkDelegate , SubmitDataDelegate{


    private var assentifySdk :AssentifySdk?
    private var stepDefinitions :[StepDefinitions]?
    private var configModel :ConfigModel?
    private var timeStarted :String?



    @objc
    func initialize(_ apiKey: String,
                          tenantIdentifier: String,
                          instanceHash: String,
                          processMrz: Bool = true,
                          storeCapturedDocument: Bool = true,
                          performLivenessDetection: Bool = false,
                          storeImageStream: Bool = true,
                          saveCapturedVideoID: Bool = true,
                          saveCapturedVideoFace: Bool = true,
                          ENV_BRIGHTNESS_HIGH_THRESHOLD: Float = 500.0,
                          ENV_BRIGHTNESS_LOW_THRESHOLD: Float = 0.0,
                          ENV_PREDICTION_LOW_PERCENTAGE: Float = 50.0,
                          ENV_PREDICTION_HIGH_PERCENTAGE: Float = 100.0,
                          ENV_CustomColor: String = "#f5a103",
                          ENV_HoldHandColor: String = "#f5a103") -> Void {

        if(apiKey.isEmpty || tenantIdentifier.isEmpty || instanceHash.isEmpty ){
            print("apiKey, tenantIdentifier, instanceHash a are mandatory parameters")
            return
        }

        print("apiKey: \(apiKey)")
        print("tenantIdentifier: \(tenantIdentifier)")
        print("instanceHash: \(instanceHash)")
        print("processMrz: \(Bool(processMrz))")
        print("storeCapturedDocument: \(Bool(storeCapturedDocument))")
        print("performLivenessDetection: \(Bool(performLivenessDetection))")
        print("storeImageStream: \(Bool(storeImageStream))")
        print("saveCapturedVideoID: \(Bool(saveCapturedVideoID))")
        print("saveCapturedVideoFace: \(Bool(saveCapturedVideoFace))")
        print("ENV_BRIGHTNESS_HIGH_THRESHOLD: \(Float(ENV_BRIGHTNESS_HIGH_THRESHOLD))")
        print("ENV_BRIGHTNESS_LOW_THRESHOLD: \(Float(ENV_BRIGHTNESS_LOW_THRESHOLD))")
        print("ENV_PREDICTION_LOW_PERCENTAGE: \(Float(ENV_PREDICTION_LOW_PERCENTAGE))")
        print("ENV_PREDICTION_HIGH_PERCENTAGE: \(Float(ENV_PREDICTION_HIGH_PERCENTAGE))")
        print("ENV_CustomColor: \(ENV_CustomColor)")
        print("ENV_HoldHandColor: \(ENV_HoldHandColor)")


        let eventResultMap: [String: Any] = [
            "assentifySdkInitStart": true,
        ]
        DispatchQueue.main.async {
            self.sendEvent(withName: "AppResult",body : eventResultMap)
        }

        UserDefaults.standard.set(instanceHash, forKey:"instanceHash")
        // UserDefaults.standard.set(previewURL, forKey:"previewURL")

        let environmentalConditions = EnvironmentalConditions(
            enableDetect: true, enableGuide: true,
            BRIGHTNESS_HIGH_THRESHOLD: ENV_BRIGHTNESS_HIGH_THRESHOLD,
            BRIGHTNESS_LOW_THRESHOLD: ENV_BRIGHTNESS_LOW_THRESHOLD,
            PREDICTION_LOW_PERCENTAGE: ENV_PREDICTION_LOW_PERCENTAGE,
            PREDICTION_HIGH_PERCENTAGE: ENV_PREDICTION_HIGH_PERCENTAGE,
            CustomColor: ENV_CustomColor,
            HoldHandColor: ENV_HoldHandColor
        )


        self.assentifySdk = AssentifySdk(
            apiKey: apiKey,
            tenantIdentifier: tenantIdentifier,
            interaction: instanceHash,
            environmentalConditions: environmentalConditions,
            assentifySdkDelegate: self,
            processMrz: processMrz,
            storeCapturedDocument: storeCapturedDocument,
            performLivenessDetection: performLivenessDetection,
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
//        let eventResultMap: [String: Any] = ["assentifySdkInitSuccess": true]
//        DispatchQueue.main.async {
//            self.sendEvent(withName: "AppResult",body : eventResultMap)
//        }
        self.assentifySdk!.getTemplates();
        // navigateToViewController()
    }

    func onHasTemplates(templates: [TemplatesByCountry]) {
        do {
            let jsonData = try JSONEncoder().encode(templates)
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
            "onWrongTemplate"
        ]
    }


    func navigateToPassportController() {
        DispatchQueue.main.async {

            self.timeStarted =  self.getTimeUTC();
            if let currentViewController = UIViewController.currentViewController {
                let viewController = PassportController(assentifySdk: self.assentifySdk!,baseAssentifySdk: self)
                viewController.modalPresentationStyle = .fullScreen
                currentViewController.present(viewController, animated: true, completion: nil)
            }
        }
    }


    func navigateToOtherController() {
        DispatchQueue.main.async {
            self.timeStarted =  self.getTimeUTC();
            if let currentViewController = UIViewController.currentViewController {
                let viewController = OtherController(assentifySdk: self.assentifySdk!,baseAssentifySdk: self)
                viewController.modalPresentationStyle = .fullScreen
                currentViewController.present(viewController, animated: true, completion: nil)
            }
        }
    }


    func navigateToIDCardController(jsonStringKycDocumentDetails: String) {
        if(jsonStringKycDocumentDetails.isEmpty) {
            return;
        }
        let jsonData = Data(jsonStringKycDocumentDetails.utf8)
        let kycDocumentDetails: [KycDocumentDetails] = try! JSONDecoder().decode([KycDocumentDetails].self, from: jsonData)
        DispatchQueue.main.async {
            self.timeStarted =  self.getTimeUTC();
             if let currentViewController = UIViewController.currentViewController {
                 let viewController = IDCardController(
                     assentifySdk: self.assentifySdk!,
                     kycDocumentDetails:kycDocumentDetails as Any as! [KycDocumentDetails],

                     baseAssentifySdk: self)
                 viewController.modalPresentationStyle = .fullScreen
                 currentViewController.present(viewController, animated: true, completion: nil)
             }
        }
    }


    @objc
    func startScanPassport() {
        /**  Nav To Passport Scan Page **/
        navigateToPassportController()
    }

    @objc
    func startScanOtherIDPage() {
        /**  Nav To Other Scan Page **/
        navigateToOtherController();
    }

    @objc
    func startScanIDPage(_ kycDocumentDetails: String) {
        navigateToIDCardController(jsonStringKycDocumentDetails: kycDocumentDetails)
    }

    @objc
    func submitData(_ data: [String: Any]) {

        DispatchQueue.main.async {
            let instanceHashValue = UserDefaults.standard.string(forKey: "instanceHash") ?? ""

            let eventResultMap: [String: Any]  =   [
                "SubmitDataRequest": true,
                "SubmitDataResponse": false,
                "instanceHash":instanceHashValue,
            ]
            let result: [String: Any] =  ["SubmitData": eventResultMap]
            self.sendEvent(withName: "EventResult",body : result)

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
                            extractedInformationBlockLoader[property.key] = "iOS User Agent Test";
                        }
                        if (property.key.contains(BlockLoaderKeys.InstanceHash)) {
                            extractedInformationBlockLoader[property.key] =  self.configModel?.instanceHash

                        }
                        if (property.key.contains(BlockLoaderKeys.interactionID)) {
                            extractedInformationBlockLoader[property.key] = self.configModel?.instanceId
                        }
                        if data.isEmpty {
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

            print("submitRequestModel")
            submitRequestModel.forEach { item in
                print(item.stepDefinition)
                print(item.extractedInformation)
            }

            var submitData = self.assentifySdk?.startSubmitData(submitDataDelegate: self, submitRequestModel:submitRequestModel)
        }


    }

    func onSubmitError(message: String) {
        print("onSubmitError: %@", message)
        DispatchQueue.main.async {
            let eventResultMap: [String: Any]  =   [
                "SubmitDataRequest": false,
                "SubmitDataResponse": true,
                "success": false,
                "error_message": message
            ]
            let result: [String: Any] =  ["SubmitData": eventResultMap]
            self.sendEvent(withName: "EventResult",body : result)

        }
    }

    func onSubmitSuccess() {
        print("onSubmitSuccess")
        DispatchQueue.main.async {
            let eventResultMap: [String: Any]  =   [
                "SubmitDataRequest": false,
                "SubmitDataResponse": true,
                "success": true,
                "success_message": ""
            ]
            let result: [String: Any] =  ["SubmitData": eventResultMap]
            self.sendEvent(withName: "EventResult",body : result)
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


