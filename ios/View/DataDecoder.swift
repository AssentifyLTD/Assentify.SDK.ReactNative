import Foundation
import AssentifySdk

enum IDType{
    case PASSPORT
    case CARD
    case OTHER
    case FACEMATCH

}





struct StepsName {
    static let DocumentCapture = "IdentificationDocumentCapture"
    static let FaceMatch = "FaceImageAcquisition"
    static let ContextAwareSigning = "ContextAwareSigning"
    static let WrapUp = "WrapUp"
    static let BlockLoader = "BlockLoader"
}



struct WrapUpKeys {
    static let TimeEnded = "OnBoardMe_WrapUp_TimeEnded"

}

struct BlockLoaderKeys {
    static let DeviceName = "OnBoardMe_BlockLoader_DeviceName"
    static let FlowName = "OnBoardMe_BlockLoader_FlowName"
    static let TimeStarted = "OnBoardMe_BlockLoader_TimeStarted"
    static let Application = "OnBoardMe_BlockLoader_Application"
    static let UserAgent = "OnBoardMe_BlockLoader_UserAgent"
    static let InstanceHash = "OnBoardMe_BlockLoader_InstanceHash"
    static let interactionID = "OnBoardMe_BlockLoader_Interaction"
}







func getBirthDate(date: String) -> String {
    var data = date
    if !date.isEmpty {
        if !data.contains("-") && !data.contains("/") {
            var yearNum = String(data.prefix(2))
            let currentYear = String(Int64(Date().timeIntervalSince1970) / 100).prefix(2)
            if Int(yearNum)! < Int(currentYear)! {
                yearNum = "20\(yearNum)"
            } else {
                yearNum = "19\(yearNum)"
            }
            let day = String(data.prefix(6).suffix(2))
            let month = String(data.prefix(4).suffix(2))
            data = "\(day)/\(month)/\(yearNum)"
        }
    }
    return data
}

func getExpiryDate(date: String) -> String {
    var data = date
    if !date.isEmpty {
        let yearNum = "20\(String(data.prefix(2)))"
        let day = String(data.prefix(6).suffix(2))
        let month = String(data.prefix(4).suffix(2))
        data = "\(day)/\(month)/\(yearNum)"
    }
    return data
}



