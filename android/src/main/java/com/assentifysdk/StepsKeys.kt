import com.assentify.sdk.RemoteClient.Models.DocumentTokensModel

class StepsName{
  companion object {
    const val DocumentCapture = "IdentificationDocumentCapture"
    const val FaceMatch = "FaceImageAcquisition"
    const val ContextAwareSigning = "ContextAwareSigning"
    const val WrapUp = "WrapUp"
    const val BlockLoader = "BlockLoader"

  }
}
class DocumentCaptureKeys{
  companion object {
    const val FirstName = "OnBoardMe_IdentificationDocumentCapture_name"
    const val LastName = "OnBoardMe_IdentificationDocumentCapture_surname"
    const val DocumentType = "OnBoardMe_IdentificationDocumentCapture_Document_Type"
    const val BirthDate = "OnBoardMe_IdentificationDocumentCapture_Birth_Date"
    const val ExpiryDate = "OnBoardMe_IdentificationDocumentCapture_Expiry_Date"
    const val DocumentNumber = "IdentificationDocumentCapture_Document_Number"
    const val Sex = "OnBoardMe_IdentificationDocumentCapture_Sex"
    const val Country = "OnBoardMe_IdentificationDocumentCapture_Country"
    const val Nationality = "OnBoardMe_IdentificationDocumentCapture_Nationality"
    const val FaceCapture = "OnBoardMe_IdentificationDocumentCapture_FaceCapture"
    const val DocumentImage = "OnBoardMe_IdentificationDocumentCapture_Image"
    const val MothersName = "OnBoardMe_IdentificationDocumentCapture_ID_MothersName"
    const val PlaceOfBirth = "OnBoardMe_IdentificationDocumentCapture_ID_PlaceOfBirth"
    const val FathersName = "OnBoardMe_IdentificationDocumentCapture_ID_FathersName"
    const val BackImage = "OnBoardMe_IdentificationDocumentCapture_ID_BackImage"
  }
}
class FaceKeys{
  companion object {
    const val BaseImage = "OnBoardMe_FaceImageAcquisition_BaseImage"
    const val SecondImage = "OnBoardMe_FaceImageAcquisition_SecondImage"
    const val Percentage = "OnBoardMe_FaceImageAcquisition_Percentage"
  }
}

class ContextAwareSigningKeys{
  companion object {
    const val DocumentURL = "OnBoardMe_ContextAwareSigning_DocumentURL"
    const val SignatureURL = "OnBoardMe_ContextAwareSigning_SignatureURL"

  }
}

class WrapUpKeys{
  companion object {
    const val TimeEnded = "OnBoardMe_WrapUp_TimeEnded"
  }
}

class BlockLoaderKeys{
  companion object {
    const val DeviceName = "OnBoardMe_BlockLoader_DeviceName"
    const val FlowName = "OnBoardMe_BlockLoader_FlowName"
    const val TimeStarted = "OnBoardMe_BlockLoader_TimeStarted"
    const val Application = "OnBoardMe_BlockLoader_Application"
    const val UserAgent = "OnBoardMe_BlockLoader_UserAgent"
    const val InstanceHash = "OnBoardMe_BlockLoader_InstanceHash"
    const val InteractionID = "OnBoardMe_BlockLoader_Interaction"
  }
}

// Your Pdf Flow Keys
class ContextAwareSigningPdfKeys{
  companion object {
    val firstName=  DocumentTokensModel(476, 84, "firstname", "firstname", 1)
    val motherName=  DocumentTokensModel(477, 84, "mothername", "mothername", 1)
    val familyName=  DocumentTokensModel(478, 84, "family name", "family name", 1)
    val placeOfBirth=  DocumentTokensModel(479, 84, "placeofbirth", "placeofbirth", 1)
    val fatherName=  DocumentTokensModel(480, 84, "fathername", "fathername", 1)
    val gender=  DocumentTokensModel(481, 84, "gender", "gender", 1)
    val dateOfBirth=  DocumentTokensModel(482, 84, "dateofbirth", "dateofbirth",2)
    val nationality=  DocumentTokensModel(483, 84, "nationality", "nationality", 1)
    val country=  DocumentTokensModel(484, 84, "country", "country", 1)
    val occupation=  DocumentTokensModel(485, 84, "occupation", "occupation", 1)
    val city=  DocumentTokensModel(486, 84, "city", "city", 1)
    val companyName=  DocumentTokensModel(487, 84, "companyname", "companyname", 1)
    val averageIncome=  DocumentTokensModel(488, 84, "AverageIncome", "AverageIncome", 1)
    val face=  DocumentTokensModel(489, 84, "face", "face", 3);
    val KYC=  DocumentTokensModel(491, 84, "KYC", "KYC", 3)
  }
}






