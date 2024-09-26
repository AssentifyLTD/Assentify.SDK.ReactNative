export interface AssentifySdkCallback {
  onAssentifySdkInitError: (message: string) => string;
  onAssentifySdkInitSuccess: (stepDefinitions: any[]) => string;
}

export type EnvironmentalConditions = {
  BRIGHTNESS_HIGH_THRESHOLD: number;
  BRIGHTNESS_LOW_THRESHOLD: number;
  PREDICTION_LOW_PERCENTAGE: number;
  PREDICTION_HIGH_PERCENTAGE: number;
  CustomColor: string;
  HoldHandColor: string;
};

export interface Assentify {
  initialize: (
    apiKey: string,
    tenantIdentifier: string,
    instanceHash: string,
    processMrz?: boolean,
    storeCapturedDocument?: boolean,
    performLivenessDetection?: boolean,
    storeImageStream?: boolean,
    saveCapturedVideoID?: boolean,
    saveCapturedVideoFace?: boolean,
    ENV_BRIGHTNESS_HIGH_THRESHOLD?: number,
    ENV_BRIGHTNESS_LOW_THRESHOLD?: number,
    ENV_PREDICTION_LOW_PERCENTAGE?: number,
    ENV_PREDICTION_HIGH_PERCENTAGE?: number,
    ENV_CustomColor?: string,
    ENV_HoldHandColor?: string
  ) => void;
}

export type MrzFields = {
  mrz_type?: string;
  mrz_ocr?: string;
  surname?: string;
  name?: string;
  country?: string;
  nationality?: string;
  birth_date?: string;
  birth_date_hash?: string;
  expiry_date?: string;
  expiry_date_hash?: string;
  sex?: string;
  document_type?: string;
  document_number?: string;
  country_of_issuance?: string;
  department_of_issuance?: string;
  office_of_issuance?: string;
  year_of_issuance?: string;
  month_of_issuance?: string;
  management_center_unique_id?: string;
  management_center_unique_id_hash?: string;
  optional_data?: string;
};

export type MrzReading = {
  MrzFields: MrzFields;
  MrzType?: string;
};

export type FaceCoordinates = {
  Angle?: number;
  Confidence?: number;
  CroppedFace?: string;
  Height?: number;
  TopLeftX?: number;
  TopLeftY?: number;
  Width?: number;
};

export type Faces = {
  FaceBytes?: string;
  FaceImageType?: number;
  FaceUrl?: string;
  Id?: string;
  FaceCoordinates: FaceCoordinates;
};

export type IdentificationDocument = {
  mrz_reading?: MrzReading;
  faces?: Faces[];
  imageUrl?: string;
  videoUrl?: string;
};

export type FaceMatchModel = {
  baseImageFace: string;
  secondImageFace: string;
  percentageMatch: number;
};

export type IdCardComponentListItem = {
  componentName: string;
  componentValue: string;
};

export type IdCardResult = {
  componentList: IdCardComponentListItem[];
};

export type OnIdCardCompletedData = {
  idCardImageUrl: string;
  idCardResult: IdCardResult;
  signature: string;
};

export type ImageFace = {
  FaceBytes: any | null;
  FaceCoordinates: any | null;
  FaceImageType: number;
  FaceUrl: string;
  Id: string;
};

export type FaceMatchCallback = {
  BaseImageFace: ImageFace;
  SecondImageFace: ImageFace;
  PercentageMatch: number;
  ChebyDist?: number;
  CityDist?: number;
  Color?: boolean;
  CosDist?: number;
  Gender?: any | null;
  MatchFaceResult?: number;
  MatchName?: any | null;
  Result?: boolean;
  Size?: boolean;
  SubjectId?: any | null;
};

export type KycDocumentDetails = {
  name: string;
  order: number;
  templateProcessingKeyInformation: string;
};

export type Templates = {
  id: number;
  sourceCountryFlag: string;
  sourceCountryCode: string;
  sourceCountry: string;
  kycDocumentType: string;
  kycDocumentDetails: KycDocumentDetails[];
};

export type TemplatesByCountry = {
  name: string;
  sourceCountryCode: string;
  flag: string;
  templates: Templates[];
};

export enum MotionType {
  NO_DETECT,
  HOLD_YOUR_HAND,
  SENDING,
}

export enum ZoomType {
  NO_DETECT,
  ZOOM_IN,
  ZOOM_OUT,
  SENDING,
}

export const MotionTypeObj = {
  NO_DETECT: 'NO_DETECT',
  HOLD_YOUR_HAND: 'HOLD_YOUR_HAND',
  SENDING: 'SENDING',
};

export const ZoomTypeObj = {
  NO_DETECT: 'NO_DETECT',
  ZOOM_IN: 'ZOOM_IN',
  ZOOM_OUT: 'ZOOM_OUT',
  SENDING: 'SENDING',
};

export enum FAILED_RESULT {
  WRONG_TEMPLATE,
  NO_FACE_DETECTED,
  NO_MRZ_DETECTED,
  EXPIRED_DOCUMENT,
  TAMPERED_DOCUMENT,
  TAMPERED_BACK_DOCUMENT,
  FAILED_FRONT_ID,
  FAILED_BACK_ID,
}