func passportModelToJsonString(dataModel: PassportExtractedModel?) -> String? {
    guard let dataModel = dataModel else { return nil }
    
    var jsonDict: [String: Any] = [:]
    
    jsonDict["outputProperties"] = dataModel.outputProperties
    jsonDict["transformedProperties"] = dataModel.transformedProperties
    jsonDict["extractedData"] = dataModel.extractedData
    jsonDict["imageUrl"] = dataModel.imageUrl
    jsonDict["faces"] = dataModel.faces
    
    if let identificationDocumentCapture = dataModel.identificationDocumentCapture {
        var idCaptureDict: [String: Any] = [:]
        
        idCaptureDict["name"] = identificationDocumentCapture.name
        idCaptureDict["surname"] = identificationDocumentCapture.surname
        idCaptureDict["documentType"] = identificationDocumentCapture.Document_Type
        idCaptureDict["birthDate"] = identificationDocumentCapture.Birth_Date
        idCaptureDict["documentNumber"] = identificationDocumentCapture.Document_Number
        idCaptureDict["sex"] = identificationDocumentCapture.Sex
        idCaptureDict["expiryDate"] = identificationDocumentCapture.Expiry_Date
        idCaptureDict["country"] = identificationDocumentCapture.Country
        idCaptureDict["nationality"] = identificationDocumentCapture.Nationality
        idCaptureDict["idType"] = identificationDocumentCapture.IDType
        idCaptureDict["faceCapture"] = identificationDocumentCapture.FaceCapture
        idCaptureDict["image"] = identificationDocumentCapture.Image
        idCaptureDict["isSkippedAfterNFails"] = identificationDocumentCapture.IsSkippedAfterNFails
        idCaptureDict["isFailedFront"] = identificationDocumentCapture.IsFailedFront
        idCaptureDict["isFailedBack"] = identificationDocumentCapture.IsFailedBack
        idCaptureDict["skippedStatus"] = identificationDocumentCapture.SkippedStatus
        idCaptureDict["capturedVideoFront"] = identificationDocumentCapture.CapturedVideoFront
        idCaptureDict["capturedVideoBack"] = identificationDocumentCapture.CapturedVideoBack
        idCaptureDict["livenessStatus"] = identificationDocumentCapture.LivenessStatus
        idCaptureDict["isFrontAuth"] = identificationDocumentCapture.IsFrontAuth
        idCaptureDict["isBackAuth"] = identificationDocumentCapture.IsBackAuth
        idCaptureDict["isExpired"] = identificationDocumentCapture.IsExpired
        idCaptureDict["isTampering"] = identificationDocumentCapture.IsTampering
        idCaptureDict["tamperHeatMap"] = identificationDocumentCapture.TamperHeatMap
        idCaptureDict["isBackTampering"] = identificationDocumentCapture.IsBackTampering
        idCaptureDict["backTamperHeatmap"] = identificationDocumentCapture.BackTamperHeatmap
        idCaptureDict["originalFrontImage"] = identificationDocumentCapture.OriginalFrontImage
        idCaptureDict["originalBackImage"] = identificationDocumentCapture.OriginalBackImage
        idCaptureDict["ghostImage"] = identificationDocumentCapture.GhostImage
        idCaptureDict["idMaritalStatus"] = identificationDocumentCapture.ID_MaritalStatus
        idCaptureDict["idDateOfIssuance"] = identificationDocumentCapture.ID_DateOfIssuance
        idCaptureDict["idCivilRegisterNumber"] = identificationDocumentCapture.ID_CivilRegisterNumber
        idCaptureDict["idPlaceOfResidence"] = identificationDocumentCapture.ID_PlaceOfResidence
        idCaptureDict["idProvince"] = identificationDocumentCapture.ID_Province
        idCaptureDict["idGovernorate"] = identificationDocumentCapture.ID_Governorate
        idCaptureDict["idMothersName"] = identificationDocumentCapture.ID_MothersName
        idCaptureDict["idFathersName"] = identificationDocumentCapture.ID_FathersName
        idCaptureDict["idPlaceOfBirth"] = identificationDocumentCapture.ID_PlaceOfBirth
        idCaptureDict["idBackImage"] = identificationDocumentCapture.ID_BackImage
        idCaptureDict["idBloodType"] = identificationDocumentCapture.ID_BloodType
        idCaptureDict["idDrivingCategory"] = identificationDocumentCapture.ID_DrivingCategory
        idCaptureDict["idIssuanceAuthority"] = identificationDocumentCapture.ID_IssuanceAuthority
        idCaptureDict["idArmyStatus"] = identificationDocumentCapture.ID_ArmyStatus
        idCaptureDict["idProfession"] = identificationDocumentCapture.ID_Profession
        idCaptureDict["idUniqueNumber"] = identificationDocumentCapture.ID_UniqueNumber
        idCaptureDict["idDocumentTypeNumber"] = identificationDocumentCapture.ID_DocumentTypeNumber
        idCaptureDict["idFees"] = identificationDocumentCapture.ID_Fees
        idCaptureDict["idReference"] = identificationDocumentCapture.ID_Reference
        idCaptureDict["idRegion"] = identificationDocumentCapture.ID_Region
        idCaptureDict["idRegistrationLocation"] = identificationDocumentCapture.ID_RegistrationLocation
        idCaptureDict["idFaceColor"] = identificationDocumentCapture.ID_FaceColor
        idCaptureDict["idEyeColor"] = identificationDocumentCapture.ID_EyeColor
        idCaptureDict["idSpecialMarks"] = identificationDocumentCapture.ID_SpecialMarks
        idCaptureDict["idCountryOfStay"] = identificationDocumentCapture.ID_CountryOfStay
        idCaptureDict["idIdentityNumber"] = identificationDocumentCapture.ID_IdentityNumber
        idCaptureDict["idPresentAddress"] = identificationDocumentCapture.ID_PresentAddress
        idCaptureDict["idPermanentAddress"] = identificationDocumentCapture.ID_PermanentAddress
        idCaptureDict["idFamilyNumber"] = identificationDocumentCapture.ID_FamilyNumber
        idCaptureDict["identityNumberBack"] = identificationDocumentCapture.ID_IdentityNumberBack

        
        jsonDict["identificationDocumentCapture"] = idCaptureDict
    }
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
        return String(data: jsonData, encoding: .utf8)
    }
    
    return nil
}

