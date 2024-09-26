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

struct DocumentCaptureKeys {
    static let FirstName = "OnBoardMe_IdentificationDocumentCapture_name"
    static let LastName = "OnBoardMe_IdentificationDocumentCapture_surname"
    static let DocumentType = "OnBoardMe_IdentificationDocumentCapture_Document_Type"
    static let BirthDate = "OnBoardMe_IdentificationDocumentCapture_Birth_Date"
    static let ExpiryDate = "OnBoardMe_IdentificationDocumentCapture_Expiry_Date"
    static let DocumentNumber = "IdentificationDocumentCapture_Document_Number"
    static let Sex = "OnBoardMe_IdentificationDocumentCapture_Sex"
    static let Country = "OnBoardMe_IdentificationDocumentCapture_Country"
    static let Nationality = "OnBoardMe_IdentificationDocumentCapture_Nationality"
    static let FaceCapture = "OnBoardMe_IdentificationDocumentCapture_FaceCapture"
    static let DocumentImage = "OnBoardMe_IdentificationDocumentCapture_Image"
    static let BackImage = "OnBoardMe_IdentificationDocumentCapture_ID_BackImage"
}

struct FaceKeys {
    static let BaseImage = "OnBoardMe_FaceImageAcquisition_BaseImage"
    static let SecondImage = "OnBoardMe_FaceImageAcquisition_SecondImage"
    static let Percentage = "OnBoardMe_FaceImageAcquisition_Percentage"

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

struct ContextAwareSigningKeys {
    static let DocumentURL = "OnBoardMe_ContextAwareSigning_DocumentURL"
    static let SignatureURL = "OnBoardMe_ContextAwareSigning_SignatureURL"
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
        idCaptureDict["iDType"] = identificationDocumentCapture.IDType
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
        idCaptureDict["nackTamperHeatmap"] = identificationDocumentCapture.BackTamperHeatmap
        idCaptureDict["originalFrontImage"] = identificationDocumentCapture.OriginalFrontImage
        idCaptureDict["originalBackImage"] = identificationDocumentCapture.OriginalBackImage
        idCaptureDict["ghostImage"] = identificationDocumentCapture.GhostImage
        idCaptureDict["iDMaritalStatus"] = identificationDocumentCapture.ID_MaritalStatus
        idCaptureDict["iDDateOfIssuance"] = identificationDocumentCapture.ID_DateOfIssuance
        idCaptureDict["iDCivilRegisterNumber"] = identificationDocumentCapture.ID_CivilRegisterNumber
        idCaptureDict["iDPlaceOfResidence"] = identificationDocumentCapture.ID_PlaceOfResidence
        idCaptureDict["iDProvince"] = identificationDocumentCapture.ID_Province
        idCaptureDict["iDGovernorate"] = identificationDocumentCapture.ID_Governorate
        idCaptureDict["iDMothersName"] = identificationDocumentCapture.ID_MothersName
        idCaptureDict["iDFathersName"] = identificationDocumentCapture.ID_FathersName
        idCaptureDict["iDPlaceOfBirth"] = identificationDocumentCapture.ID_PlaceOfBirth
        idCaptureDict["iDBackImage"] = identificationDocumentCapture.ID_BackImage
        idCaptureDict["iDBloodType"] = identificationDocumentCapture.ID_BloodType
        idCaptureDict["iDDrivingCategory"] = identificationDocumentCapture.ID_DrivingCategory
        idCaptureDict["iDIssuanceAuthority"] = identificationDocumentCapture.ID_IssuanceAuthority
        idCaptureDict["iDArmyStatus"] = identificationDocumentCapture.ID_ArmyStatus
        idCaptureDict["iDProfession"] = identificationDocumentCapture.ID_Profession
        idCaptureDict["iDUniqueNumber"] = identificationDocumentCapture.ID_UniqueNumber
        idCaptureDict["iDDocumentTypeNumber"] = identificationDocumentCapture.ID_DocumentTypeNumber
        idCaptureDict["iDFees"] = identificationDocumentCapture.ID_Fees
        idCaptureDict["iDReference"] = identificationDocumentCapture.ID_Reference
        idCaptureDict["iDRegion"] = identificationDocumentCapture.ID_Region
        idCaptureDict["iDRegistrationLocation"] = identificationDocumentCapture.ID_RegistrationLocation
        idCaptureDict["iDFaceColor"] = identificationDocumentCapture.ID_FaceColor
        idCaptureDict["iDEyeColor"] = identificationDocumentCapture.ID_EyeColor
        idCaptureDict["iDSpecialMarks"] = identificationDocumentCapture.ID_SpecialMarks
        idCaptureDict["iDGuardianName"] = identificationDocumentCapture.ID_GuardianName
        idCaptureDict["iDCountryOfStay"] = identificationDocumentCapture.ID_CountryOfStay
        idCaptureDict["iDIdentityNumber"] = identificationDocumentCapture.ID_IdentityNumber
        idCaptureDict["iDPresentAddress"] = identificationDocumentCapture.ID_PresentAddress
        idCaptureDict["iDPermanentAddress"] = identificationDocumentCapture.ID_PermanentAddress
        idCaptureDict["iDFamilyNumber"] = identificationDocumentCapture.ID_FamilyNumber
        idCaptureDict["iDIdentityNumberBack"] = identificationDocumentCapture.ID_IdentityNumberBack

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
    jsonDict["IsLive"] = dataModel.isLive
    jsonDict["PercentageMatch"] = dataModel.percentageMatch

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
        idCaptureDict["iDType"] = identificationDocumentCapture.IDType
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
        idCaptureDict["nackTamperHeatmap"] = identificationDocumentCapture.BackTamperHeatmap
        idCaptureDict["originalFrontImage"] = identificationDocumentCapture.OriginalFrontImage
        idCaptureDict["originalBackImage"] = identificationDocumentCapture.OriginalBackImage
        idCaptureDict["ghostImage"] = identificationDocumentCapture.GhostImage
        idCaptureDict["iDMaritalStatus"] = identificationDocumentCapture.ID_MaritalStatus
        idCaptureDict["iDDateOfIssuance"] = identificationDocumentCapture.ID_DateOfIssuance
        idCaptureDict["iDCivilRegisterNumber"] = identificationDocumentCapture.ID_CivilRegisterNumber
        idCaptureDict["iDPlaceOfResidence"] = identificationDocumentCapture.ID_PlaceOfResidence
        idCaptureDict["iDProvince"] = identificationDocumentCapture.ID_Province
        idCaptureDict["iDGovernorate"] = identificationDocumentCapture.ID_Governorate
        idCaptureDict["iDMothersName"] = identificationDocumentCapture.ID_MothersName
        idCaptureDict["iDFathersName"] = identificationDocumentCapture.ID_FathersName
        idCaptureDict["iDPlaceOfBirth"] = identificationDocumentCapture.ID_PlaceOfBirth
        idCaptureDict["iDBackImage"] = identificationDocumentCapture.ID_BackImage
        idCaptureDict["iDBloodType"] = identificationDocumentCapture.ID_BloodType
        idCaptureDict["iDDrivingCategory"] = identificationDocumentCapture.ID_DrivingCategory
        idCaptureDict["iDIssuanceAuthority"] = identificationDocumentCapture.ID_IssuanceAuthority
        idCaptureDict["iDArmyStatus"] = identificationDocumentCapture.ID_ArmyStatus
        idCaptureDict["iDProfession"] = identificationDocumentCapture.ID_Profession
        idCaptureDict["iDUniqueNumber"] = identificationDocumentCapture.ID_UniqueNumber
        idCaptureDict["iDDocumentTypeNumber"] = identificationDocumentCapture.ID_DocumentTypeNumber
        idCaptureDict["iDFees"] = identificationDocumentCapture.ID_Fees
        idCaptureDict["iDReference"] = identificationDocumentCapture.ID_Reference
        idCaptureDict["iDRegion"] = identificationDocumentCapture.ID_Region
        idCaptureDict["iDRegistrationLocation"] = identificationDocumentCapture.ID_RegistrationLocation
        idCaptureDict["iDFaceColor"] = identificationDocumentCapture.ID_FaceColor
        idCaptureDict["iDEyeColor"] = identificationDocumentCapture.ID_EyeColor
        idCaptureDict["iDSpecialMarks"] = identificationDocumentCapture.ID_SpecialMarks
        idCaptureDict["iDGuardianName"] = identificationDocumentCapture.ID_GuardianName
        idCaptureDict["iDCountryOfStay"] = identificationDocumentCapture.ID_CountryOfStay
        idCaptureDict["iDIdentityNumber"] = identificationDocumentCapture.ID_IdentityNumber
        idCaptureDict["iDPresentAddress"] = identificationDocumentCapture.ID_PresentAddress
        idCaptureDict["iDPermanentAddress"] = identificationDocumentCapture.ID_PermanentAddress
        idCaptureDict["iDFamilyNumber"] = identificationDocumentCapture.ID_FamilyNumber
        idCaptureDict["iDIdentityNumberBack"] = identificationDocumentCapture.ID_IdentityNumberBack

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
        idCaptureDict["iDType"] = identificationDocumentCapture.IDType
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
        idCaptureDict["nackTamperHeatmap"] = identificationDocumentCapture.BackTamperHeatmap
        idCaptureDict["originalFrontImage"] = identificationDocumentCapture.OriginalFrontImage
        idCaptureDict["originalBackImage"] = identificationDocumentCapture.OriginalBackImage
        idCaptureDict["ghostImage"] = identificationDocumentCapture.GhostImage
        idCaptureDict["iDMaritalStatus"] = identificationDocumentCapture.ID_MaritalStatus
        idCaptureDict["iDDateOfIssuance"] = identificationDocumentCapture.ID_DateOfIssuance
        idCaptureDict["iDCivilRegisterNumber"] = identificationDocumentCapture.ID_CivilRegisterNumber
        idCaptureDict["iDPlaceOfResidence"] = identificationDocumentCapture.ID_PlaceOfResidence
        idCaptureDict["iDProvince"] = identificationDocumentCapture.ID_Province
        idCaptureDict["iDGovernorate"] = identificationDocumentCapture.ID_Governorate
        idCaptureDict["iDMothersName"] = identificationDocumentCapture.ID_MothersName
        idCaptureDict["iDFathersName"] = identificationDocumentCapture.ID_FathersName
        idCaptureDict["iDPlaceOfBirth"] = identificationDocumentCapture.ID_PlaceOfBirth
        idCaptureDict["iDBackImage"] = identificationDocumentCapture.ID_BackImage
        idCaptureDict["iDBloodType"] = identificationDocumentCapture.ID_BloodType
        idCaptureDict["iDDrivingCategory"] = identificationDocumentCapture.ID_DrivingCategory
        idCaptureDict["iDIssuanceAuthority"] = identificationDocumentCapture.ID_IssuanceAuthority
        idCaptureDict["iDArmyStatus"] = identificationDocumentCapture.ID_ArmyStatus
        idCaptureDict["iDProfession"] = identificationDocumentCapture.ID_Profession
        idCaptureDict["iDUniqueNumber"] = identificationDocumentCapture.ID_UniqueNumber
        idCaptureDict["iDDocumentTypeNumber"] = identificationDocumentCapture.ID_DocumentTypeNumber
        idCaptureDict["iDFees"] = identificationDocumentCapture.ID_Fees
        idCaptureDict["iDReference"] = identificationDocumentCapture.ID_Reference
        idCaptureDict["iDRegion"] = identificationDocumentCapture.ID_Region
        idCaptureDict["iDRegistrationLocation"] = identificationDocumentCapture.ID_RegistrationLocation
        idCaptureDict["iDFaceColor"] = identificationDocumentCapture.ID_FaceColor
        idCaptureDict["iDEyeColor"] = identificationDocumentCapture.ID_EyeColor
        idCaptureDict["iDSpecialMarks"] = identificationDocumentCapture.ID_SpecialMarks
        idCaptureDict["iDGuardianName"] = identificationDocumentCapture.ID_GuardianName
        idCaptureDict["iDCountryOfStay"] = identificationDocumentCapture.ID_CountryOfStay
        idCaptureDict["iDIdentityNumber"] = identificationDocumentCapture.ID_IdentityNumber
        idCaptureDict["iDPresentAddress"] = identificationDocumentCapture.ID_PresentAddress
        idCaptureDict["iDPermanentAddress"] = identificationDocumentCapture.ID_PermanentAddress
        idCaptureDict["iDFamilyNumber"] = identificationDocumentCapture.ID_FamilyNumber
        idCaptureDict["iDIdentityNumberBack"] = identificationDocumentCapture.ID_IdentityNumberBack

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
    jsonDict["extractedData"] = dataModel.extractedData
    jsonDict["additionalDetails"] = dataModel.additionalDetails
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
        idCaptureDict["iDType"] = identificationDocumentCapture.IDType
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
        idCaptureDict["nackTamperHeatmap"] = identificationDocumentCapture.BackTamperHeatmap
        idCaptureDict["originalFrontImage"] = identificationDocumentCapture.OriginalFrontImage
        idCaptureDict["originalBackImage"] = identificationDocumentCapture.OriginalBackImage
        idCaptureDict["ghostImage"] = identificationDocumentCapture.GhostImage
        idCaptureDict["iDMaritalStatus"] = identificationDocumentCapture.ID_MaritalStatus
        idCaptureDict["iDDateOfIssuance"] = identificationDocumentCapture.ID_DateOfIssuance
        idCaptureDict["iDCivilRegisterNumber"] = identificationDocumentCapture.ID_CivilRegisterNumber
        idCaptureDict["iDPlaceOfResidence"] = identificationDocumentCapture.ID_PlaceOfResidence
        idCaptureDict["iDProvince"] = identificationDocumentCapture.ID_Province
        idCaptureDict["iDGovernorate"] = identificationDocumentCapture.ID_Governorate
        idCaptureDict["iDMothersName"] = identificationDocumentCapture.ID_MothersName
        idCaptureDict["iDFathersName"] = identificationDocumentCapture.ID_FathersName
        idCaptureDict["iDPlaceOfBirth"] = identificationDocumentCapture.ID_PlaceOfBirth
        idCaptureDict["iDBackImage"] = identificationDocumentCapture.ID_BackImage
        idCaptureDict["iDBloodType"] = identificationDocumentCapture.ID_BloodType
        idCaptureDict["iDDrivingCategory"] = identificationDocumentCapture.ID_DrivingCategory
        idCaptureDict["iDIssuanceAuthority"] = identificationDocumentCapture.ID_IssuanceAuthority
        idCaptureDict["iDArmyStatus"] = identificationDocumentCapture.ID_ArmyStatus
        idCaptureDict["iDProfession"] = identificationDocumentCapture.ID_Profession
        idCaptureDict["iDUniqueNumber"] = identificationDocumentCapture.ID_UniqueNumber
        idCaptureDict["iDDocumentTypeNumber"] = identificationDocumentCapture.ID_DocumentTypeNumber
        idCaptureDict["iDFees"] = identificationDocumentCapture.ID_Fees
        idCaptureDict["iDReference"] = identificationDocumentCapture.ID_Reference
        idCaptureDict["iDRegion"] = identificationDocumentCapture.ID_Region
        idCaptureDict["iDRegistrationLocation"] = identificationDocumentCapture.ID_RegistrationLocation
        idCaptureDict["iDFaceColor"] = identificationDocumentCapture.ID_FaceColor
        idCaptureDict["iDEyeColor"] = identificationDocumentCapture.ID_EyeColor
        idCaptureDict["iDSpecialMarks"] = identificationDocumentCapture.ID_SpecialMarks
        idCaptureDict["iDGuardianName"] = identificationDocumentCapture.ID_GuardianName
        idCaptureDict["iDCountryOfStay"] = identificationDocumentCapture.ID_CountryOfStay
        idCaptureDict["iDIdentityNumber"] = identificationDocumentCapture.ID_IdentityNumber
        idCaptureDict["iDPresentAddress"] = identificationDocumentCapture.ID_PresentAddress
        idCaptureDict["iDPermanentAddress"] = identificationDocumentCapture.ID_PermanentAddress
        idCaptureDict["iDFamilyNumber"] = identificationDocumentCapture.ID_FamilyNumber
        idCaptureDict["iDIdentityNumberBack"] = identificationDocumentCapture.ID_IdentityNumberBack

        jsonDict["identificationDocumentCapture"] = idCaptureDict
    }

    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
        return String(data: jsonData, encoding: .utf8)
    }

    return nil
}