export type PassportDataModel = {
  AdditionalDetails: any;
  FaceUrl: string;
  Faces?: Faces[];
  IdCardImageUrl: string;
  ImageUrl: string;
  IsLive: boolean | null;
  IsSuccessful: boolean;
  MrzImage: string;
  MrzReading?: MrzReading;
  OriginalImageUrl: string;
  OutputProperties: any;
  TraceIdentifier: any;
  VideoUrl: string;
};

export type BaseDataModel = {
  FaceMatchDataModel?: string | FaceMatchCallback;
  IdDataModel?: any;
  OtherDataModel?: any;
  PassportDataModel?: string | PassportDataModel;
};

export type ScanningCallback = {
  onError: BaseDataModel;
  onSend: any;
  onRetry: BaseDataModel;
  onClipPreparationComplete: BaseDataModel;
  onStatusUpdated: BaseDataModel;
  onUpdated: BaseDataModel;
  onLivenessUpdate: BaseDataModel;
  onComplete: BaseDataModel;
  onCardDetected: BaseDataModel;
  onMrzExtracted: BaseDataModel;
  onMrzDetected: BaseDataModel;
  onNoMrzDetected: BaseDataModel;
  onFaceDetected: BaseDataModel;
  onNoFaceDetected: BaseDataModel;
  onFaceExtracted: BaseDataModel;
  onQualityCheckAvailable: BaseDataModel;
  onDocumentCaptured: BaseDataModel;
  onDocumentCropped: BaseDataModel;
  onUploadFailed: BaseDataModel;
  onWrongTemplate: BaseDataModel;
  onEnvironmentalConditionsChange: (
    brightness: number,
    motion: MotionType,
    zoom?: ZoomType
  ) => void;

  SubmitData?: {
    StartSubmitData: boolean;
    instanceHash?: string;
    success: boolean;
    error_message?: string;
  };
};

export type IdentificationDocumentCapture = {
  name: any | null;
  surname: any | null;
  documentType: any | null;
  birthDate: any | null;
  documentNumber: any | null;
  sex: any | null;
  expiryDate: any | null;
  country: any | null;
  nationality: any | null;
  idType: any | null;
  faceCapture: any | null;
  image: any | null;
  isSkippedAfterNFails: any | null;
  isFailedFront: any | null;
  isFailedBack: any | null;
  skippedStatus: any | null;
  capturedVideoFront: any | null;
  capturedVideoBack: any | null;
  livenessStatus: any | null;
  isFrontAuth: any | null;
  isBackAuth: any | null;
  isExpired: any | null;
  isTampering: any | null;
  tamperHeatMap: any | null;
  isBackTampering: any | null;
  backTamperHeatmap: any | null;
  originalFrontImage: any | null;
  originalBackImage: any | null;
  ghostImage: any | null;
  idMaritalStatus: any | null;
  idDateOfIssuance: any | null;
  idCivilRegisterNumber: any | null;
  idPlaceOfResidence: any | null;
  idProvince: any | null;
  idGovernorate: any | null;
  idMothersName: any | null;
  idFathersName: any | null;
  idPlaceOfBirth: any | null;
  idBackImage: any | null;
  idBloodType: any | null;
  idDrivingCategory: any | null;
  idIssuanceAuthority: any | null;
  idArmyStatus: any | null;
  idProfession: any | null;
  idUniqueNumber: any | null;
  idDocumentTypeNumber: any | null;
  idFees: any | null;
  idReference: any | null;
  idRegion: any | null;
  idRegistrationLocation: any | null;
  idFaceColor: any | null;
  idEyeColor: any | null;
  idSpecialMarks: any | null;
  idCountryOfStay: any | null;
  idIdentityNumber: any | null;
  idPresentAddress: any | null;
  idPermanentAddress: any | null;
  idFamilyNumber: any | null;
  identityNumberBack: any | null;
};

export type PassportExtractedModel = {
  outputProperties?: Record<string, any> | null;
  extractedData?: Record<string, any> | null;
  imageUrl?: string | null;
  faces?: Faces[] | null;
  identificationDocumentCapture?: IdentificationDocumentCapture | null;
};

export type OtherExtractedModel = {
  outputProperties?: Record<string, any> | null;
  extractedData?: Record<string, any> | null;
  additionalDetails?: Record<string, any> | null;
  imageUrl?: string | null;
  faces?: Faces[] | null;
  identificationDocumentCapture?: IdentificationDocumentCapture | null;
};

export type IDExtractedModel = {
  outputProperties?: Record<string, any> | null;
  extractedData?: Record<string, any> | null;
  imageUrl?: string;
  faces?: Faces[] | null;
  identificationDocumentCapture?: IdentificationDocumentCapture | null;
};

export type FaceExtractedModel = {
  outputProperties?: Record<string, any> | null;
  extractedData?: Record<string, any> | null;
  baseImageFace?: string | null;
  secondImageFace?: string | null;
  percentageMatch?: number;
  isLive?: boolean;
  identificationDocumentCapture?: IdentificationDocumentCapture | null;
};