func faceModelToJsonString(dataModel: FaceExtractedModel?) -> String? {
    guard let dataModel = dataModel else { return nil }
    
    var jsonDict: [String: Any] = [:]
    
    jsonDict["outputProperties"] = dataModel.outputProperties
    jsonDict["extractedData"] = dataModel.extractedData
    jsonDict["baseImageFace"] = dataModel.baseImageFace
    jsonDict["secondImageFace"] = dataModel.secondImageFace
    jsonDict["isLive"] = dataModel.isLive
    jsonDict["percentageMatch"] = dataModel.percentageMatch
    
    if let identificationDocumentCapture = dataModel.identificationDocumentCapture {
        var idCaptureDict: [String: Any] = [:]
        
        idCaptureDict["name"] = identificationDocumentCapture.name
        idCaptureDict["surname"] = identificationDocumentCapture.surname
        idCaptureDict["documentType"] = identificationDocumentCapture.Document_Type
        idCaptureDict["birthDate"] = identificationDocumentCapture.Birth_Date
        idCaptureDict["documentNumber"] = identificationDocumentCapture.Document_Number
        idCaptureDict["sex"] = identificationDocumentCapture.Sex
        idCaptureDict["expiryDate"] = identificationDocumentCapture.Expiry_Date
        idCaptureDict["country"] = identificationDocumentCapture.Country
        idCaptureDict["nationality"] = identificationDocumentCapture.Nationality
        idCaptureDict["idType"] = identificationDocumentCapture.IDType
        idCaptureDict["faceCapture"] = identificationDocumentCapture.FaceCapture
        idCaptureDict["image"] = identificationDocumentCapture.Image
        idCaptureDict["isSkippedAfterNFails"] = identificationDocumentCapture.IsSkippedAfterNFails
        idCaptureDict["isFailedFront"] = identificationDocumentCapture.IsFailedFront
        idCaptureDict["isFailedBack"] = identificationDocumentCapture.IsFailedBack
        idCaptureDict["skippedStatus"] = identificationDocumentCapture.SkippedStatus
        idCaptureDict["capturedVideoFront"] = identificationDocumentCapture.CapturedVideoFront
        idCaptureDict["capturedVideoBack"] = identificationDocumentCapture.CapturedVideoBack
        idCaptureDict["livenessStatus"] = identificationDocumentCapture.LivenessStatus
        idCaptureDict["isFrontAuth"] = identificationDocumentCapture.IsFrontAuth
        idCaptureDict["isBackAuth"] = identificationDocumentCapture.IsBackAuth
        idCaptureDict["isExpired"] = identificationDocumentCapture.IsExpired
        idCaptureDict["isTampering"] = identificationDocumentCapture.IsTampering
        idCaptureDict["tamperHeatMap"] = identificationDocumentCapture.TamperHeatMap
        idCaptureDict["isBackTampering"] = identificationDocumentCapture.IsBackTampering
        idCaptureDict["backTamperHeatmap"] = identificationDocumentCapture.BackTamperHeatmap
        idCaptureDict["originalFrontImage"] = identificationDocumentCapture.OriginalFrontImage
        idCaptureDict["originalBackImage"] = identificationDocumentCapture.OriginalBackImage
        idCaptureDict["ghostImage"] = identificationDocumentCapture.GhostImage
        idCaptureDict["idMaritalStatus"] = identificationDocumentCapture.ID_MaritalStatus
        idCaptureDict["idDateOfIssuance"] = identificationDocumentCapture.ID_DateOfIssuance
        idCaptureDict["idCivilRegisterNumber"] = identificationDocumentCapture.ID_CivilRegisterNumber
        idCaptureDict["idPlaceOfResidence"] = identificationDocumentCapture.ID_PlaceOfResidence
        idCaptureDict["idProvince"] = identificationDocumentCapture.ID_Province
        idCaptureDict["idGovernorate"] = identificationDocumentCapture.ID_Governorate
        idCaptureDict["idMothersName"] = identificationDocumentCapture.ID_MothersName
        idCaptureDict["idFathersName"] = identificationDocumentCapture.ID_FathersName
        idCaptureDict["idPlaceOfBirth"] = identificationDocumentCapture.ID_PlaceOfBirth
        idCaptureDict["idBackImage"] = identificationDocumentCapture.ID_BackImage
        idCaptureDict["idBloodType"] = identificationDocumentCapture.ID_BloodType
        idCaptureDict["idDrivingCategory"] = identificationDocumentCapture.ID_DrivingCategory
        idCaptureDict["idIssuanceAuthority"] = identificationDocumentCapture.ID_IssuanceAuthority
        idCaptureDict["idArmyStatus"] = identificationDocumentCapture.ID_ArmyStatus
        idCaptureDict["idProfession"] = identificationDocumentCapture.ID_Profession
        idCaptureDict["idUniqueNumber"] = identificationDocumentCapture.ID_UniqueNumber
        idCaptureDict["idDocumentTypeNumber"] = identificationDocumentCapture.ID_DocumentTypeNumber
        idCaptureDict["idFees"] = identificationDocumentCapture.ID_Fees
        idCaptureDict["idReference"] = identificationDocumentCapture.ID_Reference
        idCaptureDict["idRegion"] = identificationDocumentCapture.ID_Region
        idCaptureDict["idRegistrationLocation"] = identificationDocumentCapture.ID_RegistrationLocation
        idCaptureDict["idFaceColor"] = identificationDocumentCapture.ID_FaceColor
        idCaptureDict["idEyeColor"] = identificationDocumentCapture.ID_EyeColor
        idCaptureDict["idSpecialMarks"] = identificationDocumentCapture.ID_SpecialMarks
        idCaptureDict["idCountryOfStay"] = identificationDocumentCapture.ID_CountryOfStay
        idCaptureDict["idIdentityNumber"] = identificationDocumentCapture.ID_IdentityNumber
        idCaptureDict["idPresentAddress"] = identificationDocumentCapture.ID_PresentAddress
        idCaptureDict["idPermanentAddress"] = identificationDocumentCapture.ID_PermanentAddress
        idCaptureDict["idFamilyNumber"] = identificationDocumentCapture.ID_FamilyNumber
        idCaptureDict["identityNumberBack"] = identificationDocumentCapture.ID_IdentityNumberBack

        
        jsonDict["identificationDocumentCapture"] = idCaptureDict
    }
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
        return String(data: jsonData, encoding: .utf8)
    }
    
    return nil
}

func iDModelToJsonString(dataModel: IDExtractedModel?) -> String? {
    guard let dataModel = dataModel else { return nil }
    
    var jsonDict: [String: Any] = [:]
    
    jsonDict["outputProperties"] = dataModel.outputProperties
    jsonDict["transformedProperties"] = dataModel.transformedProperties
    jsonDict["extractedData"] = dataModel.extractedData
    jsonDict["imageUrl"] = dataModel.imageUrl
    jsonDict["faces"] = dataModel.faces
    
    if let identificationDocumentCapture = dataModel.identificationDocumentCapture {
        var idCaptureDict: [String: Any] = [:]
        
        idCaptureDict["name"] = identificationDocumentCapture.name
        idCaptureDict["surname"] = identificationDocumentCapture.surname
        idCaptureDict["documentType"] = identificationDocumentCapture.Document_Type
        idCaptureDict["birthDate"] = identificationDocumentCapture.Birth_Date
        idCaptureDict["documentNumber"] = identificationDocumentCapture.Document_Number
        idCaptureDict["sex"] = identificationDocumentCapture.Sex
        idCaptureDict["expiryDate"] = identificationDocumentCapture.Expiry_Date
        idCaptureDict["country"] = identificationDocumentCapture.Country
        idCaptureDict["nationality"] = identificationDocumentCapture.Nationality
        idCaptureDict["idType"] = identificationDocumentCapture.IDType
        idCaptureDict["faceCapture"] = identificationDocumentCapture.FaceCapture
        idCaptureDict["image"] = identificationDocumentCapture.Image
        idCaptureDict["isSkippedAfterNFails"] = identificationDocumentCapture.IsSkippedAfterNFails
        idCaptureDict["isFailedFront"] = identificationDocumentCapture.IsFailedFront
        idCaptureDict["isFailedBack"] = identificationDocumentCapture.IsFailedBack
        idCaptureDict["skippedStatus"] = identificationDocumentCapture.SkippedStatus
        idCaptureDict["capturedVideoFront"] = identificationDocumentCapture.CapturedVideoFront
        idCaptureDict["capturedVideoBack"] = identificationDocumentCapture.CapturedVideoBack
        idCaptureDict["livenessStatus"] = identificationDocumentCapture.LivenessStatus
        idCaptureDict["isFrontAuth"] = identificationDocumentCapture.IsFrontAuth
        idCaptureDict["isBackAuth"] = identificationDocumentCapture.IsBackAuth
        idCaptureDict["isExpired"] = identificationDocumentCapture.IsExpired
        idCaptureDict["isTampering"] = identificationDocumentCapture.IsTampering
        idCaptureDict["tamperHeatMap"] = identificationDocumentCapture.TamperHeatMap
        idCaptureDict["isBackTampering"] = identificationDocumentCapture.IsBackTampering
        idCaptureDict["backTamperHeatmap"] = identificationDocumentCapture.BackTamperHeatmap
        idCaptureDict["originalFrontImage"] = identificationDocumentCapture.OriginalFrontImage
        idCaptureDict["originalBackImage"] = identificationDocumentCapture.OriginalBackImage
        idCaptureDict["ghostImage"] = identificationDocumentCapture.GhostImage
        idCaptureDict["idMaritalStatus"] = identificationDocumentCapture.ID_MaritalStatus
        idCaptureDict["idDateOfIssuance"] = identificationDocumentCapture.ID_DateOfIssuance
        idCaptureDict["idCivilRegisterNumber"] = identificationDocumentCapture.ID_CivilRegisterNumber
        idCaptureDict["idPlaceOfResidence"] = identificationDocumentCapture.ID_PlaceOfResidence
        idCaptureDict["idProvince"] = identificationDocumentCapture.ID_Province
        idCaptureDict["idGovernorate"] = identificationDocumentCapture.ID_Governorate
        idCaptureDict["idMothersName"] = identificationDocumentCapture.ID_MothersName
        idCaptureDict["idFathersName"] = identificationDocumentCapture.ID_FathersName
        idCaptureDict["idPlaceOfBirth"] = identificationDocumentCapture.ID_PlaceOfBirth
        idCaptureDict["idBackImage"] = identificationDocumentCapture.ID_BackImage
        idCaptureDict["idBloodType"] = identificationDocumentCapture.ID_BloodType
        idCaptureDict["idDrivingCategory"] = identificationDocumentCapture.ID_DrivingCategory
        idCaptureDict["idIssuanceAuthority"] = identificationDocumentCapture.ID_IssuanceAuthority
        idCaptureDict["idArmyStatus"] = identificationDocumentCapture.ID_ArmyStatus
        idCaptureDict["idProfession"] = identificationDocumentCapture.ID_Profession
        idCaptureDict["idUniqueNumber"] = identificationDocumentCapture.ID_UniqueNumber
        idCaptureDict["idDocumentTypeNumber"] = identificationDocumentCapture.ID_DocumentTypeNumber
        idCaptureDict["idFees"] = identificationDocumentCapture.ID_Fees
        idCaptureDict["idReference"] = identificationDocumentCapture.ID_Reference
        idCaptureDict["idRegion"] = identificationDocumentCapture.ID_Region
        idCaptureDict["idRegistrationLocation"] = identificationDocumentCapture.ID_RegistrationLocation
        idCaptureDict["idFaceColor"] = identificationDocumentCapture.ID_FaceColor
        idCaptureDict["idEyeColor"] = identificationDocumentCapture.ID_EyeColor
        idCaptureDict["idSpecialMarks"] = identificationDocumentCapture.ID_SpecialMarks
        idCaptureDict["idCountryOfStay"] = identificationDocumentCapture.ID_CountryOfStay
        idCaptureDict["idIdentityNumber"] = identificationDocumentCapture.ID_IdentityNumber
        idCaptureDict["idPresentAddress"] = identificationDocumentCapture.ID_PresentAddress
        idCaptureDict["idPermanentAddress"] = identificationDocumentCapture.ID_PermanentAddress
        idCaptureDict["idFamilyNumber"] = identificationDocumentCapture.ID_FamilyNumber
        idCaptureDict["identityNumberBack"] = identificationDocumentCapture.ID_IdentityNumberBack

        
        jsonDict["identificationDocumentCapture"] = idCaptureDict
    }
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
        return String(data: jsonData, encoding: .utf8)
    }
    
    return nil
}


func otherModelToJsonString(dataModel: OtherExtractedModel?) -> String? {
    guard let dataModel = dataModel else { return nil }
    
    var jsonDict: [String: Any] = [:]
    
    jsonDict["outputProperties"] = dataModel.outputProperties
    jsonDict["transformedProperties"] = dataModel.transformedProperties
    jsonDict["extractedData"] = dataModel.extractedData
    jsonDict["additionalDetails"] = dataModel.additionalDetails
    jsonDict["transformedDetails"] = dataModel.transformedDetails
    jsonDict["imageUrl"] = dataModel.imageUrl
    jsonDict["faces"] = dataModel.faces
    
    if let identificationDocumentCapture = dataModel.identificationDocumentCapture {
        var idCaptureDict: [String: Any] = [:]
        
        idCaptureDict["name"] = identificationDocumentCapture.name
        idCaptureDict["surname"] = identificationDocumentCapture.surname
        idCaptureDict["documentType"] = identificationDocumentCapture.Document_Type
        idCaptureDict["birthDate"] = identificationDocumentCapture.Birth_Date
        idCaptureDict["documentNumber"] = identificationDocumentCapture.Document_Number
        idCaptureDict["sex"] = identificationDocumentCapture.Sex
        idCaptureDict["expiryDate"] = identificationDocumentCapture.Expiry_Date
        idCaptureDict["country"] = identificationDocumentCapture.Country
        idCaptureDict["nationality"] = identificationDocumentCapture.Nationality
        idCaptureDict["idType"] = identificationDocumentCapture.IDType
        idCaptureDict["faceCapture"] = identificationDocumentCapture.FaceCapture
        idCaptureDict["image"] = identificationDocumentCapture.Image
        idCaptureDict["isSkippedAfterNFails"] = identificationDocumentCapture.IsSkippedAfterNFails
        idCaptureDict["isFailedFront"] = identificationDocumentCapture.IsFailedFront
        idCaptureDict["isFailedBack"] = identificationDocumentCapture.IsFailedBack
        idCaptureDict["skippedStatus"] = identificationDocumentCapture.SkippedStatus
        idCaptureDict["capturedVideoFront"] = identificationDocumentCapture.CapturedVideoFront
        idCaptureDict["capturedVideoBack"] = identificationDocumentCapture.CapturedVideoBack
        idCaptureDict["livenessStatus"] = identificationDocumentCapture.LivenessStatus
        idCaptureDict["isFrontAuth"] = identificationDocumentCapture.IsFrontAuth
        idCaptureDict["isBackAuth"] = identificationDocumentCapture.IsBackAuth
        idCaptureDict["isExpired"] = identificationDocumentCapture.IsExpired
        idCaptureDict["isTampering"] = identificationDocumentCapture.IsTampering
        idCaptureDict["tamperHeatMap"] = identificationDocumentCapture.TamperHeatMap
        idCaptureDict["isBackTampering"] = identificationDocumentCapture.IsBackTampering
        idCaptureDict["backTamperHeatmap"] = identificationDocumentCapture.BackTamperHeatmap
        idCaptureDict["originalFrontImage"] = identificationDocumentCapture.OriginalFrontImage
        idCaptureDict["originalBackImage"] = identificationDocumentCapture.OriginalBackImage
        idCaptureDict["ghostImage"] = identificationDocumentCapture.GhostImage
        idCaptureDict["idMaritalStatus"] = identificationDocumentCapture.ID_MaritalStatus
        idCaptureDict["idDateOfIssuance"] = identificationDocumentCapture.ID_DateOfIssuance
        idCaptureDict["idCivilRegisterNumber"] = identificationDocumentCapture.ID_CivilRegisterNumber
        idCaptureDict["idPlaceOfResidence"] = identificationDocumentCapture.ID_PlaceOfResidence
        idCaptureDict["idProvince"] = identificationDocumentCapture.ID_Province
        idCaptureDict["idGovernorate"] = identificationDocumentCapture.ID_Governorate
        idCaptureDict["idMothersName"] = identificationDocumentCapture.ID_MothersName
        idCaptureDict["idFathersName"] = identificationDocumentCapture.ID_FathersName
        idCaptureDict["idPlaceOfBirth"] = identificationDocumentCapture.ID_PlaceOfBirth
        idCaptureDict["idBackImage"] = identificationDocumentCapture.ID_BackImage
        idCaptureDict["idBloodType"] = identificationDocumentCapture.ID_BloodType
        idCaptureDict["idDrivingCategory"] = identificationDocumentCapture.ID_DrivingCategory
        idCaptureDict["idIssuanceAuthority"] = identificationDocumentCapture.ID_IssuanceAuthority
        idCaptureDict["idArmyStatus"] = identificationDocumentCapture.ID_ArmyStatus
        idCaptureDict["idProfession"] = identificationDocumentCapture.ID_Profession
        idCaptureDict["idUniqueNumber"] = identificationDocumentCapture.ID_UniqueNumber
        idCaptureDict["idDocumentTypeNumber"] = identificationDocumentCapture.ID_DocumentTypeNumber
        idCaptureDict["idFees"] = identificationDocumentCapture.ID_Fees
        idCaptureDict["idReference"] = identificationDocumentCapture.ID_Reference
        idCaptureDict["idRegion"] = identificationDocumentCapture.ID_Region
        idCaptureDict["idRegistrationLocation"] = identificationDocumentCapture.ID_RegistrationLocation
        idCaptureDict["idFaceColor"] = identificationDocumentCapture.ID_FaceColor
        idCaptureDict["idEyeColor"] = identificationDocumentCapture.ID_EyeColor
        idCaptureDict["idSpecialMarks"] = identificationDocumentCapture.ID_SpecialMarks
        idCaptureDict["idCountryOfStay"] = identificationDocumentCapture.ID_CountryOfStay
        idCaptureDict["idIdentityNumber"] = identificationDocumentCapture.ID_IdentityNumber
        idCaptureDict["idPresentAddress"] = identificationDocumentCapture.ID_PresentAddress
        idCaptureDict["idPermanentAddress"] = identificationDocumentCapture.ID_PermanentAddress
        idCaptureDict["idFamilyNumber"] = identificationDocumentCapture.ID_FamilyNumber
        idCaptureDict["identityNumberBack"] = identificationDocumentCapture.ID_IdentityNumberBack

        
        jsonDict["identificationDocumentCapture"] = idCaptureDict
    }
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
        return String(data: jsonData, encoding: .utf8)
    }
    
    return nil
}


func parseSubmitRequestModelList(jsonString: String) -> [SubmitRequestModel]? {
    guard let data = jsonString.data(using: .utf8) else { return nil }
    
    do {
        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            var submitRequestList = [SubmitRequestModel]()
            
            for jsonObject in jsonArray {
                if let stepId = jsonObject["stepId"] as? Int,
                   let stepDefinition = jsonObject["stepDefinition"] as? String,
                   let extractedInformation = jsonObject["extractedInformation"] as? [String: Any] {
                    let submitRequestModel = SubmitRequestModel(stepId: stepId, stepDefinition: stepDefinition, extractedInformation: convertAnyDictToStringDict(dict: extractedInformation))
                    submitRequestList.append(submitRequestModel)
                }
            }
            return submitRequestList
        }
    } catch {
        print("Error parsing JSON: \(error.localizedDescription)")
    }
    
    return nil
}

func convertAnyDictToStringDict(dict: [String: Any]) -> [String: String] {
    var stringDict: [String: String] = [:]
    for (key, value) in dict {
      if(value is NSNull ){
        continue
      }else{
        if let stringValue = value as? String {
          if(!stringValue.isEmpty){
            stringDict[key] = stringValue
          }
        } else {
          if(!"\(value)".isEmpty){
            stringDict[key] = "\(value)"
          }
        }
      }
    }
    return stringDict
}



